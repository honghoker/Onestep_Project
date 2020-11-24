import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget GetTime(DocumentSnapshot document) {
  //print('GetTime 출력');
  return Text(
    DateFormat("yy.MM.dd kk:mm:aa").format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(document["timestamp"]))),
    style: TextStyle(
        color: Colors.grey, fontSize: 12.0, fontStyle: FontStyle.italic),
  );
}
