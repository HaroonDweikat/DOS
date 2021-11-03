import 'package:bazar/models/order.dart';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Orders extends ChangeNotifier {
  List<Order> _orders = [];

  Future<void> fetchAndSetOrders() async {
    String getAllBooks = 'http://localhost:5025/api/books/getAllBooks/';
    try {
      final response = await http.get(Uri.parse(getAllBooks));
      final List<Order> loadedOrders = [];
      // print(response.body);
      final extractedDate = json.decode(response.body) as List<dynamic>;
      if (extractedDate == null) return;

      extractedDate.forEach((bookData) {
        loadedOrders.add(
          Order(
              id: bookData['id'],
              name: bookData['bookName'],
              topic: bookData['bookTopic'],
              price: bookData['bookCost'],
              countInStock: bookData['countInStock']),
        );
      });
      _orders = loadedOrders;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
