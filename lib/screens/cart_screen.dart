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
                    OrderButton(cart: cart)
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    @required this.cart,
  });

  final CartProvider cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'Order now',
            ),
      onPressed: (widget.cart.totalPrice <= 0 || _isLoading)
          ? null
          : () {
              setState(() {
                _isLoading = true;
              });
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text("Place your order"),
                        content: Text('Do you want to place your order?'),
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
                  Provider.of<OrderProvider>(context, listen: false).addOrder(
                      widget.cart.items.values.toList(),
                      widget.cart.totalPrice);
                }
              }).then((value) {
                setState(() {
                  _isLoading = false;
                });
                widget.cart.clearCart();
              });
            },
    );
  }
}
