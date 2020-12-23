import 'package:App/data_recette_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_bloc.dart';
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
  @override
  Widget build(BuildContext context) {
    var recette =
        Provider.of<RecetteDataBloc>(context).getRecette(widget.recette);
    void _checkbox(bool value) {
      setState(() {
        recette.state = value;
        switch (value) {
          case true:
            Provider.of<CartBloc>(context, listen: false).addToCart(recette);
            break;
          case false:
            Provider.of<CartBloc>(context, listen: false).clear(recette);
            break;
        }
        print(Provider.of<CartBloc>(context, listen: false).cart);
      });
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
                value: recette.state,
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

    Widget textallergenes() => Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Allergènes : ",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                for (var allergenes in widget.recette.allergenes)
                  Text(
                    "- " + allergenes,
                    style: TextStyle(
                      height: 1.5,
                    ),
                  )
              ]),
          padding: const EdgeInsets.all(32),
        );

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(APP_NAME),
      // ),
      appBar: appBar(context, APP_NAME),
      body: ListView(
        children: [
          Image.asset(
            recette.photoUrl,
            width: 600,
            height: 240,
            fit: BoxFit.cover,
          ),
          titleSection(recette.title, recette.prix),
          textSection(),
          textallergenes(),
        ],
      ),
    );
  }

  AppBar appBar(BuildContext context, String title, {bool panier = true}) {
    void _route(BuildContext context) async {
      await Navigator.pushNamed(context, ROUTE_CART);

      setState(() {});
    }

    Container _buildCartIcon() => Container(
        padding: EdgeInsets.only(right: 4),
        alignment: Alignment.center,
        child: Stack(
          children: <Widget>[
            new Icon(Icons.shopping_cart),
            new Positioned(
              child: new Icon(
                Icons.circle,
                color: Colors.red[300],
                size: 15,
              ),
              left: 10,
            ),
            new Positioned(
              child: Consumer<CartBloc>(
                builder: (context, value, child) {
                  return Text(value.cart.length.toString(),
                      style: TextStyle(fontSize: 10));
                },
              ),
              left: 15,
              top: 2,
            )
          ],
        ));
    return AppBar(
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Text(title),
      actions: <Widget>[
        (panier)
            ? Container(
                child: GestureDetector(
                  onTap: () {
                    _route(context);
                  },
                  child: _buildCartIcon(),
                ),
              )
            : Text("")
      ],
    );
  }
}
