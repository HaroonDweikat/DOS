// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:bazar/models/book.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

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

  final String chaceUrl = 'http://localhost:5160/api/cache';
  final String apiUrl = 'http://localhost:5160/api';

  Future<void> fetchAndSetBooks() async {
    try {
      var response = await http.get(
        Uri.parse('$chaceUrl/GetAllBooks/books'),
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
      //       '${catalogServer[catalogServerIndex % catalogServer.length]}/getAllBooks'));
      //   print(
      //       'catalogServer send request to replica => ${catalogServer[catalogServerIndex % catalogServer.length]}');
      //   catalogServerIndex++;
      // } else {
      //   print('cache hit');
      // }

      // var response = await http.get(Uri.parse(
      //     '${catalogServer[catalogServerIndex % catalogServer.length]}/getAllBooks'));
      // print(
      //     'catalogServer send request to replica => ${catalogServer[catalogServerIndex]}');
      // catalogServerIndex++;

      final List<Book> loadedBooks = [];
      // print(' responce ' + response.body);
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

      await Future.delayed(Duration(seconds: 1)).then((value) {
        _items = loadedBooks;
      });
      notifyListeners();
    } catch (e) {
      print('fetch all books => $e');
    }
  }

  Future<List<Book>> searchBooks(String value) async {
    String getBookByTopic = '$chaceUrl/getBooksByTopic/$value';
    if (value == '') {
      if (_items.isEmpty) {
        await fetchAndSetBooks();
      }
      return _items.toList();
    }
    final List<Book> loadedBooks = [];

    // final response = await http.get(Uri.parse(getBookByTopic));
    try {
      var response = await http.get(
        Uri.parse(getBookByTopic),
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
      //       '${catalogServer[catalogServerIndex % catalogServer.length]}/searchByTopic/$value'));
      //   print(
      //       'catalogServer send request to replica => ${catalogServer[catalogServerIndex % catalogServer.length]}/searchByTopic/$value');
      //   catalogServerIndex++;
      // } else {
      //   print('cache hit');
      // }

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
    // String getBookById =
    //     'http://localhost:5025/api/books/getInfoById/' + bookId;
    var findedBook;
    try {
      // final response = await http.get(Uri.parse(getBookById));
      var response = await http.get(Uri.parse('$chaceUrl/getBookInfo/$bookId'));
      // if (response.statusCode > 400) {
      //   //cache miss
      //   print('response code  => ${response.statusCode}');
      //   response = await http.get(Uri.parse(
      //       '${catalogServer[catalogServerIndex % catalogServer.length]}/getInfoById/$bookId'));
      //   print(
      //       'catalogServer send request to replica => ${catalogServer[catalogServerIndex % catalogServer.length]}/getInfoById/$bookId');
      //   catalogServerIndex++;
      // }
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
    // const url = 'http://localhost:5025/api/books/addBook/';
    try {
      var toJson = {
        "bookName": name,
        "bookTopic": topic,
        "bookCost": price,
        "countInStock": countInStock,
      };

      // final response = await http.post(
      //   Uri.parse(url),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode(toJson),
      // );
      var response = await http.post(
        Uri.parse('$apiUrl/add/book'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(toJson),
      );
      // print(
      //     'catalogServer send request to replica => ${catalogServer[catalogServerIndex % catalogServer.length]}/addBookToCacheAndSync');
      // print('data => ' + json.encode(toJson));
      // catalogServerIndex++;

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

//#TODO:update problem send array
  Future<void> updateBook(String id, Map<String, dynamic> newBook) async {
    final prodIndex = _items.indexWhere((book) => book.id == id);
    if (prodIndex >= 0) {
      try {
        List<Map<String, dynamic>> jsonObj = [];
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
        // await http.patch(
        //   Uri.parse(url),
        //   headers: {'Content-Type': 'application/json-patch+json'},
        //   body: json.encode(jsonObj),
        // );
        print(
            '--------------------------------------------------\n jjj => ${json.encode(jsonObj)}\n -----------------------------------');
        var response = await http.patch(
          Uri.parse('$apiUrl/add/$id'),
          headers: {'Content-Type': 'application/json-patch+json'},
          body: json.encode(jsonObj),
        );

        // print(
        //     'catalogServer send request to replica => ${catalogServer[catalogServerIndex % catalogServer.length]}/updateCacheAndSync/$id');
        print('data => ' + response.statusCode.toString());
        // catalogServerIndex++;
      } catch (e) {
        print(e);
      } finally {
        fetchAndSetBooks();
        notifyListeners();
      }
    } else
      print('... prodIndex not valid');
  }
}
