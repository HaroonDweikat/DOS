import 'package:bazar/models/book.dart';
import 'package:bazar/providers/books.dart';
import 'package:bazar/widgets/book_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookGrids extends StatefulWidget {
  final String searchValue;
  const BookGrids({Key? key, required this.searchValue}) : super(key: key);

  @override
  State<BookGrids> createState() => _BookGridsState();
}

class _BookGridsState extends State<BookGrids> {
  var _isLoading = false;
  var _isInit = false;
  String _oldSearch = '#';
  var _books;
  // @override
  // void initState() {
  //   Provider.of<Books>(
  //     context,
  //     listen: false,
  //   ).searchBooks(widget.searchValue).then((value) {
  //     setState(() {
  //       _books = value;
  //       _isLoading = false;
  //     });
  //     super.initState();
  //   });
  // }

  @override
  void didChangeDependencies() {
    _isLoading = true;
    if (!_isInit) {
      Provider.of<Books>(
        context,
        listen: false,
      ).searchBooks(widget.searchValue).then((value) {
        setState(() {
          _books = value;
          _isLoading = false;
          _isInit = true;
          _oldSearch = widget.searchValue;
        });
      });
    }

    super.didChangeDependencies();
  }

  void getValue() async {
    var value = await Provider.of<Books>(
      context,
      listen: false,
    ).searchBooks(widget.searchValue).then((value) {
      setState(() {
        _books = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('old =' + _oldSearch);
    // print('new =' + widget.searchValue);
    if (_oldSearch != widget.searchValue) {
      getValue();
      setState(() {
        _oldSearch = widget.searchValue;
      });
    }
    // return const Center(child: CircularProgressIndicator());
    // return FutureBuilder(
    //   future: getValue(),
    //   builder: (ctx, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(child: CircularProgressIndicator());
    //     } else if (snapshot.connectionState == ConnectionState.done) {
    //       if (snapshot.hasError) {
    //         return const Text('Error');
    //       } else if (snapshot.hasData) {
    //         return books.isEmpty
    //             ? const Center(
    //                 child: Text(
    //                   'Book dose not exists :(',
    //                   style: TextStyle(color: Colors.grey, fontSize: 30),
    //                 ),
    //               )
    //             : GridView.builder(
    //                 padding: const EdgeInsets.all(10.0),
    //                 itemCount: books.length,
    //                 itemBuilder: (ctx, i) => ChangeNotifierProvider<Book>.value(
    //                   value: books[i],
    //                   child: BookItem(),
    //                 ),
    //                 gridDelegate:
    //                     const SliverGridDelegateWithFixedCrossAxisCount(
    //                   crossAxisCount: 4,
    //                   childAspectRatio: 3 / 2,
    //                   crossAxisSpacing: 10,
    //                   mainAxisSpacing: 10,
    //                 ),
    //               );
    //       } else {
    //         return const Text('Empty data');
    //       }
    //     } else {
    //       return Text('State: ${snapshot.connectionState}');
    //     }
    //   },
    // );
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : _books.isEmpty
            ? const Center(
                child: Text(
                  'Book dose not exists :(',
                  style: TextStyle(color: Colors.grey, fontSize: 30),
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: _books.length,
                itemBuilder: (ctx, i) => ChangeNotifierProvider<Book>.value(
                  value: _books[i],
                  child: BookItem(),
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              );
  }
}
