import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(
    String prodId,
    String token,
    String userId,
  ) async {
    var url = Uri.tryParse(
        'https://grepha-2bfb7-default-rtdb.firebaseio.com/userFavorites/$userId/$prodId.json?auth=$token');
    final oldStatus = isFavorite;
    isFavorite = !oldStatus;
    notifyListeners();
    try {
      final response = await http.put(
        url!,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
      }
      notifyListeners();
    } catch (e) {
      isFavorite = oldStatus;
      throw e;
    }
  }
}
