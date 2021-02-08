import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:onestep/moor/moor_database.dart';

class FavoriteProvider with ChangeNotifier {
  final _favoritesSnapshot = <DocumentSnapshot>[];
  final _productsSnapshot = <DocumentSnapshot>[];
  int documentLimit = 9;
  String _errorMessage = '';
  bool _hasNext = true;
  bool _isFetchingUsers = false;

  String get errorMessage => _errorMessage;
  bool get hasNext => _hasNext;

  List<DocumentSnapshot> get favoriteproducts => _productsSnapshot;
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

  Future fetchProducts() async {
    if (_isFetchingUsers) return;
    _isFetchingUsers = true;
    _favoritesSnapshot.clear();
    _productsSnapshot.clear();
    try {
      final fsnap = await FirebaseApi.getUsersFavorite(documentLimit);

      fsnap.docs.forEach((querysnapshot) async {
        var snap = await FirebaseApi.getFavoriteProducts(
          querysnapshot.data()['productid'],
          startAfter: null,
        );
        _productsSnapshot.add(snap);
        notifyListeners();
      });

      if (fsnap.docs.length < documentLimit) _hasNext = false;
    } catch (error) {
      notifyListeners();
    }
    _isFetchingUsers = false;
  }
}
