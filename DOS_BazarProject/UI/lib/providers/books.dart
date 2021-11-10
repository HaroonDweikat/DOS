import 'dart:convert';

import 'package:bazar/models/book.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Books extends ChangeNotifier {
  List<Book> _items = [];
  Book _bookItem =
      Book(id: "", name: "", topic: "", price: 0.0, countInStock: 0);

  get items {
    return _items;
  }

  get bookItem {
    return _bookItem;
  }

  Future<void> fetchAndSetBooks() async {
    String getAllBooks = 'http://localhost:5025/api/books/getAllBooks/';
    try {
      final response = await http.get(Uri.parse(getAllBooks));
      final List<Book> loadedBooks = [];
      // print(response.body);
      final extractedDate = json.decode(response.body) as List<dynamic>;
      if (extractedDate == null) return;
      _items = [];
      extractedDate.forEach((bookData) {
        loadedBooks.add(
          Book(
              id: bookData['id'],
              name: bookData['bookName'],
              topic: bookData['bookTopic'],
              price: bookData['bookCost'],
              countInStock: bookData['countInStock']),
        );
      });

      await Future.delayed(Duration(seconds: 2)).then((value) {
        _items = loadedBooks;
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<List<Book>> searchBooks(String value) async {
    String getBookByTopic =
        'http://localhost:5025/api/books/searchByTopic/' + value;
    if (value == '') {
      if (_items.isEmpty) {
        await fetchAndSetBooks();
      }
      return _items.toList();
    }
    final List<Book> loadedBooks = [];
    try {
      final response = await http.get(Uri.parse(getBookByTopic));

      final extractedDate = json.decode(response.body) as List<dynamic>;
      if (extractedDate == null) return loadedBooks;
      extractedDate.forEach((bookData) {
        loadedBooks.add(
          Book(
              id: bookData['id'],
              name: bookData['bookName'],
              topic: bookData['bookTopic'],
              price: bookData['bookCost'],
              countInStock: bookData['countInStock']),
        );
      });
      notifyListeners();
    } catch (e) {}

    return loadedBooks.toList();
  }

  Future<Book> findById(String bookId) async {
    String getBookById =
        'http://localhost:5025/api/books/getInfoById/' + bookId;
    var findedBook;
    try {
      final response = await http.get(Uri.parse(getBookById));
      final extractedDate = json.decode(response.body) as Map<String, dynamic>;

      findedBook = Book(
        id: extractedDate['id'],
        name: extractedDate['bookName'],
        topic: extractedDate['bookTopic'],
        price: extractedDate['bookCost'],
        countInStock: extractedDate['countInStock'],
      );
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
      return findedBook;
    }
  }

  Future<String> addBook(
      String name, String topic, double price, int countInStock) async {
    const url = 'http://localhost:5025/api/books/addBook/';
    try {
      var toJson = {
        "bookName": name,
        "bookTopic": topic,
        "bookCost": price,
        "countInStock": countInStock,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(toJson),
      );
      // print("response =>" + response.body);
      notifyListeners();
      if (jsonDecode(response.body)['detail'] != null) {
        return jsonDecode(response.body)['detail'];
      }
    } catch (error) {
      print(error);
    }
    return 'done';
  }

  Future<void> updateBook(String id, Map<String, dynamic> newBook) async {
    final prodIndex = _items.indexWhere((book) => book.id == id);
    if (prodIndex >= 0) {
      try {
        final url = 'http://localhost:5025/api/books/update/$id';

        final jsonObj = [];
        print(newBook);
        newBook.forEach((key, value) {
          if (_items[prodIndex].name == value ||
              _items[prodIndex].topic == value ||
              _items[prodIndex].price == value ||
              _items[prodIndex].countInStock == value) {
          } else {
            var newValue = {"op": "replace", "path": "/$key", "value": value};
            jsonObj.add(newValue);
          }
        });
        await http.patch(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json-patch+json'},
          body: json.encode(jsonObj),
        );
      } catch (e) {
        print(e);
      } finally {
        notifyListeners();
      }
    } else
      print('... prodIndex not valid');
  }
}
