import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class OrderItem {
  final String id;
  final double price;
  final List<CartItem> products;
  final DateTime orderTime;

  OrderItem({this.id, this.price, this.products, this.orderTime});
}

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  String _token;

  void setToken(String token) {
    if (_token != token) {
      _token = token;
      notifyListeners();
    }
  }

  Function deepEq = const DeepCollectionEquality().equals;
  void setOrderList(List<OrderItem> orders) {
    if (!deepEq(_orders, orders)) {
      _orders = orders;
      notifyListeners();
    }
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders(BuildContext context) async {
    final String url =
        'https://shop-app-3529f.firebaseio.com/orders.json?auth=$_token';

    try {
      final resp = await http.get(url);
      final List<OrderItem> loadedOrders = [];
      final data = json.decode(resp.body) as Map<String, dynamic>;
      if (data == null) {
        return;
      }
      data.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            price: orderData['amount'],
            orderTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    product:
                        Provider.of<ProductsProvider>(context, listen: false)
                            .getItemById(
                      item['id'],
                    ),
                  ),
                )
                .toList(),
          ),
        );
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final String url =
        'https://shop-app-3529f.firebaseio.com/orders.json?auth=$_token';
    final timeStamp = DateTime.now();
    final value = await http.post(
      url,
      body: json.encode(
        {
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'id': e.product.id,
                    'title': e.product.title,
                    'quantity': e.quantity,
                    'price': e.price
                  })
              .toList(),
        },
      ),
    );
    _orders.insert(
      0,
      OrderItem(
          id: json.decode(value.body)['name'],
          price: total,
          orderTime: timeStamp,
          products: cartProducts),
    );
    notifyListeners();
  }
}
