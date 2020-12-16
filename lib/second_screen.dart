import 'package:flutter/material.dart';

import 'main.dart';
import 'main.dart';

class SecondScreenArguments {
  final String title;
  final Recette recette;

  SecondScreenArguments(this.title, this.recette);
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key key, this.title, this.recette}) : super(key: key);
  final String title;
  final Recette recette;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: Center(
          child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        child: Text("╰(*°▽°*)╯"),
      )),
    );
  }
}
