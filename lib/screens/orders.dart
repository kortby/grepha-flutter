import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/order_provider.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/single_order.dart';

class Orders extends StatelessWidget {
  static const routeName = '/orders';
  const Orders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your orders'),
        ),
        drawer: AppDrawer(),
        body: ListView.builder(
          itemBuilder: (ctx, idx) => SingleOrder(order: orderData.orders[idx]),
          itemCount: orderData.orders.length,
        ));
  }
}
