import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aws_project/views/homePage.dart';
import 'package:aws_project/utils/formatUtil.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
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
  final _valueProd = new MoneyMaskedTextController(leftSymbol: 'R\$ ');

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
    FormatUtil formatUtil = new FormatUtil();

    double _valueProdFormated = formatUtil.formatCurency(_valueProd.text);

    ProductModel product = new ProductModel(
        _codProd.text, _nameProd.text, _descProd.text, _valueProdFormated);

    _post(product);
  }

  // View
  @override
  Widget build(BuildContext context) {
    return _createProductConstruct();
  }

  Widget _createProductConstruct() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Criar Novo Produto'),
        ),
        body: Container(color: Colors.white, child: _formConstruct()));
  }

  Widget _formConstruct() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  controller: _codProd,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Código',
                    labelStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                  style: TextStyle(fontSize: 15),
                  textCapitalization: TextCapitalization.characters,
                )),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                    controller: _nameProd,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      labelStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                      ),
                    ),
                    style: TextStyle(fontSize: 15),
                    textCapitalization: TextCapitalization.sentences)),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                    controller: _descProd,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                      labelStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                      ),
                    ),
                    style: TextStyle(fontSize: 15),
                    textCapitalization: TextCapitalization.sentences)),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  controller: _valueProd,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Valor',
                    labelStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                  style: TextStyle(fontSize: 15),
                )),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
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
                          onPressed: () {
                            _save();
                          })),
                )),
          ],
        ),
      ),
    );
  }
}
