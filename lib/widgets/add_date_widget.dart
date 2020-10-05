import 'package:flutter/material.dart';
import './adaptive_flat_button.dart';
import 'package:intl/intl.dart';

class AddDateWidget extends StatefulWidget {
  const AddDateWidget({Key key}) : super(key: key);

  @override
  _AddDateWidgetState createState() => _AddDateWidgetState();
}

class _AddDateWidgetState extends State<AddDateWidget> {
  DateTime _selectedDate;
  @override
  Widget build(BuildContext context) {
    void _presentDatePicker() {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050),
      ).then((pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(() {
          _selectedDate = pickedDate;
        });
      });
    }

    return Container(
      height: 70,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              _selectedDate == null
                  ? 'No Date Chosen!'
                  : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
            ),
          ),
          AdaptiveFlatButton('Choose Date', _presentDatePicker)
        ],
      ),
    );
  }
}
