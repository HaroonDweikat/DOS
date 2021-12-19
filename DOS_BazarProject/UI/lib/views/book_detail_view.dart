import 'package:bazar/models/book.dart';
import 'package:bazar/providers/books.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetailView extends StatefulWidget {
  static const routeName = '/book-detail';
  const BookDetailView({Key? key}) : super(key: key);

  @override
  State<BookDetailView> createState() => _BookDetailViewState();
}

class _BookDetailViewState extends State<BookDetailView> {
  var loadedBook;
  var _isInit = true;
  var _isLoading = false;
  bool edit = false;
  bool update = false;

  Map<String, dynamic> _bookData = {};
  TextEditingController _controller = TextEditingController();
  Future<void> loadBook(String id) async {
    try {
      await Provider.of<Books>(
        context,
        listen: false,
      ).findById(id).then((value) {
        setState(() {
          loadedBook = value;
          _bookData = {
            // 'name': loadedBook.name,
            // 'topic': loadedBook.topic,
            // 'price': loadedBook.price,
            // 'countInStock': loadedBook.countInStock,
          };
          _isLoading = false;
          _isInit = false;
        });
      });
    } on Exception catch (e) {}
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final bookId = ModalRoute.of(context)!.settings.arguments as String;

      _isLoading = true;
      Provider.of<Books>(
        context,
        listen: false,
      ).findById(bookId).then((value) {
        setState(() {
          loadedBook = value;
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final bookId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     loadedProduct.title,
      //   ),
      // ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: loadedBook.id,
                      child: Image.network(
                        'assets/book-cover.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      height: 80,
                      child: TextFormField(
                        controller: _controller..text = loadedBook.name,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            overflow: TextOverflow.visible),
                        decoration: InputDecoration(
                          border: edit
                              ? const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red))
                              : InputBorder.none,
                          hintText: 'Book name',
                        ),
                        enabled: edit,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Invalid!';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _bookData['bookName'] = value;
                          // print(value);
                        },
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(
                      height: 6,
                    ),
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: 300,
                        height: 80,
                        child: TextFormField(
                          controller: TextEditingController()
                            ..text = loadedBook.topic,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              overflow: TextOverflow.visible),
                          decoration: InputDecoration(
                            border: edit
                                ? const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red))
                                : InputBorder.none,
                            hintText: 'Book Topic',
                          ),
                          enabled: edit,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Invalid!';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _bookData['bookTopic'] = value;
                            // print(value);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Price : \$',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                overflow: TextOverflow.visible),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: 150,
                            height: 80,
                            child: TextFormField(
                              controller: TextEditingController()
                                ..text = loadedBook.price.toString(),
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  overflow: TextOverflow.visible),
                              decoration: InputDecoration(
                                border: edit
                                    ? const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red))
                                    : InputBorder.none,
                                hintText: 'Book Price',
                              ),
                              enabled: edit,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Invalid!';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _bookData['bookCost'] = double.parse(value);
                                // print(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Count in Stock : ',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                overflow: TextOverflow.visible),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: 100,
                            height: 80,
                            child: TextFormField(
                              controller: TextEditingController()
                                ..text = loadedBook.countInStock.toString(),
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  overflow: TextOverflow.visible),
                              decoration: InputDecoration(
                                border: edit
                                    ? const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red))
                                    : InputBorder.none,
                                hintText: 'Book Count In Stock',
                              ),
                              enabled: edit,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Invalid!';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _bookData['countInStock'] = int.parse(value);
                                // print(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                        child: ElevatedButton.icon(
                            onPressed: edit
                                ? null
                                : () {
                                    setState(() {
                                      edit = true;
                                      update = true;
                                    });
                                  },
                            icon: const Icon(
                              Icons.edit,
                              size: 24,
                            ),
                            label: const Text('Edit Book'))),
                    const SizedBox(height: 16),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton.icon(
                              onPressed: !update
                                  ? null
                                  : () {
                                      setState(() {
                                        edit = false;
                                        update = false;
                                        _bookData = {};
                                      });
                                    },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                              ),
                              icon: const Icon(
                                Icons.cancel_presentation_rounded,
                                size: 24,
                              ),
                              label: const Text('Cancel')),
                          const SizedBox(
                            width: 5,
                          ),
                          ElevatedButton.icon(
                              onPressed: !update
                                  ? null
                                  : () {
                                      setState(() {
                                        edit = false;
                                        update = false;

                                        Provider.of<Books>(context,
                                                listen: false)
                                            .updateBook(
                                                loadedBook.id, _bookData)
                                            .then((value) async {
                                          await Provider.of<Books>(
                                            context,
                                            listen: false,
                                          )
                                              .findById(loadedBook.id)
                                              .then((value) {
                                            setState(() {
                                              loadedBook = value;
                                              _bookData = {};
                                              _isLoading = false;
                                              _isInit = false;
                                            });
                                          });
                                        });
                                      });
                                    },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                              ),
                              icon: const Icon(
                                Icons.upload,
                                size: 24,
                              ),
                              label: const Text('Update')),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
    );
  }
}
