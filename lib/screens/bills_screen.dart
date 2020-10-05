import '../providers/bills.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/bill_item.dart';
import '../models/todo_menu_item.dart';

class BillsScreen extends StatelessWidget {
  static const routeName = '/bills';
  final List<TodoMenuItem> menuList = [
    TodoMenuItem(
      title: 'Newest',
    ),
    TodoMenuItem(
      title: 'Oldest',
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Bills'),
        actions: [
          PopupMenuButton<TodoMenuItem>(
            icon: Icon(Icons.more_vert),
            onSelected: (val) {
              switch (val.title) {
                case ('Newest'):
                  Provider.of<Bills>(context, listen: false).sortByTime(true);
                  break;
                case ('Oldest'):
                  Provider.of<Bills>(context, listen: false).sortByTime(false);
                  break;
                case ('Low Price'):
                  Provider.of<Bills>(context, listen: false)
                      .sortByPrice(true);
                  break;
                case ('High Price'):
                  Provider.of<Bills>(context, listen: false)
                      .sortByPrice(false);
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
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Bills>(context, listen: false).fetchAndSetBills(),
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapShot.error != null) {
              return Center(
                child: Text(
                    'An error occurred! : ${dataSnapShot.error.toString()}'),
              );
            } else {
              return Consumer<Bills>(
                child: Center(child: Text('Your Bill list is empty!')),
                builder: (ctx, billsData, child) => billsData.bills.isEmpty
                    ? child
                    : ListView.builder(
                        itemBuilder: (ctx, i) {
                          return BillItem(billsData.bills[i]);
                        },
                        itemCount: billsData.bills.length,
                      ),
              );
            }
          }
        },
      ),
    );
  }
}
