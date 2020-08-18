import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/order_provider.dart' as order;

class OrderItem extends StatefulWidget {
  final order.OrderItem item;

  const OrderItem({this.item});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:
          showMore ? min(widget.item.products.length * 20.0 + 110, 200) : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('${widget.item.price.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat('dd.MM.yyy hh:mm').format(widget.item.orderTime),
              ),
              trailing: IconButton(
                  icon: Icon(showMore ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      showMore = !showMore;
                    });
                  }),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(10),
              height: showMore
                  ? min(widget.item.products.length * 20.0 + 15, 180)
                  : 0,
              child: ListView(
                children: widget.item.products
                    .map(
                      (e) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${e.product.title}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${e.quantity}x ${e.price} Kc',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
