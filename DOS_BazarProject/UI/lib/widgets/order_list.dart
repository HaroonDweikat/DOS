import 'package:bazar/models/book.dart';
import 'package:bazar/models/order.dart';
import 'package:bazar/providers/books.dart';
import 'package:bazar/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderLest extends StatelessWidget {
  const OrderLest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _orders = Provider.of<Orders>(context).orders as List<Order>;
    final _books = Provider.of<Books>(context).items as List<Book>;
    return SizedBox(
      child: ListView.builder(
          itemCount: _orders.length,
          itemBuilder: (ctx, i) {
            var book = _books.firstWhere((book) => book.id == _orders[i].id);
            return Center(
              child: Text(book.name),
            );
          }),
    );
  }
}
