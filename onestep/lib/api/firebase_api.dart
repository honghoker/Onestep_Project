import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseApi {
  static Future<QuerySnapshot> getProducts(
    int limit,
    String category, {
    DocumentSnapshot startAfter,
  }) async {
    var refProducts;
    if (category == "전체") {
      refProducts = FirebaseFirestore.instance
          .collection('products')
          .orderBy("uploadtime", descending: true)
          .limit(limit);
    } else {
      refProducts = FirebaseFirestore.instance
          .collection('products')
          .where("category", isEqualTo: category)
          .orderBy("uploadtime", descending: true)
          .limit(limit);
    }

    if (startAfter == null) {
      return refProducts.get();
    } else {
      return refProducts.startAfterDocument(startAfter).get();
    }
  }
}
