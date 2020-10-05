import 'package:flutter/cupertino.dart';

class Product {
  final String id;
  final String title;
  final double price;
  final String category;
  final String notes;
  final String codeContent;

  Product({
    this.id,
    @required this.title,
    @required this.price,
    @required this.category,
    this.notes,
    this.codeContent,
  });
}
