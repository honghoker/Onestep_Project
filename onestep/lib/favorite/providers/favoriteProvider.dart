import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep/api/favorite_api.dart';
import 'package:onestep/cloth/models/product.dart';

class FavoriteProvider with ChangeNotifier {
  final _favoritesSnapshot = <DocumentSnapshot>[];
  final _productsSnapshot = <DocumentSnapshot>[];
  int documentLimit = 12;
  String _errorMessage = '';
  bool _hasNext = true;
  bool _isFetchingUsers = false;

  String get errorMessage => _errorMessage;
  bool get hasNext => _hasNext;
  bool get isFetching => _isFetchingUsers;

  List<DocumentSnapshot> get favoriteproducts => _productsSnapshot;
  List<Product> get products => _productsSnapshot.map((snap) {
        final product = snap.data();

        return Product(
          firestoreid: snap.id,
          uid: product['uid'],
          title: product['title'],
          category: product['category'],
          price: product['price'],
          hide: product['hide'],
          deleted: product['deleted'],
          images: product['images'],
        );
      }).toList();

  Future fetchProducts() async {
    if (_isFetchingUsers) return;
    _isFetchingUsers = true;
    _hasNext = true;
    _favoritesSnapshot.clear();
    _productsSnapshot.clear();
    try {
      await FavoriteApi.getUsersFavorite(documentLimit, startAfter: null)
          .then((value) async {
        if (value.docs.length < documentLimit) _hasNext = false;
        _favoritesSnapshot.addAll(value.docs);
        await Future.forEach(value.docs, (querysnapshot) async {
          var snap = await FavoriteApi.getFavoriteProducts(
            querysnapshot.data()['productid'],
          );
          _productsSnapshot.add(snap);
        });
      }).then(
        (value) {
          notifyListeners();
        },
      );
    } catch (error) {
      notifyListeners();
    }
    _isFetchingUsers = false;
  }

  Future fetchNextProducts() async {
    if (_isFetchingUsers || !_hasNext) return;
    _isFetchingUsers = true;
    try {
      await FavoriteApi.getUsersFavorite(documentLimit,
              startAfter: _favoritesSnapshot.isNotEmpty
                  ? _favoritesSnapshot.last
                  : null)
          .then((value) async {
        if (value.docs.length < documentLimit) _hasNext = false;
        await Future.forEach(value.docs, (querysnapshot) async {
          var snap = await FavoriteApi.getFavoriteProducts(
            querysnapshot.data()['productid'],
          );
          _productsSnapshot.add(snap);
        });
      }).then(
        (value) => notifyListeners(),
      );
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }

    _isFetchingUsers = false;
  }
}
