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
        'https://grepha-2bfb7-default-rtdb.firebaseio.com/products.json');
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
        'https://grepha-2bfb7-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.post(
        url!,
        body: json.encode({
          'title': prod.title,
          'description': prod.description,
          'price': prod.price,
          'imageUrl': prod.imageUrl,
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

  Future<void> updateProduct(String id, Product prod) async {
    final productToUpdateIndex =
        _items.indexWhere((product) => product.id == id);
    if (productToUpdateIndex >= 0) {
      var url = Uri.tryParse(
          'https://grepha-2bfb7-default-rtdb.firebaseio.com/products/$id.json');
      await http.patch(
        url!,
        body: json.encode({
          'title': prod.title,
          'description': prod.description,
          'imageUrl': prod.imageUrl,
          'price': prod.price,
        }),
      );
      _items[productToUpdateIndex] = prod;
    }
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void deleteProduct(String id) async {
    var url = Uri.tryParse(
        'https://grepha-2bfb7-default-rtdb.firebaseio.com/products/$id.json');
    final existingProdIdx = _items.indexWhere((element) => element.id == id);
    final existingProd = _items[existingProdIdx];
    _items.removeAt(existingProdIdx);
    await http.delete(url!).catchError((_) {
      _items.insert(existingProdIdx, existingProd);
    });
    notifyListeners();
  }
}
