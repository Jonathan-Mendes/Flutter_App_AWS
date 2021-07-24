import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aws_project/views/createProductPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  void _createProduct() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateProductPage()));
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
          return Center(child: Text('Erro ao carregar os produtos'));
        }

        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                    leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            NetworkImage(snapshot.data![index]['image'])),
                    title: Text(snapshot.data![index]['nome']),
                    subtitle: Text(snapshot.data![index]['descricao']),
                    trailing: Text(snapshot.data![index]['preco'].toString()));
              });
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
