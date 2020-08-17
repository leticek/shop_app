import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/widgets/drawer.dart';

import '../widgets/order_item.dart' as ord;

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders-screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  initState() {
    Future.delayed(Duration.zero).then((value) =>
        Provider.of<OrderProvider>(context, listen: false)
            .fetchAndSetOrders(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderProvider>(context);
    return Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          title: Text(
            'Orders',
          ),
        ),
        body: ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder: (context, index) => ord.OrderItem(
            item: orderData.orders.elementAt(index),
          ),
        ));
  }
}
