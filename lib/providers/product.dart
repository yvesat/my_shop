import 'dart:convert';

import 'package:flutter/material.dart';
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

  Future<bool> toggleFavorite() async {
    isFavorite = !isFavorite;
    final url = Uri.parse('https://myshop-f4884-default-rtdb.firebaseio.com/products/$id.json');
    final response = await http.patch(
      url,
      body: json.encode(
        {
          'isFavorite': isFavorite,
        },
      ),
    );
    if (response.statusCode < 400) {
      notifyListeners();
      return true;
    }
    isFavorite = !isFavorite;
    return false;
  }
}
