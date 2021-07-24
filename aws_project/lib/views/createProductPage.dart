import 'dart:convert';
import 'dart:ffi';
import 'package:aws_project/views/homePage.dart';
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
  // Variables
  final TextEditingController _codProd = new TextEditingController();
  final TextEditingController _nameProd = new TextEditingController();
  final TextEditingController _descProd = new TextEditingController();
  final TextEditingController _valueProd = new TextEditingController();

  // Methods
  Future _post(ProductModel product) async {
    var _url = Uri.parse(
        'https://2zdjuu605f.execute-api.us-east-1.amazonaws.com/prod/product');

    Map<String, String> _headers = {
      'Content-Type': 'application/json; charset=UTF-8'
    };

    var _body = jsonEncode(<String, String>{
      'id': product.id.toString(),
      'nome': product.nome,
      'descricao': product.descricao,
      'image':
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi1.wp.com%2Fwww.clicandoeandando.com%2Fwp-content%2Fuploads%2F2016%2F06%2FComo-tirar-fotos-melhores-com-qualquer-camera-plano-de-fundo.jpg&f=1&nofb=1',
      'preco': product.preco.toString()
    });

    var response = await http.post(_url, headers: _headers, body: _body);

    if (response.statusCode == 201) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else
      throw Exception("Erro criar produto no servidor");
  }

  void _save() async {
    ProductModel product = new ProductModel(int.parse(_codProd.text),
        _nameProd.text, _descProd.text, double.parse(_valueProd.text));

    _post(product);
  }

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
                    _save();
                  })),
          // Padding(
          //     padding: const EdgeInsets.symmetric(vertical: 20),
          //     child: ElevatedButton(
          //         child: Text('Limpar'),
          //         style: ElevatedButton.styleFrom(
          //           primary: Colors.red,
          //           onPrimary: Colors.white,
          //           textStyle: TextStyle(color: Colors.black, fontSize: 20),
          //         ),
          //         onPressed: () {
          //           // _login();
          //         })),
        ],
      ),
    );
  }
}
