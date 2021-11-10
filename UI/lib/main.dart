import 'package:bazar/providers/books.dart';
import 'package:bazar/providers/orders.dart';
import 'package:bazar/views/add_book.dart';
import 'package:bazar/views/book_detail_view.dart';
import 'package:bazar/views/home_view.dart';
import 'package:bazar/views/order_views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Books(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: Consumer<Books>(builder: (ctx, books, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bazar',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: HomeView(),
          routes: {
            HomeView.routeName: (ctx) => HomeView(),
            BookDetailView.routeName: (ctx) => const BookDetailView(),
            AddBookView.routeName: (ctx) => AddBookView(),
            OrdersViews.routeName: (ctx) => OrdersViews(),
          },
        );
      }),
    );
  }
}
