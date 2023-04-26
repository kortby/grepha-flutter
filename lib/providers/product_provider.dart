import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchAllProducts() async {
    var url = Uri.tryParse(
        'https://grepha-2bfb7-default-rtdb.firebaseio.com/product.json');
    try {
      final response = await http.get(url!);
      final data = json.decode(response.body) as Map<String, dynamic>;
      List<Product> loadedData = [];
      data.forEach((key, value) {
        loadedData.add(
          Product(
              id: key,
              title: value['title'],
              description: value['description'],
              price: value['price'],
              imageUrl: value['imageUrl'],
              isFavorite: value['isFavorite']),
        );
      });
      _items = loadedData;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Future<void> addProduct(Product prod) async {
    var url = Uri.tryParse(
        'https://grepha-2bfb7-default-rtdb.firebaseio.com/product.json');
    try {
      final response = await http.post(
        url!,
        body: json.encode({
          'title': prod.title,
          'description': prod.description,
          'price': prod.price,
          'imageUrl': prod.title,
          'isFavorite': prod.isFavorite,
        }),
      );
      final product = Product(
        id: json.decode(response.body)['name'],
        title: prod.title,
        description: prod.description,
        price: prod.price,
        imageUrl: prod.imageUrl,
      );
      _items.add(product);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void updateProduct(String id, Product prod) {
    print('updating provider ======');
    final productToUpdateIndex =
        _items.indexWhere((product) => product.id == id);
    if (productToUpdateIndex >= 0) {
      _items[productToUpdateIndex] = prod;
    }
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
