import 'package:bazar/models/book.dart';
import 'package:bazar/providers/books.dart';
import 'package:bazar/widgets/book_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookGrids extends StatelessWidget {
  final String value;
  const BookGrids({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final books = Provider.of<Books>(context, listen: false).searchBooks(value);

    return books.isEmpty
        ? const Center(
            child: Text(
              'Book dose not exists :(',
              style: TextStyle(color: Colors.grey, fontSize: 30),
            ),
          )
        : FutureBuilder(
            future:
                Provider.of<Books>(context, listen: false).fetchAndSetBooks(),
            builder: (ctx, snapshot) => GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: books.length,
              itemBuilder: (ctx, i) => ChangeNotifierProvider<Book>.value(
                value: books[i],
                child: BookItem(),
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
          );
  }
}
