import 'package:examen/cart.dart';
import 'package:examen/list_produits.dart';
import 'package:examen/signin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        "/home": (context) => MyHomePage(),
        "/signin": (context) => SignIn(),
        "/cart": (context) => Panier(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String username;
  String email;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> userId;
  Future<dynamic> getUser() async {
    return _prefs.then((SharedPreferences prefs) {
      var map = {
        "username": prefs.getString('username' ?? null),
        "email": prefs.getString('email' ?? null)
      };
      return map;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser().then((value) => {
          value["username"] == null
              ? Navigator.pushReplacementNamed(context, "/signin")
              : () {
                  this.username = value["username"];
                  this.email = value["email"];
                  print(this.email + this.username);
                }
        });

    openDatabase("examen.db", onCreate: (Database db, int version) {
      db.execute(
          "CREATE TABLE cart(id TEXT PRIMARY KEY, label TEXT, description TEXT, image TEXT, price INTEGER)");
    }, version: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 100,
              color: Colors.blue,
              child: Row(
                children: [
                  //Image here
                  Image.asset("assets/f1.png", height: 75, width: 75),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("this.username"), Text("this.email")],
                  )
                ],
              ),
            ),
            ListTile(
              title: Text("Se déconnecter"),
              leading: Icon(Icons.power_settings_new),
              onTap: () async {
                SharedPreferences prefs = await this._prefs;
                prefs.clear();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/signin', (Route<dynamic> route) => false);
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Esprit shop"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(icon: Icon(Icons.shop), title: Text("Cart"))
        ],
        onTap: (value) {
          if (value == 0)
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/home', (Route<dynamic> route) => false);
          ;
          if (value == 1)
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/cart', (Route<dynamic> route) => false);
          ;
        },
      ),
      body: ListProduits(),
    );
  }
}
