import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/providers/auth_provider.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/screens/product_detail.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final authData = Provider.of<AuthProvider>(context, listen: false);
    return Consumer<Product>(
      builder: (ctx, product, child) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: IconButton(
              onPressed: () {
                product.toggleFavoriteStatus(
                    product.id!, authData.token!, authData.userId);
              },
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_outline),
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product.id!, product.price, product.title);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Item added to the cart!'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        cart.removeSingleItem(product.id!);
                      },
                    ),
                  ),
                );
              },
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetail.routeName,
                arguments: product.id,
              );
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
