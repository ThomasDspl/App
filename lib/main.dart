import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'FicheProduit.dart';
import 'FicheProduit.dart';
import 'FicheProduit.dart';
import 'second_screen.dart' as ss;
import 'FicheProduit.dart' as FicheProduit;

List<Recette> panier = [];

const String ROUTE_DETAIL = "/details";
const String APP_NAME = "Chez Hatsune Miku";

const String json = '''
[
    {
        "id": "0",
        "name": "spaghetti bolo_gnaise",
        "description": "MES PRECIEUX ..... SPAGHETTI",
        "prix": 10,
        "photo": "images/spaghetti_bolo_gnaise.png"
    },
    {
        "id": "1",
        "name": "spaghetti bolo_gnaise",
        "description": "MES PRECIEUX ..... SPAGHETTI",
        "prix": 15,
        "photo": "images/spaghetti_bolo_gnaise.png"
    },
    {
        "id": "2",
        "name": "spaghetti bolo_gnaise",
        "description": "MES PRECIEUX ..... SPAGHETTI",
        "prix": 15,
        "photo": "images/spaghetti_bolo_gnaise.png"
    },
    {
        "id": "3",
        "name": "spaghetti bolo_gnaise",
        "description": "MES PRECIEUX ..... SPAGHETTI",
        "prix": 15,
        "photo": "images/spaghetti_bolo_gnaise.png"
    },
    {
        "id": "4",
        "name": "spaghetti bolo_gnaise",
        "description": "MES PRECIEUX ..... SPAGHETTI",
        "prix": 10,
        "photo": "images/spaghetti_bolo_gnaise.png"
    },
    {
        "id": "5",
        "name": "spaghetti bolo_gnaise",
        "description": "MES PRECIEUX ..... SPAGHETTI",
        "prix": 15,
        "photo": "images/spaghetti_bolo_gnaise.png"
    },
    {
        "id": "6",
        "name": "spaghetti bolo_gnaise",
        "description": "MES PRECIEUX ..... SPAGHETTI",
        "prix": 15,
        "photo": "images/spaghetti_bolo_gnaise.png"
    },
    {
        "id": "7",
        "name": "spaghetti bolo_gnaise",
        "description": "MES PRECIEUX ..... SPAGHETTI",
        "prix": 15,
        "photo": "images/spaghetti_bolo_gnaise.png"
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
  bool state = false;

  Recette({this.id, this.title, this.photoUrl, this.description, this.prix});

  factory Recette.fromJson(Map<String, dynamic> json) {
    return Recette(
      id: json["id"] as String,
      title: json["name"] as String,
      description: json["description"] as String,
      photoUrl: json["photo"] as String,
      prix: json["prix"] as int,
    );
  }

  @override
  String toString() {
    // TODO: implement toString
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
        arguments: FicheProduit.FicheProduitArguments(widget.recette));

    setState(() {
      if (result != null) widget.recette.state = result;
    });
  }

  void _setCheckBox(bool state) {
    setState(() {
      widget.recette.state = state;
      switch (state) {
        case true:
          panier.add(widget.recette);
          break;
        case false:
          panier.remove(widget.recette);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  _awaitReturnValueFromDetailsScreen(context);
                },
                child: Image.asset(widget.recette.photoUrl),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(widget.recette.title),
                    Checkbox(
                      value: widget.recette.state,
                      onChanged: _setCheckBox,
                    ),
                  ],
                ),
              ),
              Container(
                child: Text(widget.recette.description, softWrap: true),
              )
            ],
          )),
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
        crossAxisCount: 1,
      ),
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
    return MaterialApp(
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

        if (settings.name == ROUTE_DETAIL) {
          final FicheProduit.FicheProduitArguments args = settings.arguments;

          return MaterialPageRoute(builder: (context) {
            return FicheProduit.FicheProduit(recette: args.recette);
          });
        }
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
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
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

Future<List<Recette>> getData() async {
  //final response = rootBundle.loadString("data.json");

  return getRecetteFromJson(json);
}

List<Recette> getRecetteFromJson(String jsonData) {
  List<Recette> _listRecette = [];
  //var data = json.decode(jsonData);
  final parsed = jsonDecode(jsonData).cast<Map<String, dynamic>>();

  _listRecette = parsed.map<Recette>((json) => Recette.fromJson(json)).toList();

  _listRecette.forEach((element) {
    print(element);
  });

  return _listRecette;
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _initializedWidget() {}

  List<Recette> _listRecette = []; //liste des plat/objets etc...

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Recette>>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? RecetteList(recette: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
      /*body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/castex'),
                child: Text("C'EST NOTRE PROJET")),
          ],
        ),
      ),*/
    );
  }
}
