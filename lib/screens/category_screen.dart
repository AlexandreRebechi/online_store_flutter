import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_store/datas/product_data.dart';
import 'package:online_store/tiles/product_tile.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.snapshot});

  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            snapshot.get("title"),
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.grid_on, color: Colors.white)),
              Tab(icon: Icon(Icons.list, color: Colors.white)),
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection("products_online_store")
              .doc(snapshot.id)
              .collection("itens")
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  GridView.builder(
                    padding: EdgeInsets.all(4.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ProductTile(
                        type: "grid",
                        product: ProductData.fromDocument(
                          snapshot.data!.docs[index],
                        ),
                      );
                    },
                  ),
                  ListView.builder(
                    padding: EdgeInsets.all(4.0),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ProductTile(
                        type: "List",
                        product: ProductData.fromDocument(
                          snapshot.data!.docs[index],
                        ),
                      );
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
