import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

// Model armazena o estado
class UserModel extends Model {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth? firebaseAuth;
  User? firebaseUser;
  Map<String, dynamic>? userData = {};

  // procesando o login
  bool isLoading = false;

  // login
  void signUp ({
    required Map<String, dynamic> userData,
    required String pass,
    required VoidCallback onSuccess,
    required VoidCallback onFail,
  }) async{
    isLoading = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(
          email: userData['email'],
          password: pass,
        )
        .then((user){
          firebaseUser = user.user;

          _savaUserData(userData, user);

          onSuccess();
          isLoading = false;
        })
        .catchError((e) {
          onFail();
          isLoading = false;
          notifyListeners();
        });
  }

  // signup
  void signIn() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 3));

    isLoading = false;
    notifyListeners();
  }

  // recuperar senha
  void recoverPass() {}

  //está logado
  bool isLoggedIn() {
    return true;
  }
  Future _savaUserData(Map<String, dynamic> userData, UserCredential user) async {
    this.userData = userData;
    FirebaseFirestore.instance.collection("users_online_store").doc().set(userData);
  }

}
