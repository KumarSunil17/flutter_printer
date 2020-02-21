import 'package:flutter/material.dart';
import 'package:flutter_printer/home_page.dart';
import 'package:provider/provider.dart';

import 'cart_model.dart';

void main() => runApp(
    ChangeNotifierProvider(create: (context) => CartModel(), child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage());
  }
}
