import 'package:flutter/material.dart';

class Confirmation extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delivecrous',
          style: TextStyle(
            color: Colors.black
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xffecf59f)
      ),
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
      )
    );
  }
}
