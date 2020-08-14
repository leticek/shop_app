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
            quantity: existingCartItem.quantity + 1,
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
  }

  int get itemsInCart {
    int quantity;
    _items.forEach((key, value) {
      quantity += _items[key].quantity;
    });

    return quantity;
  }
}
