import 'package:flutter/material.dart';
import 'package:onestep/moor/moor_database.dart';

class ProductTest extends ChangeNotifier {
  ProductsDao _productsDao;

  ProductTest(ProductsDao productsDao) {
    _productsDao = productsDao;
  }
  ProductsDao get productsDao => _productsDao;

  void insertProduct(value) {
    this._productsDao.insertProduct(value);
    notifyListeners();
  }

  void deleteProduct(value) {
    this._productsDao.deleteProduct(value);
    notifyListeners();
  }
}
