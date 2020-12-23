import 'package:App/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class Confirmation extends StatelessWidget {
  void viderCart(BuildContext context) {
    Provider.of<CartBloc>(context, listen: false).clearAll();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    viderCart(context);
    return Scaffold(
        appBar: appBar(context, APP_NAME),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.check_circle,
              //size: 200.0,
              size: deviceWidth * 0.5,
              color: Colors.green,
            ),
            Text(
              'Commande envoyée !',
              style: TextStyle(
                fontSize: 30.0,
                //fontFamily: 'Comfortaa',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Text(
                'Elle vous attendra dans votre boître aux lettres. 📫 \n (Si elle rentre)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  //fontFamily: 'Comfortaa',
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, "/", (route) => false),
                child: Text("Ok"))
          ],
        ));
  }
}

AppBar appBar(BuildContext context, String title) {
  return AppBar(
    // Here we take the value from the MyHomePage object that was created by
    // the App.build method, and use it to set our appbar title.
    title: Text(title),
  );
}
