// import 'package:bazar/widgets/navigation_bar.dart';
import 'package:bazar/providers/books.dart';
import 'package:bazar/providers/orders.dart';
import 'package:bazar/views/add_book.dart';
import 'package:bazar/views/order_views.dart';
import 'package:bazar/widgets/book_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/Home';
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<bool> hover = [false, false, false, false];
  bool hover2 = false;
  bool hover3 = false;
  String searchString = '';

  Future<void> _refreshBooks(BuildContext context) async {
    await Provider.of<Books>(context, listen: false).fetchAndSetBooks();
  }

  Widget link(String title, IconData icon, Function() onClick, int index) {
    return InkWell(
      onTap: onClick,
      hoverColor: Colors.transparent,
      child: Row(
        children: [
          Icon(
            icon,
            color: !hover[index] ? Colors.white : Colors.limeAccent,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 18,
                color: !hover[index] ? Colors.white : Colors.limeAccent),
          ),
        ],
      ),
      onHover: (x) {
        setState(() {
          hover[index] = x;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var books = Provider.of<Books>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          width: double.infinity,
          child: Row(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    child: ClipRRect(
                      child: Image.asset(
                        'logo.png',
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  const Text('Bazar '),
                ],
              ),
              const SizedBox(width: 50),
              //refresh Books
              link('Refresh Books', Icons.refresh_sharp,
                  () => _refreshBooks(context), 0),

              const SizedBox(width: 16),
              //add Book Link
              link('Add Book', Icons.add, () {
                Navigator.of(context).pushNamed(AddBookView.routeName);
              }, 1),
              const SizedBox(width: 16),
              //Orders
              link('Orders', Icons.shopping_cart_outlined, () {
                Navigator.of(context).pushNamed(OrdersViews.routeName);
              }, 2),
              const SizedBox(width: 16),
              //Search box
              Row(children: [
                const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 28,
                ),
                Container(
                  width: 300,
                  height: 30,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.black, width: 2.0))),
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Search...'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Invalid !';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        searchString = value;
                      });
                      // print(value);
                    },
                  ),
                ),
              ]),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: BookGrids(searchValue: searchString),
    );
  }
}
