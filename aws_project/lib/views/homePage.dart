import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeState();
  }
}

class HomeState extends State<HomePage> {
  // View
  @override
  Widget build(BuildContext context) {
    return _homeConstruct();
  }

  Widget _homeConstruct() {
    return Scaffold(
      body: Container(color: Colors.white, child: _listProductsConstruct()),
    );
  }

  Widget _listProductsConstruct() {
    return ListView(
      children: <Widget>[],
    );
  }
}
