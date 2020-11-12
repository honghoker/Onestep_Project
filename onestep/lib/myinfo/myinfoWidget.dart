import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class MyinfoWidget extends StatefulWidget {
  MyinfoWidget({Key key}) : super(key: key);

  @override
  _MyinfoWidgetState createState() => _MyinfoWidgetState();
}

class _MyinfoWidgetState extends State<MyinfoWidget> {
  Widget test() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> productRef = db
        .collection("chattingroom")
        .doc("F7lLjyw5ffRuLgCgme0W")
        .collection("message")
        .snapshots();

    productRef.forEach((field) {
      field.docs.asMap().forEach((index, data) {
        print(field.docs[index].data());
      });
    });

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: test(),
    );
  }
}
