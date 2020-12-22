import 'dart:collection';

import 'package:flutter/material.dart';
import 'main.dart';

class RecetteDataBloc with ChangeNotifier {
  List<Recette> _list = getData();
  UnmodifiableListView<Recette> get list => UnmodifiableListView(_list);

  void addToList(recette) {
    if (!_list.contains(recette)) {
      _list.add(recette);
    }
    notifyListeners();
  }

  void changeStateRecette(Recette recette, bool state) {
    if (_list.contains(recette)) {
      var r = _list
          .map((element) => {(element == recette) ? element : null})
          .single;
      r.first.state = state;
      notifyListeners();
    }
  }

  Recette getRecette(Recette recette) {
    if (_list.contains(recette)) {
      var index = _list.indexOf(recette);
      return _list[index];
    }
    return null;
  }

  void addList(List<Recette> list) {
    _list = list;
    notifyListeners();
  }

  void clear(recette) {
    if (_list.contains(recette)) {
      _list.remove(recette);
      notifyListeners();
    }
  }

  void clearAll() {
    _list.clear();
    notifyListeners();
  }
}
