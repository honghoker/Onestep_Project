import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:onestep/cloth/models/favorite.dart';

class Test extends StatefulWidget {
  Test({Key key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  List<String> favorites = [];

  Stream<List<Favorite>> gettest() {
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseApi.getId())
        .collection("favorites")
        .snapshots();

    return stream.map(
      (qShot) => qShot.docs
          .map((doc) => Favorite(
                productId: doc.data()['productid'],
              ))
          .toList(),
    );
  }

  Future<Widget> getuser() async {
    List<String> result = [];

    await for (List<Favorite> fa in gettest()) {
      fa.map((e) => print(e));
    }

    // return StreamBuilder<QuerySnapshot>(
    //   stream: FirebaseFirestore.instance
    //       .collection("users")
    //       .doc(FirebaseApi.getId())
    //       .collection("favorites")
    //       .snapshots(),
    //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.waiting:
    //         return Container();
    //       default:
    //         print("@@@ ${snapshot.data.docs}");
    //         snapshot.data.docs.forEach((DocumentSnapshot document) {
    //           result.add(document['productid']);
    //         });

    //         print(result);

    //         return Container();
    //     }
    //   },
    // );
  }

  Widget back() {
    getuser();
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ㅇㅅㅇㅅㅇ"),
      ),
      body: back(),
    );
  }
}
