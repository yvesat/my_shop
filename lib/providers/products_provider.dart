import 'package:flutter/material.dart';
import 'dart:convert';
import 'product.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse('https://myshop-f4884-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.get(url);
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach(
        (prodId, prodData) {
          loadedProducts.add(
            Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],
              isFavorite: prodData['isFavorite'],
            ),
          );
        },
      );
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      //todo: add error handling
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse('https://myshop-f4884-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          },
        ),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {}
  }

  Future<void> updateProduct(String id, Product product) async {
    final prodIndex = _items.lastIndexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      try {
        final url = Uri.parse('https://myshop-f4884-default-rtdb.firebaseio.com/products/$id.json');
        // final response =
        await http.patch(
          url,
          body: json.encode(
            {
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
            },
          ),
        );
        _items[prodIndex] = product;
        notifyListeners();
      } catch (e) {
        //todo: add error handling
      }
    }
  }

  Future<bool> deleteProduct(String id) async {
    final url = Uri.parse('https://myshop-f4884-default-rtdb.firebaseio.com/products/$id.json');
    final response = await http.delete(url);
    if (response.statusCode < 400) {
      _items.removeWhere((prod) => prod.id == id);
      notifyListeners();
      return true;
    }
    return false;
  }
}


//https://cdn.pixabay.com/photo/2017/02/16/13/42/box-2071537_960_720.png