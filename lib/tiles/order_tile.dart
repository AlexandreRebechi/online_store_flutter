import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({super.key, required this.orderId});

  final String? orderId;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        //streamBuilder fica sempre observando o banco de dados
        //para que quando algo altere, reconstrua em tempo real
        child: StreamBuilder<DocumentSnapshot>(
          //coloca .snapshots() (e não .get()) pois quer atualização em tempo real
          stream: FirebaseFirestore.instance
              .collection("orders_online_store")
              .doc(orderId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              int status = snapshot.data!["status"];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Codigo do pedido: ${snapshot.data!.id}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0),
                  Text(_buildProductsText(snapshot.data!)),
                  SizedBox(height: 4.0),
                  Text(
                    "Status do Pedido: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildCircle("1", "Preparação", status, 1),
                      _line(),
                      _buildCircle("2", "Transporte", status, 2),
                      _line(),
                      _buildCircle("3", "Entrega", status, 3),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  String _buildProductsText(DocumentSnapshot snapshot) {
    String text = "Descrição:\n";
    //a lista de produtos no orders no firebase é um LinkedHashMap
    for (LinkedHashMap p in snapshot.get("products")) {
      //para cada um dos produtos, junta na string
      text +=
          "${p["quantity"]} x ${p["product"]["title"]} (R\$ ${p["product"]["price"].toStringAsFixed(2)})\n";
    }
    text += "Total: R\$ ${snapshot.get("totalPrice").toStringAsFixed(2)}";

    return text;
  }

  //linha entre as bolinhas
  Widget _line() {
    return Container(height: 1, width: 40, color: Colors.grey[500]);
  }

  //bolinha do progresso do pedido
  Widget _buildCircle(
    String title,
    String subtitle,
    int status,
    int thisStatus,
  ) {
    Color? backColor;
    Widget child;

    if (status < thisStatus) {
      backColor = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white));
    } else if (status == thisStatus) {
      backColor = Colors.blue;
      child = Stack(
        //stack para colocar o o texto e o circulo girando um em cima do outro
        alignment: Alignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white)),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(Icons.check, color: Colors.white);
    }

    return Column(
      children: <Widget>[
        CircleAvatar(radius: 20.0, backgroundColor: backColor, child: child),
        Text(subtitle),
      ],
    );
  }
}
