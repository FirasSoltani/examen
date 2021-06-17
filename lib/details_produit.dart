import 'package:examen/list_produits.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Details extends StatefulWidget {
  const Details({Key key, this.product}) : super(key: key);
  final Produit product;
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.product.label),
      ),
      body: Column(
        children: [
          Image.network(
              "http://localhost:9090/img/" + this.widget.product.image),
          Text(this.widget.product.description),
          Text("Prix : " + this.widget.product.prix.toString() + " DT")
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Database db = await openDatabase("examen.db");
          var product = {
            "id": this.widget.product.id,
            "label": this.widget.product.label,
            "image": this.widget.product.image,
            "description": this.widget.product.description,
            "price": this.widget.product.prix,
          };
          if (db.isOpen) {
            db.insert("cart", product).then((value) => showDialog(
                context: context,
                child: AlertDialog(
                  title: Text("Confirmation"),
                  content: Text("Le produit " +
                      this.widget.product.label +
                      "a été ajouté"),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("OK"),
                    )
                  ],
                )));
          }
        },
        child: Row(
          children: [Icon(Icons.shopping_basket), Text("Ajouter au panier")],
        ),
      ),
    );
  }
}
