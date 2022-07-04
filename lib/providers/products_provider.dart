import 'package:flutter/material.dart';
import 'dart:convert';
import 'product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: "1",
      title: "Mouse",
      description: "Mouse for computers",
      price: 99.99,
      imageUrl: "https://cdn.pixabay.com/photo/2017/05/24/21/33/workplace-2341642__340.jpg",
    ),
    Product(
      id: "2",
      title: "Keyboard",
      description: "Keyboard for computers",
      price: 199.99,
      imageUrl: "https://cdn.pixabay.com/photo/2015/12/15/19/35/keyboard-1094833__340.jpg",
    ),
    Product(
      id: "3",
      title: "iPad",
      description: "Last generation iPad",
      price: 499.99,
      imageUrl: "https://cdn.pixabay.com/photo/2019/10/07/10/40/ipad-4532326_960_720.jpg",
    ),
    Product(
      id: "4",
      title: "MacBook",
      description: "Last generation MacBook",
      price: 1999.99,
      imageUrl: "https://cdn.pixabay.com/photo/2016/10/11/09/26/office-1730940__340.jpg",
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse('https://myshop-f4884-default-rtdb.firebaseio.com/products.json');
    final response = await http.post(url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imagerUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          },
        ));
    final newProduct = Product(
      id: json.decode(response.body)['name'],
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    );
    _items.add(newProduct);
    notifyListeners();
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
