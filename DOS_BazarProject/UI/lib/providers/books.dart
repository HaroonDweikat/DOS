import 'dart:convert';

import 'package:bazar/models/book.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Books extends ChangeNotifier {
  List<Book> _items = [];
  //   Book(
  //       id: "0f8fad5b-d9cb-469f-a165-70867728950e",
  //       name: "How to get a good grade in DOS in 40 minutes a day",
  //       topic: "distributed systems",
  //       price: 40,
  //       countInStock: 15),
  //   Book(
  //       id: "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  //       name: "RPCs for Noobs",
  //       topic: "distributed systems",
  //       price: 35,
  //       countInStock: 12),
  //   Book(
  //       id: "a2673dc7-35cb-4bf6-b398-bd1bd435c5f9",
  //       name: "Xen and the Art of Surviving Undergraduate School",
  //       topic: "undergraduate school",
  //       price: 23,
  //       countInStock: 14),
  //   Book(
  //       id: "ab372f43-49d1-4df1-8cf0-bfaa43f82d06",
  //       name: "Cooking for the Impatient Undergrad",
  //       topic: "undergraduate school",
  //       price: 26,
  //       countInStock: 23),
  //   Book(
  //       id: "0f8fad5b-d9cb-469f-a165-70867728950e",
  //       name: "How to get a good grade in DOS in 40 minutes a day",
  //       topic: "distributed systems",
  //       price: 40,
  //       countInStock: 15),
  //   Book(
  //       id: "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  //       name: "RPCs for Noobs",
  //       topic: "distributed systems",
  //       price: 35,
  //       countInStock: 12),
  //   Book(
  //       id: "a2673dc7-35cb-4bf6-b398-bd1bd435c5f9",
  //       name: "Xen and the Art of Surviving Undergraduate School",
  //       topic: "undergraduate school",
  //       price: 23,
  //       countInStock: 14),
  //   Book(
  //       id: "ab372f43-49d1-4df1-8cf0-bfaa43f82d06",
  //       name: "Cooking for the Impatient Undergrad",
  //       topic: "undergraduate school",
  //       price: 26,
  //       countInStock: 23),
  //   Book(
  //       id: "0f8fad5b-d9cb-469f-a165-70867728950e",
  //       name: "How to get a good grade in DOS in 40 minutes a day",
  //       topic: "distributed systems",
  //       price: 40,
  //       countInStock: 15),
  //   Book(
  //       id: "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  //       name: "RPCs for Noobs",
  //       topic: "distributed systems",
  //       price: 35,
  //       countInStock: 12),
  //   Book(
  //       id: "a2673dc7-35cb-4bf6-b398-bd1bd435c5f9",
  //       name: "Xen and the Art of Surviving Undergraduate School",
  //       topic: "undergraduate school",
  //       price: 23,
  //       countInStock: 14),
  //   Book(
  //       id: "ab372f43-49d1-4df1-8cf0-bfaa43f82d06",
  //       name: "Cooking for the Impatient Undergrad",
  //       topic: "undergraduate school",
  //       price: 26,
  //       countInStock: 23),
  // ];
  get items {
    return _items;
  }

  Future<void> fetchAndSetBooks() async {
    String getAllBooks = 'http://localhost:5000/api/books/getAllBooks/';
    try {
      final response = await http.get(Uri.parse(getAllBooks));
      final List<Book> loadedBooks = [];
      // print(response.body);
      final extractedDate = json.decode(response.body) as List<dynamic>;
      if (extractedDate == null) return;

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
      _items = loadedBooks;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  List<Book> searchBooks(String value) {
    if (value == '') {
      return _items.toList();
    }
    List<Book> searchedBooks = _items
        .where((book) => book.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    return searchedBooks != null ? searchedBooks.toList() : _items.toList();
  }

  findById(String bookId) {
    return _items.firstWhere((book) => book.id == bookId);
  }

  addBook(String name, String topic, double price, int countInStock) {
    var newBook = Book(
        id: _items.length.toString(),
        name: name,
        topic: topic,
        price: price,
        countInStock: countInStock);
    _items.add(newBook);
  }
}
/*
Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        'https://shop-app-af479-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      final List<Product> loadedProducts = [];
      final extractedDate = json.decode(response.body) as Map<String, dynamic>;
      if (extractedDate == null) return;
      final favoriteResponse = await http.get(Uri.parse(
          'https://shop-app-af479-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken'));
      final favoriteData = json.decode(favoriteResponse.body);
      extractedDate.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProudct(Product product) async {
    final url =
        'https://shop-app-af479-default-rtdb.asia-southeast1.firebasedatabase.app/products.jsonauth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
          'creatorId': userId,
        }),
      );
      // ignore: unused_local_variable
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite,
        price: product.price,
      );
      _items.add(product);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      try {
        final url =
            'https://shop-app-af479-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.jsonauth=$authToken';
        await http.patch(Uri.parse(url),
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
              'price': newProduct.price,
            }));
        _items[prodIndex] = newProduct;
      } catch (e) {} finally {
        notifyListeners();
      }
    } else
      print('... prodIndex not valid');
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shop-app-af479-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.jsonauth=$authToken';
    final existingProductIndex = _items.lastIndexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();

      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }

 */
