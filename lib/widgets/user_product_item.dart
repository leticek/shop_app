import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  const UserProductItem({this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${product.title}'),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: product);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text("Are you sure?"),
                          content: Text(
                              'Do you want to permamently delete this product?'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Yes'),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                            FlatButton(
                              child: Text('No'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            )
                          ],
                        )).then((value) {
                  if (value as bool) {
                    Provider.of<ProductsProvider>(
                      context,
                      listen: false,
                    ).removeProduct(product);
                  }
                });
              },
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
