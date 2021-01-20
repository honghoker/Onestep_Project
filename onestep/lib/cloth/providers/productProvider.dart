import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:onestep/moor/moor_database.dart';

class ProuductProvider with ChangeNotifier {
  final _productsSnapshot = <DocumentSnapshot>[];
  String _errorMessage = '';
  int documentLimit = 9;
  bool _hasNext = true;
  bool _isFetchingUsers = false;

  String get errorMessage => _errorMessage;
  bool get hasNext => _hasNext;

  List<Product> get products => _productsSnapshot.map((snap) {
        final product = snap.data();

        return Product(
          firestoreid: snap.id,
          uid: product['uid'],
          title: product['title'],
          category: product['category'],
          price: product['price'],
          hide: product['hide'] ? 1 : 0,
          deleted: product['deleted'] ? 1 : 0,
          images: jsonEncode(product['images']),
        );
      }).toList();

  Future fetchNextProducts(String category) async {
    if (_isFetchingUsers) return;
    _isFetchingUsers = true;

    try {
      final snap = await FirebaseApi.getProducts(
        documentLimit,
        category,
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

  Future fetchProducts(String category) async {
    if (_isFetchingUsers) return;
    _isFetchingUsers = true;
    _productsSnapshot.clear();
    try {
      final snap = await FirebaseApi.getProducts(
        documentLimit,
        category,
        startAfter: null,
      );
      _productsSnapshot.addAll(snap.docs);
      if (snap.docs.length < documentLimit) _hasNext = false;
      notifyListeners();
    } catch (error) {
      notifyListeners();
    }
    _isFetchingUsers = false;
  }

  Future searchProducts(String search) async {
    if (_isFetchingUsers) return;
    _isFetchingUsers = true;
    _productsSnapshot.clear();
    try {
      final snap = await FirebaseApi.getSearchProducts(
        documentLimit,
        search,
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
