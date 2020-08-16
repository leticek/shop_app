import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/drawer.dart';

import '../widgets/products_grid.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) =>
        Provider.of<ProductsProvider>(context, listen: false).fetchProducts());
    super.initState();
  }

  bool _showFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          Consumer<CartProvider>(
            builder: (_, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemsInCart.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) => setState(() {
              if (selectedValue == FilterOptions.Favorites)
                _showFavorites = true;
              else
                _showFavorites = false;
            }),
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(
                  'All',
                ),
                value: FilterOptions.All,
              ),
              PopupMenuItem(
                child: Text(
                  'Favorites',
                ),
                value: FilterOptions.Favorites,
              ),
            ],
          ),
        ],
      ),
      body: GestureDetector(
        onVerticalDragDown: (details) =>
            Provider.of<ProductsProvider>(context, listen: false)
                .fetchProducts(),
        child: ProductsGrid(
          showFavorite: _showFavorites,
        ),
      ),
    );
  }
}
