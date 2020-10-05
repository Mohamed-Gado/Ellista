import 'package:flutter/material.dart';
import '../models/todo_menu_item.dart';

class TodoMenuWidget extends StatelessWidget {
  final List<TodoMenuItem> foodMenuList = [
    TodoMenuItem(
      title: 'Date',
      icon: Image.asset(''),
    ),
    TodoMenuItem(
      title: 'Title',
      icon: Image.asset(''),
    ),
    TodoMenuItem(
      title: 'Low Price',
      icon: Image.asset(''),
    ),
    TodoMenuItem(
      title: 'High Price',
      icon: Image.asset(''),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TodoMenuItem>(
      icon: Icon(Icons.more_vert),
      onSelected: (val) {
        print(val.title);
      },
      itemBuilder: (ctx) {
        return foodMenuList.map((todoMenuItem) {
          return PopupMenuItem<TodoMenuItem>(
            value: todoMenuItem,
            child: Row(
              children: <Widget>[
                // Icon(todoMenuItem.icon.icon),
                Padding(padding: EdgeInsets.all(8.0)),
                Text(todoMenuItem.title)
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
