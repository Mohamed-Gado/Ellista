import '../models/product.dart';
import '../providers/bills.dart';
import '../providers/products.dart';
import '../screens/home_screen.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../providers/cart.dart' show Cart;
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';

class PurchasesListScreen extends StatefulWidget {
  const PurchasesListScreen({Key key}) : super(key: key);

  @override
  _PurchasesListScreenState createState() => _PurchasesListScreenState();
}

class _PurchasesListScreenState extends State<PurchasesListScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final cart = Provider.of<Cart>(context);
    final products = Provider.of<Products>(context, listen: false);
    Map<String, String> namesMap = {};
    Map<String, int> quantityMap = {};
    Map<String, double> pricesMap = {};
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Purchases'),
        actions: [
          IconButton(
            icon: Icon(Icons.camera),
            tooltip: "Scan",
            onPressed: () => scan(products, cart),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: ListView.builder(
              itemBuilder: (ctx, i) {
                if (quantityMap.containsKey(cart.items.keys.toList()[i])) {
                  quantityMap.update(
                      cart.items.keys.toList()[i],
                      (existingCartItem) =>
                          cart.items.values.toList()[i].quantity);
                } else {
                  quantityMap.putIfAbsent(cart.items.keys.toList()[i],
                      () => cart.items.values.toList()[i].quantity);
                }
                if (pricesMap.containsKey(cart.items.keys.toList()[i])) {
                  pricesMap.update(
                      cart.items.keys.toList()[i],
                      (existingCartItem) =>
                          cart.items.values.toList()[i].price);
                } else {
                  pricesMap.putIfAbsent(cart.items.keys.toList()[i],
                      () => cart.items.values.toList()[i].price);
                }
                if (namesMap.containsKey(cart.items.keys.toList()[i])) {
                  namesMap.update(
                      cart.items.keys.toList()[i],
                      (existingCartItem) =>
                          cart.items.values.toList()[i].title);
                } else {
                  namesMap.putIfAbsent(cart.items.keys.toList()[i],
                      () => cart.items.values.toList()[i].title);
                }
                return CartItem(
                    productId: cart.items.keys.toList()[i],
                    id: cart.items.values.toList()[i].id,
                    title: cart.items.values.toList()[i].title,
                    quantity: cart.items.values.toList()[i].quantity,
                    price: cart.items.values.toList()[i].price);
              },
              itemCount: cart.items.length,
            ),
          ),
          Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: mediaQuery.size.width,
              child: FlatButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  if (cart.items.isNotEmpty) {
                    Provider.of<Bills>(context, listen: false).addBill(
                      cart.totalAmount,
                      namesMap,
                      quantityMap,
                      pricesMap,
                      DateTime.now(),
                    );
                    Provider.of<Cart>(context, listen: false).clear();
                    Fluttertoast.showToast(
                        msg: 'Your Bill Added Successfully!',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        backgroundColor: Colors.grey[700]);
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => HomeScreen()));
                  } else {
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text('Your cart is empty'),
                      ),
                    );
                  }
                },
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
