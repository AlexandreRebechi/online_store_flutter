import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_store/datas/cart_product.dart';
import 'package:online_store/datas/product_data.dart';
import 'package:online_store/models/cart_model.dart';

class CartTile extends StatelessWidget {
  const CartTile({super.key, required this.product});

  final CartProduct product;



  @override
  Widget build(BuildContext context) {

    Widget _buildContent(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 120.0,
            child: Image.network(
              product.productData!.images![0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      product.productData!.title!,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                    ),
                    Text(
                        "Tamanho ${product.size}",
                        style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    Text(
                      "R\$ ${product.productData!.price!.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                            onPressed: product.quantity! > 1 ? (){
                              CartModel.of(context).decProduct(product);
                            } : null,
                            icon: Icon(Icons.remove),
                            color: Theme.of(context).primaryColor
                        ),
                        Text(product.quantity.toString()),
                        IconButton(
                            onPressed: (){
                              CartModel.of(context).incProduct(product);

                            },
                            icon: Icon(Icons.add),
                            color: Theme.of(context).primaryColor

                        ),
                        TextButton(
                            onPressed: (){
                              CartModel.of(context).removeCartItem(product);


                            },
                            child: Text("Remover", style: TextStyle(color: Colors.grey[500]),),

                        )
                      ],
                    )

                  ],
                ),
              )
          )
        ],
      );

    }
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: product.productData == null ? FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("products_online_store")
              .doc(product.category)
              .collection("itens")
              .doc(product.pid)
              .get(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              product.productData = ProductData.fromDocument(snapshot.data!);
              return _buildContent();
            } else {
              return Container(
                height: 70.0,
                child: CircularProgressIndicator(),
                alignment: Alignment.center,
              );
            }
          }
      ) : _buildContent(),
    );
  }
}
