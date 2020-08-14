import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool _showFavorite;
  ProductsGrid({@required showFavorite}) : _showFavorite = showFavorite;

  @override
  Widget build(BuildContext context) {
    final productListProvider = Provider.of<ProductsProvider>(context);
    final _products = this._showFavorite
        ? productListProvider.favoriteProducts
        : productListProvider.products;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: _products.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: _products.elementAt(index),
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
