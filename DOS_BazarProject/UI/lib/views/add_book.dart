// ignore_for_file: prefer_final_fields

import 'package:bazar/models/http_exveption.dart';
import 'package:bazar/providers/books.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddBookView extends StatefulWidget {
  static const routeName = '/add-book';
  const AddBookView({Key? key}) : super(key: key);

  @override
  State<AddBookView> createState() => _AddBookViewState();
}

class _AddBookViewState extends State<AddBookView> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, dynamic> _authData = {
    'name': '',
    'topic': '',
    'price': 0.0,
    'countInStock': 0,
  };

  @override
  void dispose() {
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();

    try {
      // submit book
      Provider.of<Books>(context, listen: false)
          .addBook(
        _authData['name'] as String,
        _authData['topic'] as String,
        double.parse(_authData['price']),
        int.parse(_authData['countInStock']),
      )
          .then((value) {
        if (value != 'done') {
          _showErrorDialog(value);
        }
      });
    } on Exception catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      const errorMessage = 'Could not add book now. Please try again later.';
      _showErrorDialog(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 500,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 8.0,
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Book Name'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Invalid book name!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['name'] = value!;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'topic'),
                        // obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Invalid book topic!';
                          }
                        },
                        onSaved: (value) {
                          _authData['topic'] = value!;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Price'),
                        // obscureText: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value!.isEmpty || double.parse(value) <= 0.0) {
                            return 'Invalid number!';
                          }
                        },
                        onSaved: (value) {
                          _authData['price'] = value!;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Count in Stock'),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value!.isEmpty || int.parse(value) <= 0) {
                            return 'Invalid number!';
                          }
                        },
                        onSaved: (value) {
                          _authData['countInStock'] = value!;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        child: const Text('Add Book'),
                        onPressed: _submit,
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: const BorderSide(color: Colors.red)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
