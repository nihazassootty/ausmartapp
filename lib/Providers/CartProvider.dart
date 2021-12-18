import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List cart = [];
  Map store = {};

  //Add Product to cart
  addItem({item, storeDetail}) {
    //* SET STORE NAME
    if (store.isEmpty) {
      store = storeDetail;
    }

    //* CHECK IF CART HAS PRODUCT
    var product = cart.firstWhere((product) => product["_id"] == item["_id"],
        orElse: () => null);
    if (product == null)
      cart.add(item);
    else
      product["qty"] = item["qty"];

    notifyListeners();
  }

  //Remove Product from cart
  deleteItem(item) {
    //* UNSET STORE NAME
    if (cart.length == 1) {
      store = {};
    }
    cart.removeWhere((product) => product["_id"] == item.id);
    notifyListeners();
  }

  deleteItemCart(item) {
    //* UNSET STORE NAME
    if (cart.length == 1) {
      store = {};
    }
    cart.removeWhere((product) => product["_id"] == item["_id"]);
    notifyListeners();
  }

  //Clear cart
  clearItem([BuildContext context]) {
    //* UNSET STORE NAME
    cart = [];
    store = {};
    notifyListeners();
  }
}
