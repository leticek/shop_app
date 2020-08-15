import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';

class CartItemTile extends StatelessWidget {
  final CartItem cartItem;

  CartItemTile({this.cartItem});

  @override
  Widget build(BuildContext context) {
    CartProvider tmp = Provider.of<CartProvider>(context, listen: false);
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(cartItem.id),
      background: Container(
        color: Theme.of(context).accentColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 25,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.all(10),
      ),
      onDismissed: (direction) => tmp.removeItem(cartItem),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Text(
                    '${cartItem.price.toStringAsFixed(2)}',
                  ),
                ),
              ),
            ),
            title: Text('${cartItem.product.title}'),
            subtitle: Text(
                'Total: ${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}'),
            trailing: Text('${cartItem.quantity}'),
          ),
        ),
      ),
    );
  }
}
