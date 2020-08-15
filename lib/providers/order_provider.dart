import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart_provider.dart';

class OrderItem {
  final String id;
  final double price;
  final List<CartItem> products;
  final DateTime orderTime;

  OrderItem({this.id, this.price, this.products, this.orderTime});
}

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
          id: DateTime.now().toString(),
          price: total,
          orderTime: DateTime.now(),
          products: cartProducts),
    );
    notifyListeners();
  }
}
