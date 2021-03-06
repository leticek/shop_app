import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/custom_route.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_management_screen.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: 105,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            alignment: Alignment.bottomLeft,
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FlatButton(
            child: ListTile(
              leading: Icon(Icons.shopping_basket),
              title: Text('Shop'),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          SizedBox(
            height: 10,
          ),
          FlatButton(
            child: ListTile(
              leading: Icon(Icons.menu),
              title: Text('Payment'),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                CustomRoute(
                  builder: (ctx) => OrdersScreen(),
                ),
              );
            },
          ),
          FlatButton(
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text('Product Management'),
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(UserProductsManagementScreen.routeName);
            },
          ),
          FlatButton(
            child: ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Log out'),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logOut();
            },
          )
        ],
      ),
    );
  }
}
