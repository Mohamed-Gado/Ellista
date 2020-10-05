import '../models/category.dart';
import '../providers/cart.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/product.dart';
import '../models/categories_list.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({
    Key key,
    @required this.product,
  }) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool isEdit = false;
  TextEditingController _titleController;
  TextEditingController _codeController;
  TextEditingController _priceController;
  TextEditingController _notesController;
  Category selectedCategory;
  List<Category> categoriesList = CategoriesList().getCategoriesList();

  var _aspectTolerance = 0.00;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;
  ScanResult scanResult;
  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);
  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  Future scan(Products products, Cart cart) async {
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
      setState(() {
        scanResult = result;
        Product product = products.findByBarcode(result.rawContent);
        if (product != null) {
          cart.addItem(product.id, product.price, product.title);
        } else {
          Fluttertoast.showToast(
            msg: "this product doesn't exist. Try to add it!",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.grey[700],
          );
          print("doesn't exist");
        }
      });
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
  void initState() {
    _titleController = TextEditingController(
      text: widget.product.title,
    );
    _codeController = TextEditingController(
      text:
          widget.product.codeContent != null && widget.product.codeContent != ''
              ? widget.product.codeContent
              : 'No code to show.',
    );
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _notesController = TextEditingController(
      text: widget.product.notes != null ? widget.product.notes : '',
    );
    selectedCategory = categoriesList
        .firstWhere((element) => element.title == widget.product.category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final products = Provider.of<Products>(context, listen: false);
    categoriesList.sort((a, b) => a.title.compareTo(b.title));
    _launchURL(url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              actions: [
                IconButton(
                  icon: isEdit ? Icon(Icons.check) : Icon(Icons.edit),
                  onPressed: () {
                    if (isEdit) {
                      if (_titleController.text.isNotEmpty &&
                          _priceController.text.isNotEmpty) {
                        Provider.of<Products>(context, listen: false)
                            .updateProduct(
                          widget.product.id,
                          Product(
                            id: widget.product.id,
                            title: _titleController.text,
                            price: double.parse(_priceController.text),
                            category: selectedCategory.title,
                            codeContent: scanResult != null
                                ? scanResult.rawContent
                                : widget.product.codeContent,
                            notes: _notesController.text,
                          ),
                        );
                        setState(() {
                          isEdit = !isEdit;
                        });
                        Navigator.of(context).pop();
                        Fluttertoast.showToast(
                          msg: 'Sucessfully Done',
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: Colors.grey[700],
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Please Complete all Fields!',
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: Colors.grey[700],
                        );
                      }
                    } else {
                      setState(() {
                        isEdit = !isEdit;
                      });
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    final isConfirm = await showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: Text('Delete'),
                          content: Text(
                              'Are you sure you want to Delete this product?'),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text("DELETE")),
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("CANCEL"),
                            ),
                          ],
                        );
                      },
                    );
                    if (isConfirm) {
                      setState(() {
                        Provider.of<Products>(context, listen: false)
                            .deleteProductById(widget.product.id);
                      });
                      Fluttertoast.showToast(
                        msg: 'Deleted',
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Colors.grey[700],
                      );
                      Navigator.of(context).pop();
                    } else {
                      return;
                    }
                  },
                ),
              ],
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(widget.product.title),
                background:
                    CategoriesList().getCategoryIcon(widget.product.category),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      leading: SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset('assets/images/c_title.png'),
                      ),
                      title: TextField(
                        maxLines: 1,
                        enabled: isEdit,
                        controller: _titleController,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      leading: SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset('assets/images/c_price.png'),
                      ),
                      title: TextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                        ],
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        enabled: isEdit,
                        controller: _priceController,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  if (isEdit)
                    Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        leading: SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset('assets/images/c_category.png'),
                        ),
                        title: IgnorePointer(
                          ignoring: !isEdit,
                          child: DropdownButton<Category>(
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
                                            style:
                                                TextStyle(color: Colors.black),
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
                              }),
                        ),
                      ),
                    ),
                  Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      leading: SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset('assets/images/c_barcode.png'),
                      ),
                      title: TextField(
                        onTap: widget.product.codeContent != null &&
                                widget.product.codeContent.contains('https://')
                            ? () => _launchURL(widget.product.codeContent)
                            : null,
                        controller: _codeController,
                        enabled: false,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      trailing: isEdit
                          ? IconButton(
                              icon: Icon(Icons.camera),
                              tooltip: "Scan",
                              onPressed: () => scan(products, cart))
                          : null,
                    ),
                  ),
                  Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      leading: SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset('assets/images/c_notes.png'),
                      ),
                      title: TextField(
                        enabled: isEdit,
                        maxLines: 2,
                        controller: _notesController,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
