import 'dart:convert';
import 'package:App/cart_page.dart';
import 'package:App/data_recette_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'fiche_produit.dart';
import 'cart_bloc.dart';
import 'confirmation.dart';

const String ROUTE_DETAIL = "/details";
const String ROUTE_CART = "/cart";
const String ROUTE_CONFIRMATION = "/confirmation";
const String APP_NAME = "Chez Hatsune Miku";
const Color COULEUR_PRINCIPALE = Color.fromRGBO(255, 231, 76, 1.0);
const String json = '''
[
    {
        "id": "0",
        "name": "Spaghetti bolognaise",
        "description": "De bonne spaghetti avec leur sauce tomate légèrement sucré et sa viande de boeuf tendre et savoureuse.",
        "prix": 7,
        "photo": "images/spaghetti_bolo_gnaise.png",
        "allergenes": ["Céleri","Céréale contenant du gluten","Fruit à coque"]
    },
    {
        "id": "1",
        "name": "Hachi parmentier",
        "description": "Un hachi parmentier confectionner avec des pommes de terre de la région et une déliceuse viande de boeuf.",
        "prix": 10,
        "photo": "images/parmentier.jpg",
        "allergenes": ["Lait"]
    },
    {
        "id": "2",
        "name": "Cheeseburger",
        "description": "Un délicieux cheeseburger maison avec du beacon, du boeuf, de la salade et son frommage cheedar.",
        "prix": 15,
        "photo": "images/Cheeseburger.png",
        "allergenes": ["Céréales contenant du gluten","Lait","Moutarde"]
    },
    {
        "id": "3",
        "name": "Pizza",
        "description": "Une pizza avec une pâte légère et croustiante garnit jusqu'à rabord.",
        "prix": 17,
        "photo": "images/pizza.jpg",
        "allergenes": ["Lait"]
    },
    {
        "id": "4",
        "name": "Fish and Chip",
        "description": "Un délicieux filet de colin frit avec de déliceuses frites.",
        "prix": 12,
        "photo": "images/fish_and_chip.jpg",
        "allergenes": ["Céréales contenant du gluten","Lait","Mollusque", "Oeufs", "Poissons"]
    },
    {
        "id": "5",
        "name": "Salade de fruit",
        "description": "Un déliceux mélange de fruit rafréchissant.",
        "prix": 8,
        "photo": "images/salade_fruit.jpg",
        "allergenes": ["Aucun allergène"]
    },
    {
        "id": "6",
        "name": "Glace vanille",
        "description": "Une glace à la vanille rafraichissante.",
        "prix": 9,
        "photo": "images/glace_vanille.jpg",
        "allergenes": ["Lait "]
    }
]
''';

void main() {
  runApp(MyApp());
}

/*------OBJETS------------ */

class Recette {
  final String id;
  final String title;
  final String photoUrl;
  final String description;
  final int prix;
  final List<dynamic> allergenes;
  bool state = false;

  Recette(
      {this.id,
      this.title,
      this.photoUrl,
      this.description,
      this.prix,
      this.allergenes});

  factory Recette.fromJson(Map<String, dynamic> json) {
    return Recette(
      id: json["id"] as String,
      title: json["name"] as String,
      description: json["description"] as String,
      photoUrl: json["photo"] as String,
      prix: json["prix"] as int,
      allergenes: json["allergenes"] as List<dynamic>,
    );
  }

  @override
  String toString() {
    return "ID: " + id;
  }
}

/*------------------------- */

class RecetteWidget extends StatefulWidget {
  final Recette recette;
  RecetteWidget({Key key, this.recette}) : super(key: key);

  @override
  _RecetteWidgetState createState() => _RecetteWidgetState();
}

class _RecetteWidgetState extends State<RecetteWidget> {
  void _awaitReturnValueFromDetailsScreen(BuildContext context) async {
    final result = await Navigator.pushNamed(context, ROUTE_DETAIL,
        arguments: FicheProduitArguments(widget.recette));

    setState(() {
      if (result != null) widget.recette.state = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    var recette =
        Provider.of<RecetteDataBloc>(context).getRecette(widget.recette);
    void _setCheckBox(bool state) {
      setState(() {
        recette.state = state;
        switch (state) {
          case true:
            Provider.of<CartBloc>(context, listen: false).addToCart(recette);
            break;
          case false:
            Provider.of<CartBloc>(context, listen: false).clear(recette);
            break;
        }
      });
    }

    return Consumer<RecetteDataBloc>(
      builder: (context, value, child) => Container(
        padding: const EdgeInsets.all(4),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Color.fromRGBO(255, 89, 100, 1.0), width: 0.5),
                borderRadius: BorderRadius.circular(5.0)),
            //padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                Container(
                  // width: 200,
                  // height: 100,
                  height: deviceHeight * 0.13,
                  width: deviceWidth,
                  child: InkWell(
                    onTap: () {
                      _awaitReturnValueFromDetailsScreen(context);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.asset(
                        recette.photoUrl,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        Text(recette.title),
                        Row(
                          children: [
                            Expanded(
                                child: Text(recette.prix.toString() + " €")),
                            Checkbox(
                              value: recette.state,
                              onChanged: _setCheckBox,
                            ),
                          ],
                        ),
                        Container(
                          child: Text(
                            widget.recette.description,
                            softWrap: true,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    )),
              ],
            )),
      ),
    );
  }
}

class RecetteList extends StatelessWidget {
  final List<Recette> recette;

  RecetteList({Key key, this.recette}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.7),
      itemCount: recette.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return RecetteWidget(
          recette: this.recette[index],
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartBloc>(create: (context) => CartBloc()),
        ChangeNotifierProvider<RecetteDataBloc>(
            create: (context) => RecetteDataBloc()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        // routes: {
        //   '/': (context) => MyHomePage(title: 'LOL'),
        //   '/castex': (context) => ss.SecondScreen(title: "Second Screen"),
        // },
        onGenerateRoute: (settings) {
          if (settings.name == '/') {
            return MaterialPageRoute(
                builder: (context) => MyHomePage(
                      title: APP_NAME,
                    ));
          }

          if (settings.name == ROUTE_CART) {
            return MaterialPageRoute(builder: (context) => PageCart());
          }

          if (settings.name == ROUTE_CONFIRMATION) {
            return MaterialPageRoute(builder: (context) => Confirmation());
          }

          if (settings.name == ROUTE_DETAIL) {
            final FicheProduitArguments args = settings.arguments;

            return MaterialPageRoute(builder: (context) {
              return FicheProduit(recette: args.recette);
            });
          }
          return MaterialPageRoute(
              builder: (context) => MyHomePage(
                    title: APP_NAME,
                  ));
        },
        title: APP_NAME,
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
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

List<Recette> getData() {
  //final response = rootBundle.loadString("data.json");
  List<Recette> list = getRecetteFromJson(json);
  return list;
}

List<Recette> getRecetteFromJson(String jsonData) {
  List<Recette> _listRecette = [];
  //var data = json.decode(jsonData);
  final parsed = jsonDecode(jsonData).cast<Map<String, dynamic>>();
  _listRecette = parsed.map<Recette>((json) => Recette.fromJson(json)).toList();
  return _listRecette;
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: appBar(context, widget.title),
      body: Consumer<RecetteDataBloc>(
        builder: (context, bloc, child) {
          return (bloc.list.isEmpty)
              ? Center(child: CircularProgressIndicator())
              : RecetteList(recette: bloc.list);
        },
      ),
    );
  }

  AppBar appBar(BuildContext context, String title, {bool panier = true}) {
    void _route(BuildContext context) async {
      await Navigator.pushNamed(context, ROUTE_CART);

      setState(() {});
    }

    Container _buildCartIcon() => Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(right: 4),
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
