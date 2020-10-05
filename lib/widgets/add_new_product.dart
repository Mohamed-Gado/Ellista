import '../providers/products.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../models/categories_list.dart';
import 'package:barcode_scan/barcode_scan.dart';

class AddNewProduct extends StatefulWidget {
  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  List<Category> categoriesList = CategoriesList().getCategoriesList();
  Category selectedCategory;
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();
  ScanResult scanResult;

  var _aspectTolerance = 0.00;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredPrice = _priceController.text.isEmpty
        ? -1
        : double.parse(_priceController.text);
    final enteredCategory = selectedCategory != null ? selectedCategory : null;
    final enteredNotes = _notesController.text;
    final codeContent = scanResult != null ? scanResult.rawContent : null;

    if (enteredTitle.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter a title!',
        backgroundColor: Colors.grey[700],
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    } else if (enteredPrice < 0) {
      Fluttertoast.showToast(
        msg: 'Please enter a valid price!',
        backgroundColor: Colors.grey[700],
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    } else if (enteredCategory == null) {
      Fluttertoast.showToast(
        msg: 'Please select a category!',
        backgroundColor: Colors.grey[700],
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }
    Provider.of<Products>(context, listen: false).addProduct(enteredTitle,
        enteredPrice, enteredCategory.title, enteredNotes, codeContent);
    Navigator.of(context).pop();
  }

  Future scan() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": 'Cancel',
          "flash_on": 'Flash on',
          "flash_off": 'Flash off',
        },
        restrictFormat: selectedFormats,
        useCamera: _selectedCamera,
        autoEnableFlash: _autoEnableFlash,
        android: AndroidOptions(
          aspectTolerance: _aspectTolerance,
          useAutoFocus: _useAutoFocus,
        ),
      );

      var result = await BarcodeScanner.scan(options: options);

      setState(() => scanResult = result);
    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result.rawContent = 'The user did not grant the camera permission!';
        });
      } else {
        result.rawContent = 'Unknown error: $e';
      }
      setState(() {
        scanResult = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    categoriesList.sort((a, b) => a.title.compareTo(b.title));
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Add Product',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  controller: _titleController,
                  onSubmitted: (_) => _submitData(),
                ),
                TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                  ],
                  decoration: InputDecoration(labelText: 'Price'),
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _submitData(),
                ),
                DropdownButton<Category>(
                  hint: Text('Select Category'),
                  value: selectedCategory,
                  items: categoriesList.map(
                    (cat) {
                      return DropdownMenuItem<Category>(
                        value: cat,
                        child: Card(
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: cat.icon,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                cat.title,
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (category) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text('Scan BarCode'),
                    ),
                    IconButton(
                      icon: Icon(Icons.camera),
                      tooltip: "Scan",
                      onPressed: scan,
                    ),
                  ],
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Notes'),
                  controller: _notesController,
                  maxLines: 3,
                  onSubmitted: (_) => _submitData(),
                ),
                RaisedButton(
                  child: Text('Submit'),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).textTheme.button.color,
                  onPressed: _submitData,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
