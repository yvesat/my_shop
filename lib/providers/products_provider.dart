import 'package:flutter/material.dart';
import 'dart:convert';
import 'product.dart';
import 'package:http/http.dart' as http;

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
      rethrow;
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
    } catch (e) {
      rethrow;
    }
  }

  void updateProduct(String id, Product product) {
    final prodIndex = _items.lastIndexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
