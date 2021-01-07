import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseApi {
  static Future<QuerySnapshot> getProducts(
    int limit, {
    DocumentSnapshot startAfter,
  }) async {
    final refProducts = FirebaseFirestore.instance
        .collection('products')
        .orderBy("uploadtime", descending: true)
        .limit(limit);

    if (startAfter == null) {
      return refProducts.get();
    } else {
      return refProducts.startAfterDocument(startAfter).get();
    }
  }
}
