import 'package:bazar/models/book.dart';
import 'package:bazar/models/order.dart';
import 'package:bazar/providers/books.dart';
import 'package:bazar/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderList extends StatelessWidget {
  List<Order> orders;
  OrderList(
    this.orders, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _books = Provider.of<Books>(context, listen: false).items as List<Book>;
    return Center(
      child: SizedBox(
        width: 800,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: orders.length,
            itemBuilder: (ctx, i) {
              var book =
                  _books.firstWhere((book) => book.id == orders[i].itemId);
              return Center(
                child: BookOrder(book, orders[i]),
              );
            }),
      ),
    );
  }
}

Widget BookOrder(Book book, Order order) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ListTile(
        leading: const Icon(Icons.book),
        title: Row(
          children: [
            const Text('Book Name: ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blueAccent)),
            Text(
              book.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )
          ],
        ),
        subtitle: Column(
          children: [
            Row(
              children: [
                const Text('Purches Date: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blueAccent)),
                Text(
                  order.date,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green),
                )
              ],
            ),
            Row(
              children: [
                const Text('Order Id: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blueAccent)),
                Text(
                  order.id,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green),
                )
              ],
            ),
          ],
        ),
        trailing: Text(1.toString() + 'x'),
        dense: true,
        isThreeLine: true,
      ),
      const SizedBox(
        height: 20,
      )
    ],
  );
}
