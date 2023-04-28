import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth_provider.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/providers/order_provider.dart';
import 'package:shop/providers/product_provider.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/cart.dart';
import 'package:shop/screens/orders.dart';
import 'package:shop/screens/product_detail.dart';
import 'package:shop/screens/product_overview.dart';
import 'package:shop/screens/user_products.dart';
import 'package:shop/screens/edit_product.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ProductProvider(),
        ),
        ChangeNotifierProvider.value(
          value: CartProvider(),
        ),
        ChangeNotifierProvider.value(
          value: OrderProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Shopping',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.deepOrange,
          ),
          fontFamily: 'Lato',
        ),
        home: AuthScreen(),
        routes: {
          ProductDetail.routeName: (ctx) => const ProductDetail(),
          Cart.routeName: (ctx) => const Cart(),
          Orders.routeName: (ctx) => const Orders(),
          UserProducts.routeName: (ctx) => const UserProducts(),
          EditProduct.routeName: (ctx) => const EditProduct(),
        },
      ),
    );
  }
}
