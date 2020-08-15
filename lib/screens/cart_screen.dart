import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/widgets/cart_item.dart';

import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Cart'),
        ),
        body: Column(
          children: [
            Card(
              elevation: 6,
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Spacer(),
                    Chip(
                      label: Text('${cart.totalPrice.toStringAsFixed(2)}'),
                      backgroundColor: Theme.of(context).accentColor,
                    ),
                    FlatButton(
                      child: Text(
                        'Order now',
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Place your order"),
                                  content:
                                      Text('Do you want to place your order?'),
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
                            Provider.of<OrderProvider>(context, listen: false)
                                .addOrder(cart.items.values.toList(),
                                    cart.totalPrice);
                            cart.clearCart();
                          }
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: ListView.builder(
              itemBuilder: (ctx, index) => CartItemTile(
                  cartItem: cart.items.values.toList().elementAt(index)),
              itemCount: cart.items.length,
            )),
          ],
        ));
  }
}
