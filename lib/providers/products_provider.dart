import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _productList = [];
  String _token;

  ProductsProvider();

  void setToken(String token) {
    if (_token != token) {
      _token = token;
      notifyListeners();
    }
  }

  void setProductList(List products) {
    if (!listEquals(products, _productList)) {
      _productList = products;
      notifyListeners();
    }
  }

  List<Product> get products {
    return [..._productList];
  }

  List<Product> get favoriteProducts {
    return _productList.where((element) => element.isFavorite).toList();
  }

  Product getItemById(String productId) {
    return _productList.firstWhere((element) => element.id == productId);
  }

  Future<void> fetchProducts() async {
    final String url =
        'https://shop-app-3529f.firebaseio.com/products.json?auth=$_token';
    try {
      final response = await http.get(url);
      if (response.body != null) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        List<Product> tmp = [];
        data.forEach((key, value) {
          tmp.add(
            Product(
              id: key,
              description: value['description'],
              imageUrl: value['imageUrl'],
              price: value['price'],
              title: value['title'],
              isFavorite: value['isFavorite'],
            ),
          );
          _productList = tmp;
        });
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product prod) async {
    final String url =
        'https://shop-app-3529f.firebaseio.com/products.json?auth=$_token';
    try {
      final value = await http.post(
        url,
        body: json.encode(
          {
            'title': prod.title,
            'description': prod.description,
            'price': prod.price,
            'imageUrl': prod.imageUrl,
            'isFavorite': prod.isFavorite,
          },
        ),
      );
      final newProduct = Product(
        description: prod.description,
        id: json.decode(value.body)['name'],
        imageUrl: prod.imageUrl,
        price: prod.price,
        title: prod.title,
      );
      _productList.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> editProduct(Product prod) async {
    final prodIndex =
        _productList.indexWhere((element) => element.id == prod.id);
    if (prodIndex >= 0) {
      try {
        final url =
            'https://shop-app-3529f.firebaseio.com/products/${prod.id}.json?auth=$_token';
        await http.patch(
          url,
          body: json.encode(
            {
              'title': prod.title,
              'description': prod.description,
              'price': prod.price,
              'imageUrl': prod.imageUrl,
            },
          ),
        );
      } catch (error) {
        throw error;
      }
      _productList[prodIndex] = prod;
      notifyListeners();
    }
  }

  void removeProduct(Product prod) {
    final url =
        'https://shop-app-3529f.firebaseio.com/products/${prod.id}.json?auth=$_token';
    http.delete(url);
    _productList.removeWhere((element) => element.id == prod.id);
    notifyListeners();
  }
}
