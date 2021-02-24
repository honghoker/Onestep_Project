import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_api.dart';

class FavoriteApi {
  static Future<QuerySnapshot> getUsersFavorite(
    int limit, {
    DocumentSnapshot startAfter,
  }) async {
    var refProducts;
    refProducts = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseApi.getId())
        .collection("favorites")
        .orderBy('time', descending: true)
        .limit(limit);

    if (startAfter == null) {
      return refProducts.get();
    } else {
      return refProducts.startAfterDocument(startAfter).get();
    }
  }

  static Future<DocumentSnapshot> getFavoriteProducts(String productid) async {
    var refProducts;
    refProducts =
        FirebaseFirestore.instance.collection("products").doc(productid);

    return refProducts.get();
  }

  static void insertFavorite(String docId) {
    var time = DateTime.now().millisecondsSinceEpoch;

    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseApi.getId())
        .collection("favorites")
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      "productid": docId,
      "time": time,
    });

    FirebaseFirestore.instance.collection("products").doc(docId).update({
      "favoriteUserList": FieldValue.arrayUnion([FirebaseApi.getId()]),
    });
  }

  static void deleteFavorite(String usersdocId, String productsdocId) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseApi.getId())
        .collection("favorites")
        .doc(usersdocId)
        .delete();

    FirebaseFirestore.instance
        .collection("products")
        .doc(productsdocId)
        .update({
      "favoriteUserList": FieldValue.arrayRemove([FirebaseApi.getId()]),
    });
  }
}
