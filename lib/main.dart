import 'package:basket/screens/entryScreens/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {

  return runApp( MyApp(), );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Welcome(),
    );
  }
}
