import 'package:bazar/models/order.dart';
import 'package:bazar/providers/orders.dart';
import 'package:bazar/widgets/order_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersViews extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersViews({Key? key}) : super(key: key);

  @override
  State<OrdersViews> createState() => _OrdersViewsState();
}

class _OrdersViewsState extends State<OrdersViews> {
  var loadedOrders;
  var _isInit = true;
  var _isLoading = false;
  String searchString = '';

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;
      Provider.of<Orders>(
        context,
        listen: false,
      ).fetchAndSetOrders().then((_) {
        setState(() {
          loadedOrders = Provider.of<Orders>(context, listen: false).orders;
          // print(loadedOrders.length);
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      // title:
      //Search box
      //     Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     const Icon(
      //       Icons.search,
      //       color: Colors.white,
      //       size: 28,
      //     ),
      //     Container(
      //       width: 300,
      //       height: 30,
      //       decoration: const BoxDecoration(
      //           border: Border(
      //               bottom: BorderSide(color: Colors.black, width: 2.0))),
      //       child: TextFormField(
      //         decoration: const InputDecoration(labelText: 'Search...'),
      //         validator: (value) {
      //           if (value!.isEmpty) {
      //             return 'Invalid !';
      //           }
      //           return null;
      //         },
      //         onChanged: (value) {
      //           setState(() {
      //             searchString = value;
      //           });
      //           // print(value);
      //         },
      //       ),
      //     ),
      //   ],
      // ),
      // ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    loadedOrders.isEmpty
                        ? const Center(
                            child: Text(
                              'There is no orders :(',
                              style:
                                  TextStyle(fontSize: 30, color: Colors.grey),
                            ),
                          )
                        : OrderList(loadedOrders),
                  ],
                ),
              ),
            ),
    );
  }
}
