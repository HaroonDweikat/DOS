import 'package:flutter/foundation.dart';

class Book extends ChangeNotifier {
  final String id;
  final String name;
  final String topic;
  final double price;
  int countInStock;

  Book(
      {required this.id,
      required this.name,
      required this.topic,
      required this.price,
      required this.countInStock});
}
