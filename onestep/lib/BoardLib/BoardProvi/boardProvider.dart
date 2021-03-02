import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:onestep/api/firebase_api.dart';
import 'boardClass.dart';

class BoardProvider with ChangeNotifier {
  final _productsSnapshot = <DocumentSnapshot>[];
  String _errorMessage = "Board Provider RuntimeError";
  int documentLimit = 15;
  bool _hasNext = true;
  bool _isFetchingUsers = false;

  String get errorMessage => _errorMessage;
  bool get hasNext => _hasNext;

  List<BoardData> get boards => _productsSnapshot.map((snap) {
        return BoardData.fromFireStore(snap);
      }).toList();

  Future fetchNextProducts(String boardName) async {
    if (_isFetchingUsers) return;
    _isFetchingUsers = true;

    try {
      final snap = await FirebaseApi.getBoard(
        documentLimit,
        boardName,
        startAfter:
            _productsSnapshot.isNotEmpty ? _productsSnapshot.last : null,
      );
      _productsSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) _hasNext = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }

    _isFetchingUsers = false;
  }
}

class BoardCateogryProvider with ChangeNotifier {
  final _productsSnapshot = <DocumentSnapshot>[];
  String _errorMessage = "Board Provider RuntimeError";

  bool _hasNext = true;

  String get errorMessage => _errorMessage;
  bool get hasNext => _hasNext;

  List<BoardCateogry> get categorys => _productsSnapshot.map((snap) {
        return BoardCateogry.fromFireStore(snap);
      }).toList();
  Future fetchNextProducts(String boardName) async {
    try {
      final snap = await FirebaseApi.getBoardCategory();
      _productsSnapshot.addAll(snap.docs);

      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
  }
}
