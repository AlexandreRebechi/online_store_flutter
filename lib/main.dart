import 'package:flutter/material.dart';
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
        if(asyncSnapshot.hasError){
          return Container();
        }
        if(asyncSnapshot.connectionState == ConnectionState.done){
          return ScopedModel<UserModel>(
            model: UserModel(),
            child: MaterialApp(
              title: "Flutter's Clothing",
              theme: ThemeData(
                iconTheme: IconThemeData(color: Colors.white),
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue,
                    primary: Color.fromARGB(255, 4, 125, 141),
            
                ),
              ),
              debugShowCheckedModeBanner: false,
              home: HomeScreen()
            
            ),
          );
        }
        return Container();
      }
    );
  }
}

