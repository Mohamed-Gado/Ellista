import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/Bill.dart';
import '../helpers/db_bills.dart';

class Bills with ChangeNotifier {
  List<Bill> _bills = [];

  List<Bill> get bills {
    return [..._bills];
  }

  Future<void> addBill(
    double totalPrice,
    Map<String, String> productsNames,
    Map<String, int> quantity,
    Map<String, double> prices,
    DateTime time,
  ) async {
    final newBill = Bill(
      id: '$totalPrice+=${DateTime.now()}',
      names: productsNames,
      quantity: quantity,
      time: time,
      totalPrice: totalPrice,
      prices: prices,
    );
    _bills.add(newBill);
    notifyListeners();
    String names = json.encode(newBill.names);
    String productQuantity = json.encode(newBill.quantity);
    String productsPrices = json.encode(newBill.prices);
    DbBills.insert(
      'user_bills',
      {
        'id': newBill.id,
        'totalPrice': newBill.totalPrice,
        'names': names,
        'quantity': productQuantity,
        'prices': productsPrices,
        'time': newBill.time.toString(),
      },
    );
  }

  Future<void> fetchAndSetBills() async {
    final dataList = await DbBills.getData('user_bills');
    _bills = dataList
        .map(
          (item) => Bill(
            id: item['id'],
            totalPrice: item['totalPrice'],
            names: json.decode(item['names']),
            quantity: json.decode(item['quantity']),
            prices: json.decode(item['prices']),
            time: DateTime.parse(item['time']),
          ),
        )
        .toList();
    _bills.sort((a, b) => b.time.compareTo(a.time));
    notifyListeners();
  }

  void sortByTime(bool isNewest) {
    if (isNewest) {
      _bills.sort((a, b) => b.time.compareTo(a.time));
    } else {
      _bills.sort((a, b) => a.time.compareTo(b.time));
    }
    notifyListeners();
  }

  void sortByPrice(bool isLow) {
    if (isLow) {
      _bills.sort((a, b) => a.totalPrice.compareTo(b.totalPrice));
    } else {
      _bills.sort((a, b) => b.totalPrice.compareTo(a.totalPrice));
    }
    notifyListeners();
  }
}
