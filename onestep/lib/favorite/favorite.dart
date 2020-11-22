import 'package:flutter/material.dart';

class Favorite with ChangeNotifier {
  String _firestoreid;

  //Favorite(this._firestoreid);

  getFirestoreid() => _firestoreid;
  setFirestoreid(String firestoreid) => _firestoreid = firestoreid;

  void insertOrdelete() {
    notifyListeners();
  }
}
