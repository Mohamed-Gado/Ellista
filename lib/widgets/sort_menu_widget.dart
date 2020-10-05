import '../providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo_menu_item.dart';

class SortMenuWidget extends StatelessWidget {
  final List<TodoMenuItem> menuList = [
    TodoMenuItem(
      title: 'Title',
    ),
    TodoMenuItem(
      title: 'Low Price',
    ),
    TodoMenuItem(
      title: 'High Price',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TodoMenuItem>(
      icon: Icon(Icons.more_vert),
      onSelected: (val) {
        switch (val.title) {
          case ('Title'):
            Provider.of<Products>(context, listen: false).sortByTitle();
            break;
          case ('Low Price'):
            Provider.of<Products>(context, listen: false).sortByPrice(true);
            break;
          case ('High Price'):
            Provider.of<Products>(context, listen: false).sortByPrice(false);
            break;
        }
      },
      itemBuilder: (ctx) {
        return menuList.map((todoMenuItem) {
          return PopupMenuItem<TodoMenuItem>(
            value: todoMenuItem,
            child: Row(
              children: <Widget>[Text(todoMenuItem.title)],
            ),
          );
        }).toList();
      },
    );
  }
}
