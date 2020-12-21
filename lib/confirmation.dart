import 'package:flutter/material.dart';
import 'main.dart';

class Confirmation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context, APP_NAME, panier: false),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.check_circle,
              size: 200.0,
              color: Colors.green,
            ),
            Text(
              'Commande envoyée !',
              style: TextStyle(
                fontSize: 30.0,
                fontFamily: 'Comfortaa',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Text(
                'Elle vous attendra dans votre boître aux lettres. 📫 \n (Si elle rentre)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Comfortaa',
                ),
              ),
            ),
          ],
        ));
  }
}
