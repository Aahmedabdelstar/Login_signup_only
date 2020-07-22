
import 'package:flutter/material.dart';


class Store extends StatefulWidget {
  final Function() notifyParent;

  //List<Product> productList =  <Product>[];
  Store({Key key, @required this.notifyParent}) : super(key: key);

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  @override
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Center(child: Text("Welcome")),
    );
  }
}
