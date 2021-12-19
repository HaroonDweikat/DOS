// ignore_for_file: avoid_print

import 'package:bazar/models/order.dart';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:math';

class Orders extends ChangeNotifier {
  List<Order> _orders = [];
  get orders {
    return _orders;
  }

  final String apiUrl = 'http://localhost:5160/api/add';
  final String chaceUrl = 'http://localhost:5160/api/cache';

  Future<void> fetchAndSetOrders() async {
    try {
      var response = await http.get(
        Uri.parse('$chaceUrl/getAllOrders/orders'),
        headers: {
          'Access-Control-Allow-Origin': '*',
          // "Accept": "application/json",
          'Access-Control-Allow-Methods': 'GET, HEAD'
        },
      );
      // if (response.statusCode > 400) {
      //   //cache miss
      //   print('response code  => ${response.statusCode}');
      //   print('cache miss');
      //   response = await http.get(Uri.parse(
      //       '${ordersServer[orderServerIndex % ordersServer.length]}/getAllOrder'));
      //   print(
      //       'ordersServer send request to replica => ${ordersServer[orderServerIndex % ordersServer.length]}/getAllOrder');
      //   orderServerIndex++;
      // } else {
      //   print('cache hit');
      // }
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
    var url = '$apiUrl/order';
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
      // print(
      //     'ordersServer send request to replica => ${ordersServer[orderServerIndex % ordersServer.length]}/getAllOrder');
      // orderServerIndex++;
      print(response.body);

      notifyListeners();
    } catch (error) {
      print(error);
      // throw error;
    }
  }
}
