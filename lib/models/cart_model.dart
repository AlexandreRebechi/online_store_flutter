import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_store/datas/cart_product.dart';
import 'package:online_store/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;

  List<CartProduct> products = [];

  String? couponCode;
  int discountPercentage = 0;

  bool isLoading = false;

  CartModel({required this.user}) {
    if (user.isLoggedIn()) {
      _loadCartItems();
    }
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);

    FirebaseFirestore.instance
        .collection("users_online_store")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .add(cartProduct.toMap())
        .then((doc) {
          cartProduct.cid = doc.id;
        });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    try {
      FirebaseFirestore.instance
          .collection("users_online_store")
          .doc(user.firebaseUser!.uid)
          .collection("cart")
          .doc(cartProduct.cid)
          .delete();

      products.remove(cartProduct);
      notifyListeners();
    } catch (e) {
      print("ERRO removeCartItem: $e");
    }
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity = cartProduct.quantity! - 1;

    FirebaseFirestore.instance
        .collection("users_online_store")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity = cartProduct.quantity! + 1;

    FirebaseFirestore.instance
        .collection("users_online_store")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());

    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void updatePrices() {
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0.0;
    try {
      for (CartProduct c in products) {
        price += c.quantity! * c.productData!.price!.toDouble();
      }
      return price;
    } catch (e) {
      return price;
    }
  }

  double getDiscount() {
    return getProductsPrice() * (discountPercentage / 100);
  }

  double getShipPrice() {
    double? altura = 5.0;
    double? largura = 10.0;
    double? comprimento = 10.0;
    double? pesoReal = 5.0;
    double? pesoCubado = (comprimento * largura * altura) / 6000;
    double? pesoTaxavel = max(pesoReal, pesoCubado);
    double? frete;

    frete = 20 + (pesoTaxavel * 2);

    return frete;
  }

  Future<String?> finishOrder() async{
    if (products.isEmpty) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder = 
        await FirebaseFirestore.instance.collection('orders_online_store').add({
          'clientId': user.firebaseUser!.uid,
          'products': products.map((cartProduct) => cartProduct.toMap()).toList(),
          'shipPrice': shipPrice,
          'productsPrice': productsPrice,
          'discount': discount,
          'total Price': productsPrice - discount - shipPrice,
          "status": 1
        });

   await FirebaseFirestore.instance.collection("users_online_store").doc(user.firebaseUser!.uid)
        .collection("orders").doc(refOrder.id).set({
      "orderId": refOrder.id
    });
   
   QuerySnapshot query = await FirebaseFirestore.instance.collection("users_online_store").doc(user.firebaseUser!.uid)
       .collection("cart").get();

   for(DocumentSnapshot doc in query.docs){
     doc.reference.delete();
   }

   products.clear();

   couponCode = null;
   discountPercentage = 0;

   isLoading = false;
   notifyListeners();

   return refOrder.id;


  }

  void _loadCartItems() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users_online_store")
        .doc(user!.firebaseUser!.uid)
        .collection("cart")
        .get();

    products = querySnapshot.docs
        .map((doc) => CartProduct.fromDocument(doc))
        .toList();

    notifyListeners();
  }
}
