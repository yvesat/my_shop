import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String imageUrl;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, String imageUrl, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existstingCartItem) => CartItem(
          id: existstingCartItem.id,
          imageUrl: existstingCartItem.imageUrl,
          title: existstingCartItem.title,
          quantity: existstingCartItem.quantity + 1,
          price: existstingCartItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          imageUrl: imageUrl,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void addQuantity(String productId) {
    _items.update(
      productId,
      (existstingCartItem) => CartItem(
        id: existstingCartItem.id,
        imageUrl: existstingCartItem.imageUrl,
        title: existstingCartItem.title,
        quantity: existstingCartItem.quantity + 1,
        price: existstingCartItem.price,
      ),
    );
    notifyListeners();
  }

  void subtractQuantity(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    _items.update(
      productId,
      (existstingCartItem) => CartItem(
        id: existstingCartItem.id,
        imageUrl: existstingCartItem.imageUrl,
        title: existstingCartItem.title,
        quantity: existstingCartItem.quantity - 1,
        price: existstingCartItem.price,
      ),
    );
    if (_items[productId]!.quantity <= 0) {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
