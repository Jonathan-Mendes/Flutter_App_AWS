import 'package:flutter/material.dart';
import 'package:flutter/src/material/colors.dart';
import 'views/pages/homePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AWS APP',
      theme: ThemeData(
          primarySwatch: Colors.red, scaffoldBackgroundColor: Colors.white),
      home: HomePage(),
    );
  }
}
