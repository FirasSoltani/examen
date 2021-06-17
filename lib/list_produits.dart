import 'dart:convert';

import 'package:examen/details_produit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListProduits extends StatefulWidget {
  const ListProduits({Key key}) : super(key: key);

  @override
  _ListProduitsState createState() => _ListProduitsState();
}

class _ListProduitsState extends State<ListProduits> {
  List<Produit> products = [];
  Future<bool> getProducts() async {
    http.Response response = await http.get("http://localhost:9090/product");
    List<dynamic> data = json.decode(response.body);
    print(data);
    if (data.isNotEmpty) {
      data.forEach((element) {
        element != null
            ? this.products.add(new Produit(
                element["_id"],
                element["label"],
                element["description"],
                element["image"],
                int.parse(element["price"])))
            : print("Element null");
      });
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getProducts(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData)
            return ListView.builder(
              itemCount: this.products.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Details(
                                  product: this.products[index],
                                )));
                  },
                  child: new Column(
                    children: [
                      Text(this.products[index].label),
                      Image.network("http://localhost:9090/img/" +
                          this.products[index].image),
                      Text(this.products[index].prix.toString() + " DT")
                    ],
                  ),
                );
              },
            );
          else {
            return (Center(
              child: CircularProgressIndicator(),
            ));
          }
        },
      ),
    );
  }
}

class Produit {
  Produit(this.id, this.label, this.description, this.image, this.prix);
  String id;
  String label;
  String description;
  String image;
  int prix;
}
