import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onestep/cloth/category.dart';

class DatabaseProvider {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Category>> getCategory() {
    return _db.collection("category").snapshots().map(
        (list) => list.docs.map((doc) => Category.fromFireStore(doc)).toList());
  }
}
