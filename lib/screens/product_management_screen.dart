import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/user_product_item.dart';

import './edit_product.dart';

class UserProductsManagementScreen extends StatelessWidget {
  static const routeName = '/product-management';

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.add,
              ),
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (_, index) => UserProductItem(
            product: products.products.elementAt(index),
          ),
          itemCount: products.products.length,
        ),
      ),
    );
  }
}
