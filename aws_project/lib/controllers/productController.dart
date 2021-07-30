import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aws_project/models/productModel.dart';

class ProductController {
  Future<bool> createProduct(ProductModel product) async {
    var _url = Uri.parse(
        'https://2zdjuu605f.execute-api.us-east-1.amazonaws.com/prod/product');

    Map<String, String> _headers = {
      'Content-Type': 'application/json; charset=UTF-8'
    };

    var _body = jsonEncode(<String, String>{
      'id': product.id,
      'nome': product.nome,
      'descricao': product.descricao,
      'preco': product.preco.toString()
    });

    var response = await http.post(_url, headers: _headers, body: _body);

    if (response.statusCode == 201) {
      return true;
    } else
      throw Exception("Erro criar produto no servidor");
  }
}
