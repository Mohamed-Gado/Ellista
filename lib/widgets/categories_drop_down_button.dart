import '../providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../models/categories_list.dart';

class CategoriesDropDownButton extends StatefulWidget {
  const CategoriesDropDownButton({Key key}) : super(key: key);

  @override
  _CategoriesDropDownButtonState createState() =>
      _CategoriesDropDownButtonState();
}

class _CategoriesDropDownButtonState extends State<CategoriesDropDownButton> {
  Category selectedCategory;
  List<Category> categoriesList = CategoriesList().getCategoriesList();

  @override
  void initState() {
    categoriesList.add(
      Category(
        title: 'All Categories',
        icon: Image.asset(
          ('assets/images/c_all.png'),
        ),
      ),
    );
    selectedCategory = categoriesList.last;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context, listen: false);
    categoriesList.sort((a, b) => a.title.compareTo(b.title));
    return DropdownButton<Category>(
      hint: Text('Select Category'),
      value: selectedCategory,
      items: categoriesList.map(
        (cat) {
          return DropdownMenuItem<Category>(
            value: cat,
            child: Card(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: cat.icon,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    cat.title,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          );
        },
      ).toList(),
      onChanged: (category) {
        setState(() {
          selectedCategory = category;
          products..categoryFilter = category.title;
          products.filterResult();
        });
      },
    );
  }
}
