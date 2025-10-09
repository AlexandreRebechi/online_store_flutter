import 'package:flutter/material.dart';
import 'package:online_store/models/cart_model.dart';
import 'package:online_store/models/user_model.dart';
import 'package:online_store/screens/login_screen.dart';
import 'package:online_store/screens/order_screen.dart';
import 'package:online_store/tiles/cart_tile.dart';
import 'package:online_store/widgets/cart_price.dart';
import 'package:online_store/widgets/discount_card.dart';
import 'package:online_store/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Meu Carrinho",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 8.0),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                int p =
                    model.products.length; //quantidade de produtos no carrinho
                return Text(
                  "${p == 1 ? "ITEM" : "ITEMS"}",
                  style: const TextStyle(fontSize: 17.0, color: Colors.white),
                );
              },
            ),
          ),
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          if (model.isLoading && UserModel.of(context).isLoggedIn()) {
            return const Center(child: CircularProgressIndicator());
            //se não estiver logado
          } else if (!UserModel.of(context).isLoggedIn()) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 80.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    "Faça o login para adicionar produtos!",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
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
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
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
            //se a lista de produtos for vazia
          } else if (model.products.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum produto no carinho!",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView(
              children: <Widget>[
                Column(
                  //column para colocar os filhos via código
                  //mapeando os produtos da lista
                  children: model.products.map((product) {
                    return CartTile(product: product);
                  }).toList(),
                ),
                const DiscountCard(),
                const ShipCard(),
                CartPrice(
                  buy: () async {
                    String? orderId = await model.finishOrder();
                    if (orderId != null) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => OrderScreen(orderId: orderId),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
