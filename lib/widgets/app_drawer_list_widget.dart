import '../screens/bills_screen.dart';
import 'package:flutter/material.dart';

class AppDrawerListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: SizedBox(
            height: 20,
            width: 20,
            child: Image.asset('assets/images/c_stand.png'),
          ),
          title: Text('Products'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        ListTile(
          leading: SizedBox(
            height: 20,
            width: 20,
            child: Image.asset('assets/images/c_bill.png'),
          ),
          title: Text('Bills'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(BillsScreen.routeName);
          },
        ),
      ],
    );
  }
}
