import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

import './providers/auth.dart';
import './screens/auth_screen.dart';
import './screens/edit_product.dart';
import './screens/orders_screen.dart';
import './screens/product_management_screen.dart';
import './providers/order_provider.dart';
import './providers/cart_provider.dart';
import './screens/product_detail_screen.dart';
import './providers/products_provider.dart';
import './screens/cart_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (_) => ProductsProvider(),
          update: (context, auth, previousProducts) => previousProducts
            ..setProductList(
                previousProducts == null ? [] : previousProducts.products)
            ..setToken(auth.token)
            ..setUserId(auth.userId),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<Auth, OrderProvider>(
          create: (_) => OrderProvider(),
          update: (context, auth, previousOrders) => previousOrders
            ..setOrderList(previousOrders == null ? [] : previousOrders.orders)
            ..setToken(auth.token),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            accentColor: Colors.deepOrangeAccent,
            fontFamily: 'Lato',
          ),
          home: authData.isAuthorized ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsManagementScreen.routeName: (context) =>
                UserProductsManagementScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
            AuthScreen.routeName: (context) => AuthScreen()
          },
        ),
      ),
    );
  }
}
