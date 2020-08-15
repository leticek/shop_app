import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail-screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final product =
        Provider.of<ProductsProvider>(context).getItemById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: 300,
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            '${product.price}',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
            softWrap: true,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            '${product.description}',
            style: TextStyle(
              fontSize: 18,
            ),
            softWrap: true,
          ),
        ]),
      ),
    );
  }
}
