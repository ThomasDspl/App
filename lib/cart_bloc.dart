import 'dart:collection';

import 'package:flutter/material.dart';
import 'main.dart';

class CartBloc with ChangeNotifier {
  List<Recette> _cart = [];

  UnmodifiableListView<Recette> get cart => UnmodifiableListView(_cart);

  void addToCart(recette) {
    if (!_cart.contains(recette)) {
      _cart.add(recette);
      notifyListeners();
    }
  }

  void clear(recette) {
    if (_cart.contains(recette)) {
      _cart.remove(recette);
      notifyListeners();
    }
  }

  void clearAll() {
    _cart.clear();
    notifyListeners();
  }

  int totalPrice() {
    int total = 0;
    _cart.forEach((element) {
      total += element.prix;
    });
    return total;
  }
}
