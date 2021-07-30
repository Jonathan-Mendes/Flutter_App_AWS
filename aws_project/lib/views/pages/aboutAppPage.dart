import 'dart:async';
import 'package:flutter/material.dart';

class AboutAppPage extends StatefulWidget {
  const AboutAppPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _AboutAppState();
  }
}

class _AboutAppState extends State<AboutAppPage> {
  // View
  @override
  Widget build(BuildContext context) {
    return _createProductConstruct();
  }

  Widget _createProductConstruct() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Sobre o Aplicativo'),
        ),
        body: Container(color: Colors.white, child: _bodyConstruct()));
  }

  Widget _bodyConstruct() {
    return Center(
        child: Column(children: <Widget>[
      Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text('Aplicativo Desenvolvido em Flutter',
                      style: TextStyle(fontSize: 17))),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text('Versão 1.0.0', style: TextStyle(fontSize: 17))),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text('By Jonathan Mendes',
                      style: TextStyle(fontSize: 17))),
            ],
          )),
    ]));
  }
}
