import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import './product.dart';

class CartItem {
  final String id;
  final Product product;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.product,
    @required this.quantity,
    @required this.price,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addProduct(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            price: existingCartItem.price,
            quantity: (existingCartItem.quantity + 1),
            product: product),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
            id: DateTime.now().toString(),
            price: product.price,
            quantity: 1,
            product: product),
      );
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.removeWhere((key, value) => value.id == item.id);
    notifyListeners();
  }

  void removeSingleItem(Product item) {
    if (_items.containsKey(item.id)) {
      if (_items[item.id].quantity > 1) {
        _items.update(
            item.id,
            (oldValue) => CartItem(
                id: oldValue.id,
                price: oldValue.price,
                product: oldValue.product,
                quantity: oldValue.quantity - 1));
      } else {
        _items.remove(item.id);
      }
    }
    notifyListeners();
  }

  double get totalPrice {
    if (_items == null) {
      return 0.0;
    }
    double totalPrice = 0.0;
    _items.forEach((key, value) {
      totalPrice += value.price * value.quantity;
    });

    return totalPrice;
  }

  int get itemsInCart {
    if (_items == null) {
      return 0;
    }
    int quantity = 0;
    _items.forEach((key, value) {
      quantity += value.quantity;
    });

    return quantity;
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
