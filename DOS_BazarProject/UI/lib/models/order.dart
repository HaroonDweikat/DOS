import 'package:flutter/foundation.dart';

class Order extends ChangeNotifier {
  final String id;
  final String ItemId;
  final String Date;

  Order({
    required this.id,
    required this.ItemId,
    required this.Date,
  });
}
