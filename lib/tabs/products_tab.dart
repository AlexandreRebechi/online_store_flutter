import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_store/tiles/category_tile.dart';

class ProductsTab extends StatelessWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection("products_online_store").get(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          } else {

            var dividedTiles = ListTile.divideTiles(tiles: snapshot.data!.docs.map((docs){
              return CategoryTile(snapshot: docs);
            }
            ).toList(),
            color: Colors.grey[500]).toList();

            return ListView(
              children: dividedTiles,
            );
          }
        }
    );
  }
}
