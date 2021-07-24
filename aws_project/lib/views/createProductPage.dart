import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aws_project/models/productModel.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _CreateProductPageState();
  }
}

class _CreateProductPageState extends State<CreateProductPage> {
  // View
  @override
  Widget build(BuildContext context) {
    return _createProductConstruct();
  }

  Widget _createProductConstruct() {
    return Scaffold(
        appBar: AppBar(
          title: Text('Criar Novo Produto'),
        ),
        body: Container(color: Colors.white, child: _formConstruct()));
  }

  Widget _formConstruct() {
    return Form(
      // key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter your email',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                // if (_formKey.currentState!.validate()) {
                //   // Process data.
                // }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
