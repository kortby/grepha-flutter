import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/models/http_exception.dart';
import 'package:shop/models/product.dart';

import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<Product> _items = [];

  final String authToken;
  final String userId;

  ProductProvider(this.authToken, this._items, this.userId);

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchAllProducts() async {
    final url = Uri.tryParse(
        'https://grepha-2bfb7-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.get(url!);
      final data = json.decode(response.body) as Map<String, dynamic>;
      List<Product> loadedData = [];
      if (data == null) return;
      // fetch fav
      final favUrl = Uri.tryParse(
          'https://grepha-2bfb7-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favResponse = await http.get(favUrl!);
      final favData = json.decode(favResponse.body);
      data.forEach((key, value) {
        loadedData.add(
          Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite: favData == null ? false : favData[key] ?? false,
          ),
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
        'https://grepha-2bfb7-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url!,
        body: json.encode({
          'title': prod.title,
          'description': prod.description,
          'price': prod.price,
          'imageUrl': prod.imageUrl,
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
          'https://grepha-2bfb7-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
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

  Future<void> deleteProduct(String id) async {
    var url = Uri.tryParse(
        'https://grepha-2bfb7-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final existingProdIdx = _items.indexWhere((element) => element.id == id);
    var existingProd = _items[existingProdIdx];
    _items.removeAt(existingProdIdx);
    final response = await http.delete(url!);
    notifyListeners();

    if (response.statusCode >= 400) {
      _items.insert(existingProdIdx, existingProd);
      throw HttpException('Could Not delete product');
      notifyListeners();
    }
  }
}
