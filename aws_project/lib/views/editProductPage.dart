import 'dart:convert';
import 'package:aws_project/views/homePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aws_project/models/productModel.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({Key? key, required this.product}) : super(key: key);

  final Map<String, dynamic> product;

  @override
  State<StatefulWidget> createState() {
    return new _EditProductPageState();
  }
}

class _EditProductPageState extends State<EditProductPage> {
  // Variables
  bool _edited = false;
  TextEditingController _codProd = new TextEditingController();
  TextEditingController _nameProd = new TextEditingController();
  TextEditingController _descProd = new TextEditingController();
  TextEditingController _valueProd = new TextEditingController();

  @override
  void initState() {
    _codProd.text = widget.product['id'];
    _nameProd.text = widget.product['nome'];
    _descProd.text = widget.product['descricao'];
    _valueProd.text = widget.product['preco'].toString();

    super.initState();
  }

  // View
  @override
  Widget build(BuildContext context) {
    return _editProductConstruct();
  }

  Widget _editProductConstruct() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Editar Produto'),
        ),
        body: Container(color: Colors.white, child: _formConstruct()));
  }

  Widget _formConstruct() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                  controller: _codProd,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Código',
                    labelStyle: TextStyle(
                      color: Colors.black38,
                      fontSize: 18,
                    ),
                  ),
                  style: TextStyle(fontSize: 15),
                  onChanged: (String value) async {
                    if (value == widget.product['id']) {
                      setState(() {
                        _edited = false;
                      });
                      return;
                    } else {
                      setState(() {
                        _edited = true;
                      });
                    }
                  })),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
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
                  onChanged: (String value) async {
                    if (value == widget.product['id']) {
                      setState(() {
                        _edited = false;
                      });
                      return;
                    } else {
                      setState(() {
                        _edited = true;
                      });
                    }
                  })),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
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
                  onChanged: (String value) async {
                    if (value == widget.product['id']) {
                      setState(() {
                        _edited = false;
                      });
                      return;
                    } else {
                      setState(() {
                        _edited = true;
                      });
                    }
                  })),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
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
                  onChanged: (String value) async {
                    if (value == widget.product['id']) {
                      setState(() {
                        _edited = false;
                      });
                      return;
                    } else {
                      setState(() {
                        _edited = true;
                      });
                    }
                  })),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  alignment: Alignment.center,
                  child: SizedBox.expand(
                      child: ElevatedButton(
                          child: Text('Salvar'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                            textStyle:
                                TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          onPressed: _edited ? () {} : null))))
        ],
      ),
    );
  }
}
