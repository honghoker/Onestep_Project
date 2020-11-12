import 'package:flutter/material.dart';

class Product {
  final String title;
  final String firestoreid;
  final String category;
  final String price;
  final String explain;
  final int views;
  final DateTime uploadtime;
  final String images;

  Product({
    @required this.title,
    @required this.firestoreid,
    @required this.category,
    @required this.price,
    @required this.explain,
    @required this.views,
    @required this.uploadtime,
    @required this.images,
  });
}
