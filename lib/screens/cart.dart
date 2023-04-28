import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart_provider.dart' show CartProvider;
import 'package:shop/providers/order_provider.dart';
import 'package:shop/widgets/cart_item.dart';

class Cart extends StatelessWidget {
  static const routeName = '/cart';
  const Cart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isLoading = false;
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: (cart.totalAmount <= 0 || _isLoading)
                        ? null
                        : () async {
                            _isLoading = true;
                            await Provider.of<OrderProvider>(context,
                                    listen: false)
                                .addOrder(
                              cart.items.values.toList(),
                              cart.totalAmount,
                            );
                            _isLoading = false;
                            cart.clearCart();
                          },
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'ORDER NOW',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, idx) => CartItem(
              id: cart.items.values.toList()[idx].id,
              productId: cart.items.keys.toList()[idx],
              title: cart.items.values.toList()[idx].title,
              quantity: cart.items.values.toList()[idx].quantity,
              price: cart.items.values.toList()[idx].price,
            ),
            itemCount: cart.items.length,
          ))
        ],
      ),
    );
  }
}
