import 'package:flutter/material.dart';
import 'package:online_store/tabs/home_tab.dart';
import 'package:online_store/tabs/orders_tab.dart';
import 'package:online_store/tabs/places_tab.dart';
import 'package:online_store/tabs/products_tab.dart';
import 'package:online_store/widgets/cart_button.dart';
import 'package:online_store/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    //várias páginas
    return PageView(
      //com esse physics não dá para rolar entre as telas arrastando pro lado
      //pode controlar somente pelo código
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: const HomeTab(),
          drawer: CustomDrawer(pageController: _pageController),
          floatingActionButton: const CartButton(), //botão do carrinho
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text(
              "Produtos",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: IconThemeData(color: Colors.white),
            centerTitle: true,
          ),
          drawer: CustomDrawer(pageController: _pageController),
          body: const ProductsTab(),
          floatingActionButton: const CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Lojas", style: TextStyle(color: Colors.white)),
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: IconThemeData(color: Colors.white),
            centerTitle: true,
          ),
          body: PlacesTab(),
          drawer: CustomDrawer(pageController: _pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text(
              "Meus Pedidos",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: IconThemeData(color: Colors.white),
            centerTitle: true,
          ),
          body: const OrdersTab(),
          drawer: CustomDrawer(pageController: _pageController),
        ),
      ],
    );
  }
}
