import 'package:flutter/material.dart';

class Category with ChangeNotifier {
  String selectItem;

  Category({
    this.selectItem = "전체",
  });

  void changeSelectItem(String value) {
    selectItem = value;
    notifyListeners();
  }
}
