import 'package:flutter/material.dart';
import '../models/Bill.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class BillItem extends StatefulWidget {
  final Bill bill;
  BillItem(this.bill);

  @override
  _BillItemState createState() => _BillItemState();
}

class _BillItemState extends State<BillItem> {
  var _expanded = false;

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final ids = widget.bill.names.keys.toList();
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.bill.names.keys.length * 20.0 + 110, 200) : 95,
      child: Card(
        margin: EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$${widget.bill.totalPrice.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.bill.time),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              height: _expanded
                  ? min(widget.bill.names.keys.length * 20.0 + 10, 100)
                  : 0,
              child: ListView.builder(
                itemCount: ids.length,
                itemBuilder: (ctx, i) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.bill.names[ids[i]],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.bill.quantity[ids[i]]}x \$${widget.bill.quantity[ids[i]] * widget.bill.prices[ids[i]]}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
