import 'package:flutter/material.dart';
import '../providers/cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderItem {
  final String? id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<bool> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse('https://myshop-f4884-default-rtdb.firebaseio.com/orders.json');
    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map(
                (cartProduct) => {
                  'id': cartProduct.id,
                  'imageUrl': cartProduct.imageUrl,
                  'title': cartProduct.title,
                  'quantity': cartProduct.quantity,
                  'price': cartProduct.price,
                },
              )
              .toList(),
        },
      ),
    );
    if (response.statusCode < 400) {
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['id'],
          amount: total,
          dateTime: DateTime.now(),
          products: cartProducts,
        ),
      );
      notifyListeners();
      return true;
    }
    return false;
  }
}
