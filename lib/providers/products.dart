import '../helpers/db_helpers.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  List<Product> _search = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get search {
    return [..._search];
  }

  String _title;
  set titleFilters(String title) {
    _title = title;
  }

  String _category;
  set categoryFilter(String category) {
    _category = category;
  }

  Future<void> addProduct(
    String title,
    double price,
    String category,
    String notes,
    String codeContent,
  ) async {
    final newProduct = Product(
      id: '$category+=${DateTime.now()}',
      title: title,
      price: price,
      category: category,
      notes: notes,
      codeContent: codeContent,
    );

    _items.add(newProduct);
    filterResult();
    notifyListeners();
    DBHelper.insert(
      'user_products',
      {
        'id': newProduct.id,
        'title': newProduct.title,
        'price': newProduct.price,
        'category': newProduct.category,
        'notes': newProduct.notes,
        'codeContent': newProduct.codeContent,
      },
    );
  }

  Product findById(String id) {
    return _items.firstWhere(
      (element) => element.id == id,
      orElse: () => null,
    );
  }

  Product findByBarcode(String barcode) {
    return _items.firstWhere(
      (element) => element.codeContent == barcode,
      orElse: () => null,
    );
  }

  List<Product> findByCategory(String category, List<Product> products) {
    return products.where((element) => element.category == category).toList();
  }

  List<Product> findByTitle(String text, List<Product> products) {
    final result = products
        .where((element) => element.title
            .toLowerCase()
            .trim()
            .contains(text.toLowerCase().trim()))
        .toList();
    return result;
  }

  void sortByTitle() {
    _search.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    notifyListeners();
  }

  void sortByPrice(bool isLow) {
    if (isLow) {
      _search.sort((a, b) => a.price.compareTo(b.price));
      notifyListeners();
    } else {
      _search.sort((a, b) => b.price.compareTo(a.price));
    }
  }

  void filterResult() {
    bool isText = _title != null && _title != '';
    bool isCaregory =
        _category != null && _category != '' && _category != 'All Categories';
    _search = _items;
    notifyListeners();

    if (isText && isCaregory) {
      _search = findByCategory(_category, _search);
      _search = findByTitle(_title, _search);
      print(_search.length);
      notifyListeners();
    } else if (isText) {
      _search = findByTitle(_title, _search);
      print(_search.length);
      notifyListeners();
    } else if (isCaregory) {
      _search = findByCategory(_category, _search);
      print(_category);
      notifyListeners();
    } else {
      _search = _items;
      notifyListeners();
      return;
    }
  }

  Future<void> fetchAndSetProducts() async {
    final dataList = await DBHelper.getData('user_products');
    _items = dataList
        .map(
          (item) => Product(
            id: item['id'],
            title: item['title'],
            category: item['category'],
            price: item['price'],
            codeContent: item['codeContent'],
            notes: item['notes'],
          ),
        )
        .toList();
    notifyListeners();
    if (_title == null && _category == null && _search.isEmpty) {
      _search = _items;
    }
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    final searchIndex = _search.indexWhere((element) => element.id == id);
    if (searchIndex >= 0) {
      _search[searchIndex] = newProduct;
      notifyListeners();
    }
    _items[prodIndex] = newProduct;
    notifyListeners();
    DBHelper.update(
      {
        'id': newProduct.id,
        'title': newProduct.title,
        'price': newProduct.price,
        'category': newProduct.category,
        'notes': newProduct.notes,
        'codeContent': newProduct.codeContent,
      },
      id,
    );
  }

  Future<void> deleteProductById(String id) async {
    await DBHelper.delete('user_products', id);
    notifyListeners();
  }
}
