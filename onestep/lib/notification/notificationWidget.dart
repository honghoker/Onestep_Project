import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'document_view.dart';

class NotificationWidget extends StatefulWidget {
  NotificationWidget({Key key}) : super(key: key);

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  final _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildList(),
      backgroundColor: Colors.yellow[50],
    );
  }

  Widget _buildList() {
    return StreamBuilder(
      stream:
          _firestore.collection('chattingroom').where('send_user').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Text('Loading from chat_main..2.');
        }
// ignore: deprecated_member_use
        List<DocumentSnapshot> documents = snapshot.data.documents;
        return ListView(
          padding: EdgeInsets.only(top: 0.0),
          children: documents
              .map((eachDocument) => DocumentView(eachDocument, '김명수'))
              .toList(),
        );
      },
    );
  }
}
