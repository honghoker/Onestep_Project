import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final name;

  Category({this.name});

  factory Category.fromMap(Map map) {
    return Category(
      name: map['name'] ?? '',
    );
  }

  factory Category.fromFireStore(DocumentSnapshot doc) {
    Map map = doc.data();

    return Category(
      name: map['name'] ?? '',
    );
  }
}
