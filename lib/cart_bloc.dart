import 'package:flutter/material.dart';
import 'main.dart';

class CartBloc with ChangeNotifier {
  Map<Recette, int> _cart = {};

  Map<Recette, int> get cart => _cart;

  void addToCart(recette) {
    if (_cart.containsKey(recette)) {
      _cart[recette] += 1;
    } else {
      _cart[recette] = 1;
    }
    notifyListeners();
  }

  void clear(recette) {
    if (_cart.containsKey(recette)) {
      _cart.remove(recette);
      notifyListeners();
    }
  }

  void clearAll() {
    _cart.clear();
    notifyListeners();
  }
}
