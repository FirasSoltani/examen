import 'package:examen/list_produits.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Panier extends StatefulWidget {
  const Panier({Key key}) : super(key: key);

  @override
  _PanierState createState() => _PanierState();
}

class _PanierState extends State<Panier> {
  List<Produit> products;

  Future<bool> getProducts() async {
    Database db = await openDatabase("examen.db");

    List<Map<String, dynamic>> maps = await db.query("cart");
    products = List.generate(maps.length, (int index) {
      return Produit(
          maps[index]["id"],
          maps[index]["label"],
          maps[index]["description"],
          maps[index]["image"],
          maps[index]["price"]);
    });

    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      appBar: AppBar(
        title: Text("Esprit shop"),
      ),
      body: Column(
        children: [
          FlatButton(onPressed: null, child: Text("Total a payer")),
          Expanded(
              child: FutureBuilder(
                  future: getProducts(),
                  builder: (context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.data) {
                      return ListView.builder(
                        itemCount: this.products.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Text(
                                this.products[index].label,
                                style: TextStyle(fontSize: 40),
                              ),
                              Image.network("http://localhost:9090/img/" +
                                  this.products[index].image),
                              Text(
                                this.products[index].prix.toString() + " DT",
                                style: TextStyle(fontSize: 35),
                              )
                            ],
                          );
                        },
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }))
        ],
      ),
    );
  }
}
