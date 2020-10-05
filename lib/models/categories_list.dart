import './category.dart';
import 'package:flutter/material.dart';

class CategoriesList {
  final List<Category> categoriesList = [
    Category(
      title: 'Food',
      icon: Image.asset(
        ('assets/images/c_food.png'),
      ),
    ),
    Category(
      title: 'Electronics',
      icon: Image.asset(
        ('assets/images/c_electronics.png'),
        fit: BoxFit.scaleDown,
      ),
    ),
    Category(
      title: 'Clothes',
      icon: Image.asset(
        ('assets/images/c_clothes.png'),
      ),
    ),
    Category(
      title: 'Books',
      icon: Image.asset(
        ('assets/images/c_book.png'),
        fit: BoxFit.scaleDown,
      ),
    ),
    Category(
      title: 'Medicines',
      icon: Image.asset(
        ('assets/images/c_medicines.png'),
        fit: BoxFit.scaleDown,
      ),
    ),
    Category(
      title: 'Decor',
      icon: Image.asset(
        ('assets/images/c_decor.png'),
        fit: BoxFit.scaleDown,
      ),
    ),
    Category(
      title: 'Other',
      icon: Image.asset(
        ('assets/images/c_other.png'),
      ),
    ),
  ];

  List<Category> getCategoriesList() {
    return categoriesList;
  }

  Image getCategoryIcon(String catTitle) {
    return categoriesList
        .firstWhere((element) => element.title == catTitle)
        .icon;
  }
}
