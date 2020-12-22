import 'package:App/data_recette_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_bloc.dart';
import 'confirmation.dart';
import 'main.dart';

class PageCart extends StatefulWidget {
  PageCart({Key key}) : super(key: key);

  @override
  _PageCartState createState() => _PageCartState();
}

class _PageCartState extends State<PageCart> {
  @override
  Widget build(BuildContext context) {
    var cartBloc = Provider.of<CartBloc>(context);
    AppBar appBar(BuildContext context, String title, {bool panier = true}) {
      void _route(BuildContext context) async {
        await Navigator.pushNamed(context, ROUTE_CART);

        setState(() {});
      }

      var bloc = Provider.of<CartBloc>(context, listen: false);

      int totalCount = 0;
      if (bloc.cart.length > 0) {
        totalCount = bloc.cart.length;
      }
      Container _buildCartIcon(totalCount) => Container(
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              new Icon(Icons.shopping_cart),
              // new Positioned(
              //   child: new Icon(
              //     Icons.circle,
              //     color: Color.fromRGBO(100, 0, 0, 1),
              //     size: 15,
              //   ),
              //   left: 10,
              // ),
              // new Positioned(
              //   child:
              //       new Text(totalCount.toString(), style: TextStyle(fontSize: 10)),
              //   left: 15,
              //   top: 2,
              // )
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
                    child: _buildCartIcon(totalCount),
                  ),
                )
              : Text("")
        ],
      );
    }

    return MaterialApp(
      title: APP_NAME,
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
              builder: (context) => MyHomePage(
                    title: APP_NAME,
                  ));
        }

        if (settings.name == ROUTE_CONFIRMATION) {
          return MaterialPageRoute(builder: (context) => Confirmation());
        }

        return MaterialPageRoute(
            builder: (context) => MyHomePage(
                  title: APP_NAME,
                ));
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: COULEUR_PRINCIPALE,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: appBar(context, APP_NAME),
        body: (cartBloc.cart.isNotEmpty)
            ? RecetteListCart(
                recette: cartBloc,
              )
            : Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 200,
                      color: Colors.red[800],
                    ),
                    Text(
                      "Panier vide",
                      style: TextStyle(fontSize: 40),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class RecetteWidgetCart extends StatefulWidget {
  final Recette recette;
  RecetteWidgetCart({Key key, this.recette}) : super(key: key);

  @override
  _RecetteWidgetCartState createState() => _RecetteWidgetCartState();
}

class _RecetteWidgetCartState extends State<RecetteWidgetCart> {
  @override
  Widget build(BuildContext context) {
    var recette =
        Provider.of<RecetteDataBloc>(context).getRecette(widget.recette);
    void _setCheckBox() {
      setState(() {
        recette.state = false;
        Provider.of<CartBloc>(context, listen: false).clear(recette);
        print(Provider.of<CartBloc>(context, listen: false).cart);
      });
    }

    return Consumer<RecetteDataBloc>(
      builder: (context, value, child) => Container(
        padding: const EdgeInsets.all(4),
        height: 125,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Color.fromRGBO(255, 89, 100, 1.0), width: 0.5),
                borderRadius: BorderRadius.circular(5.0)),
            //padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.asset(
                      recette.photoUrl,
                      width: 125,
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(left: 4, top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(recette.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        Container(
                          width: 190,
                          child: Text(
                            widget.recette.description,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    )),
                Container(
                  padding: EdgeInsets.only(top: 4, bottom: 4),
                  child: Column(
                    children: [
                      Expanded(
                        child: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.red[900],
                              size: 40,
                            ),
                            onPressed: _setCheckBox),
                      ),
                      Text(recette.prix.toString() + " €",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class RecetteListCart extends StatelessWidget {
  final CartBloc recette;

  RecetteListCart({Key key, this.recette}) : super(key: key);

  void finalPage(BuildContext context) {
    recette.cart.forEach((element) {
      element.state = false;
    });
    Navigator.pushNamed(context, ROUTE_CONFIRMATION);
    recette.clearAll();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: recette.cart.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              return RecetteWidgetCart(
                recette: this.recette.cart[index],
              );
            },
          ),
          Container(
            padding: EdgeInsets.only(right: 10),
            alignment: Alignment.centerRight,
            child: Text("Total: " + recette.totalPrice().toString() + " €",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
          textForm(context)
        ]));
  }

  Widget textForm(BuildContext context) => Container(
        padding: EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Ou veux-tu te faire livrer ? : ",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "En salle de TD ? ",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Rue',
                    hintText: 'Entrer du texte',
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Veuillez saisir un texte';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Ville',
                    hintText: 'Entrer du texte',
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Veuillez saisir un texte';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Code Postal',
                    hintText: 'Entrer du texte',
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Veuillez saisir un texte';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    /* if (_formKey.currentState.validate()) {
                // Process data.
              }*/
                    finalPage(context);
                  },
                  child: Text('Passer la commande'),
                ),
              ),
            ]),
      );
}
