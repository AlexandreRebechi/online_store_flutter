import 'package:flutter/material.dart';
import 'package:online_store/tabs/home_tab.dart';
import 'package:online_store/tabs/products_tab.dart';
import 'package:online_store/widgets/custom_drawer.dart';



class HomeScreen extends StatelessWidget {
 HomeScreen({super.key});

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
       Scaffold(
         body: HomeTab(),
         drawer: CustomDrawer(pageController: _pageController),
       ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos", style: TextStyle(color: Colors.white),),
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: IconThemeData(color: Colors.white),
            centerTitle: true,
          ),
          drawer: CustomDrawer(pageController: _pageController),
          body: ProductsTab(),
        ),
        Container(color: Colors.yellow,),
        Container(color: Colors.green,),


      ],
    );
  }
}
