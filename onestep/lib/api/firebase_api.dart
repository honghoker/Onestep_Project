import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseApi {
  static Future<String> getId() async {
    // google getuid
    SharedPreferences pre = await SharedPreferences.getInstance();
    return pre.getString('id');
  }

  static Future<QuerySnapshot> getProducts(
    // 장터 상품 불러오기
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
