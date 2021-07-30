import 'package:aws_project/views/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:aws_project/utils/formatUtil.dart';
import 'package:aws_project/models/productModel.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:aws_project/controllers/productController.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({Key? key, required this.product}) : super(key: key);

  final Map<String, dynamic> product;

  @override
  State<StatefulWidget> createState() {
    return new _EditProductState();
  }
}

class _EditProductState extends State<EditProductPage> {
  // Variables
  bool _edited = false;
  final FormatUtil formatUtil = new FormatUtil();
  final ProductController productController = new ProductController();
  final TextEditingController _codProd = new TextEditingController();
  final TextEditingController _nameProd = new TextEditingController();
  final TextEditingController _descProd = new TextEditingController();
  final _valueProd = new MoneyMaskedTextController(leftSymbol: 'R\$ ');

  @override
  void initState() {
    _codProd.text = widget.product['id'];
    _nameProd.text = widget.product['nome'];
    _descProd.text = widget.product['descricao'];
    _valueProd.text = widget.product['preco'];

    super.initState();
  }

  // Methods
  void _save() async {
    String _valueProdFormated = formatUtil.formatCurency(_valueProd.text);

    ProductModel _product = new ProductModel(
        _codProd.text, _nameProd.text, _descProd.text, _valueProdFormated);

    print(_product.preco);

    bool _response = await productController.editProduct(_product);

    if (_response)
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  Future _showEditDialog() async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Editar Produto'),
            content: Container(
              child: Text('Você realmente deseja salvar estas alterações?'),
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
                    _save();
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
                enabled: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Código',
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontSize: 18,
                  ),
                ),
                style: TextStyle(fontSize: 15, color: Colors.black38),
              )),
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
                    if (value == widget.product['nome']) {
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
                    if (value == widget.product['descricao']) {
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
                    if (value == widget.product['preco']) {
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
                          onPressed: _edited
                              ? () {
                                  _showEditDialog();
                                }
                              : null))))
        ],
      ),
    );
  }
}
