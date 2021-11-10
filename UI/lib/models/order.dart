import 'package:flutter/foundation.dart';

class Order extends ChangeNotifier {
  final String id;
  final String itemId;
  final String date;

  Order({
    required this.id,
    required this.itemId,
    required this.date,
  });
}
