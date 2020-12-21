import 'package:flutter/material.dart';

import 'main.dart';

class FicheProduitArguments {
  final Recette recette;

  FicheProduitArguments(this.recette);
}

class FicheProduit extends StatefulWidget {
  // This widget is the root of your application.

  final Recette recette;
  const FicheProduit({Key key, this.recette}) : super(key: key);

  @override
  _FicheProduitState createState() => _FicheProduitState();
}

class _FicheProduitState extends State<FicheProduit> {
  void _checkbox(bool value) {
    setState(() {
      widget.recette.state = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Delivecrous'),
        ),
        body: ListView(
          children: [
            Image.asset(
              widget.recette.photoUrl,
              width: 600,
              height: 240,
              fit: BoxFit.cover,
            ),
            titleSection(widget.recette.title, widget.recette.prix),
            textSection(),
          ],
        ),
      ),
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget titleSection(String title, int prix) => Container(
        padding: const EdgeInsets.all(32),
        child: Row(
          children: [
            Expanded(
              /*1*/
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*2*/
                  Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    prix.toString() + ' €',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            /*3*/
            Checkbox(
              value: widget.recette.state,
              onChanged: _checkbox,
            ),
          ],
        ),
      );

  Widget textSection() => Container(
        padding: const EdgeInsets.all(32),
        child: Text(
          widget.recette.description,
          softWrap: true,
        ),
      );
}
