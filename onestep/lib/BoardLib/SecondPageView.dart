import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Practice extends StatefulWidget {
  _Temp createState() => _Temp();
}

class _Temp extends State<Practice> {
  // BuildContext context;
  // GeneralBoard(BuildContext context);
  // GeneralBoard({@required this.context}) : assert(context != null);
  final db = FirebaseFirestore.instance
      .collection('Board')
      .doc('Board_Free')
      .collection('Board_Free_BoardId')
      .doc;

  @override
  Widget build(BuildContext context) {
    print(db);
    return Center(child: Container(child: Text('')));
  }
}
