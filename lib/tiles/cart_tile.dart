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
    Widget buildContent() {
      CartModel.of(
        context,
      ).updatePrices(); //quando carregar os produtos, vai pedir para atualizar os preços no cart_price.dart
      ///mostra informações dos itens
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
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
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17.0,
                    ),
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: product.quantity! > 1
                            ? () {
                                CartModel.of(context).decProduct(product);
                              }
                            : null, //desebilita caso for menor que 1
                        icon: Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(product.quantity.toString()),
                      IconButton(
                        onPressed: () {
                          CartModel.of(context).incProduct(product);
                        },
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                      ),
                      TextButton(
                        onPressed: () {
                          //remove todos
                          CartModel.of(context).removeCartItem(product);
                        },
                        child: Text(
                          "Remover",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: product.productData == null
          ? FutureBuilder<DocumentSnapshot>(
              //caso ainda não tenha os dados, recarrega os itens
              future: FirebaseFirestore.instance
                  .collection("products_online_store")
                  .doc(product.category)
                  .collection("itens")
                  .doc(product.pid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //salva os dados para mostrar depois
                  product.productData = ProductData.fromDocument(
                    snapshot.data!,
                  );
                  return buildContent(); //mostra os itens
                } else {
                  return Container(
                    height: 70.0,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                }
              },
              //caso já tenha os dados, mostra os itens
            )
          : buildContent(),
    );
  }
}
