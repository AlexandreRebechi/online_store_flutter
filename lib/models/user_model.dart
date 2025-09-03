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

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();
  } // login

  void signUp({
    required Map<String, dynamic> userData,
    required String pass,
    required VoidCallback onSuccess,
    required VoidCallback onFail,
  }) {
    isLoading = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(
          email: userData['email'],
          password: pass,
        )
        .then((user) async {
          firebaseUser = user.user;

          await _savaUserData(userData);

          onSuccess();
          isLoading = false;
          notifyListeners();
        })
        .catchError((e) {
          onFail();
          isLoading = false;
          notifyListeners();
        });
  }

  // signup
  void signIn({
    required String email,
    required String pass,
    required VoidCallback onSuccess,
    required VoidCallback onFail,
  }) async {
    isLoading = true;
    notifyListeners();

    _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) async {
          firebaseUser = user.user;

          await _loadCurrentUser();

          onSuccess();
          isLoading = false;
          notifyListeners();
        })
        .catchError((e) {
          onFail();
          isLoading = false;
          notifyListeners();
        });
  }

  void signOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  // recuperar senha
  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);

  }

  //está logado
  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future _savaUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    FirebaseFirestore.instance
        .collection("users_online_store")
        .doc(firebaseUser!.uid)
        .set(userData);
  }

  Future _loadCurrentUser() async {
    firebaseUser ??= _auth.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot<Map<String, dynamic>> docUser = await FirebaseFirestore
          .instance
          .collection("users_online_store")
          .doc(firebaseUser!.uid)
          .get();
      userData = docUser.data.call();
    }
    notifyListeners();
  }
}
