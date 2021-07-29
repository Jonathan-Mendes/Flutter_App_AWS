import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aws_project/views/createProductPage.dart';
import 'package:aws_project/views/editProductPage.dart';
import 'package:aws_project/utils/formatUtil.dart';

enum ListAction { edit, delete }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  // Variables
  FormatUtil formatUtil = new FormatUtil();

  void _createProduct() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateProductPage()));
  }

  void _editProduct(Map<String, dynamic> data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProductPage(product: data)));
  }

  Future _showDeleteDialog(BuildContext context, String id, String nome) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Excluir Produto'),
            content: Container(
              child: Text(
                  'Produto: ${nome} \n\n Você realmente deseja excluir este produto?'),
            ),
            actions: <Widget>[
              ElevatedButton(
                  child: Text('Sim'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    textStyle: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  onPressed: () {
                    _deleteProduct(id);
                  }),
              ElevatedButton(
                  child: Text('Não'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                    textStyle: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  })
            ],
          );
        });
  }

  Future _deleteProduct(String id) async {
    var _url = Uri.parse(
        'https://2zdjuu605f.execute-api.us-east-1.amazonaws.com/prod/product');

    Map<String, String> _headers = {
      'Content-Type': 'application/json; charset=UTF-8'
    };

    var _body = jsonEncode(<String, String>{
      'id': id,
    });

    var response = await http.delete(_url, headers: _headers, body: _body);

    if (response.statusCode == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else
      throw Exception("Erro excluir produto no servidor");
  }

  Future<List> _listProducts() async {
    var _url = Uri.parse(
        'https://2zdjuu605f.execute-api.us-east-1.amazonaws.com/prod/products');

    var response = await http.get(_url);

    if (response.statusCode == 200) {
      var objectResponse = json.decode(utf8.decode(response.bodyBytes));
      objectResponse = objectResponse["products"] as List;
      return objectResponse;
    } else
      throw Exception("Erro ao buscar produtos no servidor");
  }

  // View
  @override
  Widget build(BuildContext context) {
    return _homeConstruct();
  }

  Widget _homeConstruct() {
    return Scaffold(
        appBar: AppBar(
          title: Text('Produtos'),
        ),
        body: Container(color: Colors.white, child: _listProductsConstruct()),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _createProduct();
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ));
  }

  Widget _listProductsConstruct() {
    return FutureBuilder<List>(
      future: _listProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar os produtos!'));
        }

        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.wallpaper_rounded,
                      size: 45, color: Colors.deepPurple),
                  title: Text(snapshot.data![index]['nome']),
                  subtitle: Text(snapshot.data![index]['descricao'] +
                      '\n' +
                      formatUtil.formatMoney(snapshot.data![index]['preco'])),
                  trailing: PopupMenuButton<ListAction>(
                    onSelected: (ListAction result) async {
                      switch (result) {
                        case ListAction.edit:
                          _editProduct(snapshot.data![index]);
                          break;
                        case ListAction.delete:
                          _showDeleteDialog(
                              context,
                              snapshot.data![index]['id'],
                              snapshot.data![index]['nome']);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry<ListAction>>[
                        PopupMenuItem<ListAction>(
                          value: ListAction.edit,
                          child: Row(children: <Widget>[
                            Icon(Icons.edit, color: Colors.orange),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text('Editar',
                                  style: TextStyle(color: Colors.black)),
                            )
                          ]),
                        ),
                        PopupMenuItem<ListAction>(
                          value: ListAction.delete,
                          child: Row(children: <Widget>[
                            Icon(Icons.delete, color: Colors.red),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text('Excluir',
                                  style: TextStyle(color: Colors.black)),
                            )
                          ]),
                        )
                      ];
                    },
                  ),
                );
              });
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
