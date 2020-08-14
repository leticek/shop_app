import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/widgets/badge.dart';

import '../widgets/products_grid.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavorites = false;
  @override
  Widget build(BuildContext context) {
    CartProvider cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          Badge(
            child:
                IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
            value: cart.itemsInCart.toString(),
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
      body: ProductsGrid(
        showFavorite: _showFavorites,
      ),
    );
  }
}
