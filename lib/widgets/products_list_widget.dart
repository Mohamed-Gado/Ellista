import '../models/categories_list.dart';
import '../screens/product_details_screen.dart';
import '../models/product.dart';
import '../providers/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class ProductsListWidget extends StatefulWidget {
  const ProductsListWidget({
    Key key,
  }) : super(key: key);

  @override
  _ProductsListWidgetState createState() => _ProductsListWidgetState();
}

class _ProductsListWidgetState extends State<ProductsListWidget> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final cart = Provider.of<Cart>(context, listen: false);
    List<Product> products = Provider.of<Products>(context).search;

    return FutureBuilder(
      future:
          Provider.of<Products>(context, listen: false).fetchAndSetProducts(),
      builder: (ctx, snapshot) {
        return products.length <= 0
            ? Center(
                child: Image.asset(
                  'assets/images/c_empty.png',
                  height: mediaQuery.size.width / 4,
                  width: mediaQuery.size.width / 4,
                ),
              )
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (ctx, index) {
                  return Slidable(
                    dismissal: SlidableDismissal(
                      dragDismissible: false,
                      child: SlidableDrawerDismissal(),
                      closeOnCanceled: true,
                    ),
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    key: Key(products[index].id),
                    child: Card(
                      color: Colors.white,
                      child: ListTile(
                        leading: SizedBox(
                          child: CategoriesList()
                              .getCategoryIcon(products[index].category),
                          height: 25,
                          width: 25,
                        ),
                        title: Text(products[index].title),
                        subtitle: Text('${products[index].category}'),
                        trailing: Text(
                          '${products[index].price}\$',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                  product: products[index]),
                            ),
                          );
                        },
                      ),
                    ),
                    actions: [
                      IconSlideAction(
                        closeOnTap: true,
                        icon: Icons.add_shopping_cart,
                        color: Colors.green,
                        caption: 'Add to cart',
                        foregroundColor: Colors.white,
                        onTap: () {
                          cart.addItem(products[index].id,
                              products[index].price, products[index].title);
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added to cart'),
                              action: SnackBarAction(
                                label: 'UNDO',
                                onPressed: () {
                                  cart.removeSingleItem(products[index].id);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    secondaryActions: [
                      IconSlideAction(
                        closeOnTap: true,
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        foregroundColor: Colors.white,
                        onTap: () async {
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
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("CANCEL"),
                                  ),
                                ],
                              );
                            },
                          );
                          if (isConfirm) {
                            setState(
                              () {
                                Provider.of<Products>(context, listen: false)
                                    .deleteProductById(products[index].id);
                                products.removeAt(index);
                              },
                            );
                            Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Deleted')),
                            );
                          } else {
                            return;
                          }
                        },
                      ),
                    ],
                  );
                },
              );
      },
    );
  }
}
