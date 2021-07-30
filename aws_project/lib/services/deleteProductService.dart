import 'package:flutter/material.dart';
import 'package:aws_project/views/pages/homePage.dart';
import 'package:aws_project/controllers/productController.dart';

class DeleteProductService {
  ProductController productController = ProductController();

  void delete(BuildContext context, String id) async {
    bool _response = await productController.deleteProduct(id);

    if (_response)
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
  }
}
