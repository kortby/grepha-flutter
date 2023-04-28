import 'dart:convert';

import 'package:flutter/cupertino.dart';
import './cart_provider.dart';

import 'package:http/http.dart' as http;

class Order {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  Order({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  final String authToken;

  OrderProvider(this.authToken, this._orders);

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final timestamp = DateTime.now();
    var url = Uri.tryParse(
        'https://grepha-2bfb7-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    final response = await http.post(
      url!,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProduct
            .map((p) => {
                  'id': p.id,
                  'title': p.title,
                  'quantity': p.quantity,
                  'price': p.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      Order(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProduct,
        dateTime: timestamp,
      ),
    );
  }

  Future<void> fetchOrders() async {
    var url = Uri.tryParse(
        'https://grepha-2bfb7-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    final response = await http.get(url!);
    final List<Order> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) return;
    extractedData.forEach((key, value) {
      loadedOrders.add(Order(
        id: key,
        amount: value['amount'],
        products: (value['products'] as List<dynamic>)
            .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price'],
                ))
            .toList(),
        dateTime: DateTime.parse(value['dateTime']),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
