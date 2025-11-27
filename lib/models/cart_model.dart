import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_store/datas/cart_product.dart';
import 'package:online_store/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

//para acessar os dados de todo o app, usa o ScopedModel<nomedomodel> no main
class CartModel extends Model {
  UserModel user; //usuário atual
 
  List<CartProduct> products = [];

  String? couponCode;
  int discountPercentage = 0;

  bool isLoading = false;

  //outra forma para ter acesso ao CartModel de qualquer lugar do App: usar CartModel.of(context).
  //que vai buscar um objeto do tipo CartModel na árvore
  CartModel({required this.user}) {
    if (user.isLoggedIn()) {
      //se estiver logado
      //carrega os itens do firebase no carrinho
      _loadCartItems();
    }
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct); //adiconando produtos ao carrinho

    FirebaseFirestore.instance
        .collection("users_online_store")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .add(cartProduct.toMap())
        .then((doc) {
          //pegando o id do cart
          cartProduct.cid = doc.id;
        });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    try {
      //tirando produtos do carrinho
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
    //decrementa a quantidade
    cartProduct.quantity = cartProduct.quantity! - 1;
    //atualiza o firebase
    FirebaseFirestore.instance
        .collection("users_online_store")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    //atualiza o firebase
    cartProduct.quantity = cartProduct.quantity! + 1;
    //atualiza o firebase
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
    //calcula o frete
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

  Future<String?> finishOrder() async {
    if (products.isEmpty) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    //adicionando o pedido na coleção orders e obtendo uma referêcia para este pedido para salvar ele no usuário depois
    DocumentReference refOrder = await FirebaseFirestore.instance
        .collection('orders_online_store')
        .add({
          'clientId': user.firebaseUser!.uid,
          //trasforma uma lista de CartProducts em uma lista de mapas
          'products': products
              .map((cartProduct) => cartProduct.toMap())
              .toList(),
          'shipPrice': shipPrice,
          'productsPrice': productsPrice,
          'discount': discount,
          'totalPrice': (productsPrice - discount + shipPrice),
          "status": 1, //status do pedido (1) -> preparando, (2) -> enviando, ... etc
        });

    //salvando referência do pedido no usuário
    await FirebaseFirestore.instance
        .collection("users_online_store")
        .doc(user.firebaseUser!.uid)
        .collection("orders")
        .doc(refOrder.id)
        .set({"orderId": refOrder.id});

    //pegando todos os itens do carrinho
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users_online_store")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .get();
    //pegando uma referência para cada um dos produtos do carrinho e deletando
    for (DocumentSnapshot doc in query.docs) {
      doc.reference.delete();
    }

    products.clear(); //limpando lista local

    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.id;
  }

  void _loadCartItems() async {
    //carregando todos os documentos(itens) do carrinho
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users_online_store")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .get();
    //transforma cada documento retornado do firebae em um CartProduct
    products = querySnapshot.docs
        .map((doc) => CartProduct.fromDocument(doc))
        .toList();

    notifyListeners();
  }
}
