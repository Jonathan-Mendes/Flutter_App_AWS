import 'package:flutter/material.dart';
import 'package:aws_project/services/deleteProductService.dart';

class DialogComponent {
  DeleteProductService deleteProductService = new DeleteProductService();

  Future showDeleteDialog(BuildContext context, String id, String nome) async {
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
                    deleteProductService.delete(context, id);
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
}
