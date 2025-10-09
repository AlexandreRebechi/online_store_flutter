import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_store/models/cart_model.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      //tile que pode clicar e ela irá expandir
      child: ExpansionTile(
        title: Text(
          "Cupom de Desconto",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu cupom",
              ),
              //inicia com um cupom já colocado, senão coloca vazio
              initialValue: CartModel.of(context).couponCode ?? "",
              //ao submeter o cupom, busca no firestore o doc correspondente
              onFieldSubmitted: (text) {
                FirebaseFirestore.instance
                    .collection("coupons_online_store")
                    .doc(text)
                    .get()
                    .then((docSnap) {
                      if (docSnap.data() != null) {
                        //se existe no banco de dados
                        CartModel.of(
                          context,
                        ).setCoupon(text, docSnap.get('percent'));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Desconto de ${docSnap.get('percent')}% aplicado!",
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Cupom não existente!"),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
