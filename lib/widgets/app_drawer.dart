import 'package:flutter/material.dart';
import './app_drawer_list_widget.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          AppBar(
            flexibleSpace: Image.asset(
              'assets/images/ellista.png',
              fit: BoxFit.cover,
            ),
            automaticallyImplyLeading: false,
          ),
          AppDrawerListWidget(),
        ],
      ),
    );
  }
}
