import 'package:flutter/material.dart';
import 'package:aws_project/controllers/productController.dart';
import 'package:aws_project/views/pages/homePage.dart';
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
  final FormatUtil formatUtil = new FormatUtil();
  final ProductController productController = new ProductController();
  final TextEditingController _codProd = new TextEditingController();
  final TextEditingController _nameProd = new TextEditingController();
  final TextEditingController _descProd = new TextEditingController();
  final _valueProd = new MoneyMaskedTextController(leftSymbol: 'R\$ ');

  // Methods
  void _save() async {
    String _valueProdFormated = formatUtil.formatCurency(_valueProd.text);

    ProductModel _product = new ProductModel(
        _codProd.text, _nameProd.text, _descProd.text, _valueProdFormated);

    bool _response = await productController.createProduct(_product);

    if (_response)
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
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
          title: Text('Novo Produto'),
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
                    textCapitalization: TextCapitalization.characters)),
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
                  textCapitalization: TextCapitalization.sentences,
                )),
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
