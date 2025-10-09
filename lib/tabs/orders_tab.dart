import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_store/models/user_model.dart';
import 'package:online_store/screens/login_screen.dart';
import 'package:online_store/tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    //se está logado, carega todos os pedidos do usuário
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser!.uid;
      //quando obtem um documetno é um DocumentSnapshot, Quando é mais de um documento é um query snapshot
      return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection("users_online_store")
            .doc(uid)
            .collection("orders")
            .get(), //pegando os pedidos do user
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView(
              children: snapshot.data!.docs
                  .map((doc) => OrderTile(orderId: (doc.id)))
                  .toList()
                  .reversed
                  .toList(), // reversed para que os pedidos mais recentes fiquem em cima
            );
          }
        },
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.view_list,
              size: 80.0,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Faça o login para adicionar produtos!",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(10.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text(
                "Entrar",
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
  }
}
