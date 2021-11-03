import 'package:bazar/widgets/order_list.dart';
import 'package:flutter/material.dart';

class OrdersViews extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersViews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            OrderLest(),
          ],
        ),
      ),
    );
  }
}
