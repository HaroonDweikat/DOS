import 'package:bazar/models/order.dart';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Orders extends ChangeNotifier {
  List<Order> _orders = [];
  get orders {
    return _orders;
  }

  Future<void> fetchAndSetOrders() async {
    String getAllBooks = 'http://localhost:5020/api/order/getAllOrder/';
    try {
      final response = await http.get(Uri.parse(getAllBooks));
      final List<Order> loadedOrders = [];
      final extractedDate = json.decode(response.body) as List<dynamic>;
      if (extractedDate == null) return;

      extractedDate.forEach((orderData) {
        loadedOrders.add(Order(
          id: orderData['id'],
          itemId: orderData['itemId'],
          date: orderData['date'],
        ));
      });
      _orders = loadedOrders;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addOrder(String bid) async {
    const url = 'http://localhost:5020/api/order/addOrder';
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    try {
      var toJson = {
        "itemId": bid,
        "date": formattedDate,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(toJson),
      );
      print(response.body);

      notifyListeners();
    } catch (error) {
      print(error);
      // throw error;
    }
  }
}
