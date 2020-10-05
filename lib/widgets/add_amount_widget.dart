import 'package:flutter/material.dart';

class AddAmountWidget extends StatefulWidget {
  const AddAmountWidget({Key key}) : super(key: key);

  @override
  _AddAmountWidgetState createState() => _AddAmountWidgetState();
}

class _AddAmountWidgetState extends State<AddAmountWidget> {
  int amount = 1;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(child: Text('Amount')),
        IconButton(
          alignment: Alignment.topCenter,
          icon: Icon(
            Icons.minimize,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            if (amount > 1) {
              setState(() {
                amount--;
              });
            } else {
              return;
            }
          },
        ),
        Text('$amount'),
        IconButton(
          color: Colors.white,
          icon: Icon(
            Icons.add,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            setState(() {
              amount++;
            });
          },
        ),
      ],
    );
  }
}
