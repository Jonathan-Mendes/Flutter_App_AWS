import 'dart:convert';
import 'package:aws_project/views/homePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aws_project/models/productModel.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _EditProductPageState();
  }
}

class _EditProductPageState extends State<EditProductPage> {
  // Variables
  final TextEditingController _codProd = new TextEditingController();
  final TextEditingController _nameProd = new TextEditingController();
  final TextEditingController _descProd = new TextEditingController();
  final TextEditingController _valueProd = new TextEditingController();

  // View
  @override
  Widget build(BuildContext context) {
    return _editProductConstruct();
  }

  Widget _editProductConstruct() {
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar Produto'),
        ),
        body: Container(color: Colors.white, child: _formConstruct()));
  }

  Widget _formConstruct() {
    return Form(
      // key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: _codProd,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Código',
              labelStyle: TextStyle(
                color: Colors.black38,
                fontSize: 18,
              ),
            ),
            style: TextStyle(fontSize: 15),
          ),
          TextFormField(
            controller: _nameProd,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Nome',
              labelStyle: TextStyle(
                color: Colors.black38,
                fontSize: 18,
              ),
            ),
            style: TextStyle(fontSize: 15),
          ),
          TextFormField(
            controller: _descProd,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Descrição',
              labelStyle: TextStyle(
                color: Colors.black38,
                fontSize: 18,
              ),
            ),
            style: TextStyle(fontSize: 15),
          ),
          TextFormField(
            controller: _valueProd,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Valor',
              labelStyle: TextStyle(
                color: Colors.black38,
                fontSize: 18,
              ),
            ),
            style: TextStyle(fontSize: 15),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                  child: Text('Salvar'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    textStyle: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  onPressed: () {
                    // _save();
                  })),
        ],
      ),
    );
  }
}
