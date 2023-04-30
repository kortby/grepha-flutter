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
import 'package:shop/screens/splash.dart';
import 'package:shop/screens/user_products.dart';
import 'package:shop/screens/edit_product.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          create: (context) => ProductProvider(
            Provider.of<AuthProvider>(context, listen: false).token,
            Provider.of<AuthProvider>(context, listen: false).userId,
            [],
          ),
          update: (context, auth, prev) => ProductProvider(
            auth.token,
            auth.userId,
            prev == null ? [] : prev.items,
          ),
        ),
        ChangeNotifierProvider.value(
          value: CartProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          create: (_) => OrderProvider('', '', []),
          update: (context, auth, prev) => OrderProvider(
              auth.token!, auth.userId, prev == null ? [] : prev.orders),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'Shopping',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: Colors.deepOrange,
            ),
            fontFamily: 'Lato',
          ),
          home: authData.isAuth
              ? ProductOverview()
              : FutureBuilder(
                  future: authData.tryAutoLoing(),
                  builder: (context, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const Splash()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetail.routeName: (ctx) => const ProductDetail(),
            Cart.routeName: (ctx) => const Cart(),
            Orders.routeName: (ctx) => const Orders(),
            UserProducts.routeName: (ctx) => const UserProducts(),
            EditProduct.routeName: (ctx) => const EditProduct(),
          },
        ),
      ),
    );
  }
}
