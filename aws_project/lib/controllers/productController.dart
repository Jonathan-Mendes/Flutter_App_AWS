import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
// import 'package:aws_project/models/productModel.dart';

class ProcuctController {
  Future getAllProducts() async {
    final _url = Uri.parse(
        'https://2zdjuu605f.execute-api.us-east-1.amazonaws.com/prod/products');

    final response = await http.read(_url);

    print(response);

    //   if (response.statusCode == 200) {
    //     final jsonResponse =
    //         convert.jsonDecode(response.body) as Map<String, dynamic>;

    //     print(jsonResponse);
    //   } else {
    //     print('Error');
    //   }
  }
}
