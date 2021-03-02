import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseApi {
  static String getId() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    // print(_auth.currentUser.uid + "uid 출력");
    return _auth.currentUser.uid;
  }

  // getUniId 쓰는법
  // onPressed: () async{
  //   String test;
  //   await FirebaseApi.getUniId().then((value) => test = value);
  //   print("$test");
  // },
  static Future<String> getUniId() async {
    DocumentSnapshot dsUser = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseApi.getId())
        .get();
    String userUni = dsUser.data()['userUniversity'];
    DocumentSnapshot dsUni = await FirebaseFirestore.instance
        .collection('university')
        .doc(userUni)
        .get();
    // print("${dsUni.data()['uni_name']}");
    return dsUni.data()['uni_name'];
  }

  // static String getUniId() {
  //   String result;
  //   String userUni;
  //   Future<DocumentSnapshot> dsUser = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseApi.getId())
  //       .get();
  //   dsUser.then((value) async => userUni = await value.data()['userUniversity']
  //       // print("sex sibal ${value.data()['userUniversity']}")
  //       );

  //   print("userUni@ = $userUni");
  //   Future<DocumentSnapshot> dsUni =
  //       FirebaseFirestore.instance.collection('university').doc(userUni).get();
  //   dsUni.then((value) async => result = await value.data()['uni_name']);
  //   print("result = $result");
  //   // print("${dsUni.data()['uni_name']}");
  //   return result;
  // }

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
          .where("deleted", isEqualTo: false)
          .where("hide", isEqualTo: false)
          .orderBy("bumptime", descending: true)
          .limit(limit);
    } else {
      refProducts = FirebaseFirestore.instance
          .collection('products')
          .where("category", isEqualTo: category)
          .where("deleted", isEqualTo: false)
          .where("hide", isEqualTo: false)
          .orderBy("bumptime", descending: true)
          .limit(limit);
    }

    if (startAfter == null) {
      return refProducts.get();
    } else {
      return refProducts.startAfterDocument(startAfter).get();
    }
  }

  static Future<QuerySnapshot> getMyProducts(
    // 내 상품 불러오기
    int limit,
    String category, {
    DocumentSnapshot startAfter,
  }) async {
    var refProducts;

    if (category == "전체") {
      refProducts = FirebaseFirestore.instance
          .collection('products')
          .where("uid", isEqualTo: getId())
          .where("deleted", isEqualTo: false)
          .where("hide", isEqualTo: false)
          .orderBy("bumptime", descending: true)
          .limit(limit);
    } else {
      refProducts = FirebaseFirestore.instance
          .collection('products')
          .where("uid", isEqualTo: getId())
          .where("category", isEqualTo: category)
          .where("deleted", isEqualTo: false)
          .where("hide", isEqualTo: false)
          .orderBy("bumptime", descending: true)
          .limit(limit);
    }

    if (startAfter == null) {
      return refProducts.get();
    } else {
      return refProducts.startAfterDocument(startAfter).get();
    }
  }

  static Future<QuerySnapshot> getUserProducts(
    // 사용자 판매 상품 불러오기
    int limit,
    String uid, {
    DocumentSnapshot startAfter,
  }) async {
    var refProducts;

    refProducts = FirebaseFirestore.instance
        .collection('products')
        .where("uid", isEqualTo: uid)
        .where("deleted", isEqualTo: false)
        .where("hide", isEqualTo: false)
        .orderBy("bumptime", descending: true)
        .limit(limit);

    if (startAfter == null) {
      return refProducts.get();
    } else {
      return refProducts.startAfterDocument(startAfter).get();
    }
  }

  static Future<QuerySnapshot> getSearchProducts(
    // 장터 상품 검색

    int limit,
    String search, {
    DocumentSnapshot startAfter,
  }) async {
    var refProducts;
    refProducts = FirebaseFirestore.instance
        .collection('products')
        .where("deleted", isEqualTo: false)
        .where("hide", isEqualTo: false)
        .orderBy('title')
        .startAt([search]).endAt([search + '\uf8ff']).limit(limit);

    if (startAfter == null) {
      return refProducts.get();
    } else {
      return refProducts.startAfterDocument(startAfter).get();
    }
  }

  static Future<QuerySnapshot> getBoard(
    // Get Board List
    int limit,
    String boardName, {
    DocumentSnapshot startAfter,
  }) async {
    var refProducts;

    refProducts = FirebaseFirestore.instance
        .collection('Board')
        .doc(boardName)
        .collection(boardName)
        // .where("hide", isEqualTo: false)
        .orderBy("createDate", descending: true)
        .limit(limit);

    if (startAfter == null) {
      return refProducts.get();
    } else {
      return refProducts.startAfterDocument(startAfter).get();
    }
  }

  static Future<QuerySnapshot> getBoardCategory(
      // Get Board Category List
      ) async {
    return FirebaseFirestore.instance.collection('Board').get();
  }
}
