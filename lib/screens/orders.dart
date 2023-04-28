import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/order_provider.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/single_order.dart';

class Orders extends StatefulWidget {
  static const routeName = '/orders';
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future:
            Provider.of<OrderProvider>(context, listen: false).fetchOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState != ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error == null) {
              // handle error
              return Consumer<OrderProvider>(
                  builder: (ctx, orderData, child) => ListView.builder(
                        itemBuilder: (ctx, idx) =>
                            SingleOrder(order: orderData.orders[idx]),
                        itemCount: orderData.orders.length,
                      ));
            }
          }
          return const Text('Error Occurred!!');
        },
      ),
    );
  }
}
