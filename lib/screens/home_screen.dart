import '../providers/products.dart';
import '../screens/purchases_list_screen.dart';
import '../providers/cart.dart';
import '../widgets/sort_menu_widget.dart';
import 'package:provider/provider.dart';
import '../widgets/badge_widget.dart';
import '../widgets/categories_drop_down_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/add_new_product.dart';
import '../widgets/products_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  void _startAddNewProduct(BuildContext ctx) {
    showCupertinoModalPopup(
      context: ctx,
      builder: (_) {
        return Dialog(
          child: AddNewProduct(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final products = Provider.of<Products>(context, listen: false);
    final searchContainer = Container(
      margin: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0, bottom: 0),
      decoration: BoxDecoration(
        color: Color(0xFFE0E0E0),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: TextField(
        cursorColor: Colors.grey,
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        onChanged: (text) {
          setState(() {
            print(text);
            products..titleFilters = text;
            products.filterResult();
          });
        },
        maxLines: 1,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey,
            size: 23,
          ),
          border: InputBorder.none,
          hintText: 'Search Products...',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 18.0),
        ),
        controller: _searchController,
        onSubmitted: (_) {},
      ),
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewProduct(context),
        child: Icon(Icons.add),
        tooltip: 'Add Product',
      ),
      appBar: AppBar(
        title: const Text('El-Lista'),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => PurchasesListScreen()));
              },
            ),
          ),
          SortMenuWidget(),
        ],
      ),
      drawer: AppDrawer(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              searchContainer,
              CategoriesDropDownButton(),
              Container(
                height: mediaQuery.size.height -
                    AppBar().preferredSize.height -
                    mediaQuery.padding.top -
                    108,
                width: mediaQuery.size.width,
                child: ProductsListWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
