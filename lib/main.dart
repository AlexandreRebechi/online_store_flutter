import 'package:flutter/material.dart';
import 'package:online_store/models/cart_model.dart';
import 'package:online_store/models/user_model.dart';
import 'package:online_store/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasError) {
          return Container();
        }
        if (asyncSnapshot.connectionState == ConnectionState.done) {
          //tudo o que tiver abaixo do ScopedModel, vai ter acesso ao UserModel()
          //e vai ser modificado caso alguma coisa aconteça no UserModel()
          return ScopedModel<UserModel>(
            //para que quando mude o usuário, mude o carrinho também
            model: UserModel(),
            child: ScopedModelDescendant<UserModel>(
              //ScopedModel para acessar o carrinho
              builder: (context, child, model) {
                return ScopedModel<CartModel>(
                  model: CartModel(user: model), //enviando o usuário atual
                  child: MaterialApp(
                    title: "Flutter's Clothing",
                    theme: ThemeData(
                      iconTheme: IconThemeData(color: Colors.white),
                      colorScheme: ColorScheme.fromSeed(
                        seedColor: Colors.blue,
                        primary: Color.fromARGB(255, 4, 125, 141),
                      ),
                    ),
                    debugShowCheckedModeBanner: false,
                    home: HomeScreen(),
                  ),
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
