import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'document_view.dart';

class NotificationMain extends StatefulWidget {
  NotificationMain({Key key}) : super(key: key);

  @override
  _NotificationMainState createState() => _NotificationMainState();
}

class _NotificationMainState extends State<NotificationMain> {
  SharedPreferences preferences;

  _NotificationMainState({Key key});

  final _firestore = FirebaseFirestore.instance;

  @override
  build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('채팅방 목록'),
        //   actions: <Widget>[
        //     //_bulidIconButton(),
        //     _buildExpandedTitle(),
        //     _buildChattingRoom(),
        //   ],
        // ),
        body: _buildList(),
        backgroundColor: Colors.purple[50]);
  }

  Widget _buildList() {
    return StreamBuilder(
      stream: _firestore.collection('chattingroom').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Text('Loading from chat_main...');
        }
        List<DocumentSnapshot> documents = snapshot.data.docs;
        return ListView(
          padding: EdgeInsets.only(top: 0.0),
          children: documents
              .map((eachDocument) => DocumentView(eachDocument))
              .toList(),
        );
      },
    );
  }

  Widget _buildExpandedTitle() {
    return Expanded(
      child: Center(
          child: Text(
        '알림메인 텍스트',
        textScaleFactor: 1.5,
      )),
    );
  }

  Widget _buildChattingRoom() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.mail_outline),
            onPressed: () {
              //_onClickNotification;
              print(Text('빌트스택 우측'));

              Firestore.instance
                  .collection('chattinglist')
                  .getDocuments()
                  .then((snapshot) {
                for (DocumentSnapshot ds in snapshot.docs) {
                  ds.reference.delete();
                }
              });

              //createRecord();
            }),
        Positioned(
          top: 12.0,
          right: 10.0,
          width: 10.0,
          height: 10.0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              //color: AppColors.notification,
            ),
          ),
        )
      ],
    );
  }

  Future<String> getUserId() async {
    preferences = await SharedPreferences.getInstance();
    return preferences.getString('id');
  }

  DocumentReference getUserDoc() {
    //DocumentReference doc_ref = _firestore.collection('user_chatlist').doc("dd").get().then((value) => null)
  }

  Stream<DocumentSnapshot> getChatList(String id) {
    return _firestore.collection('user_chatlist').doc("user_uid").snapshots();
  }

  Stream<QuerySnapshot> getChatList2(String id) {
    return _firestore.collection('chattingroom').where('send_user').snapshots();
  }

  void createRecord() async {
    await _firestore
        .collection("books")
        // ignore: deprecated_member_use
        .document("1")
        // ignore: deprecated_member_use
        .setData({
      'title': 'Mastering Flutter',
      'description': 'Programming Guide for Dart'
    });

    DocumentReference ref = await _firestore.collection("books").add({
      'title': 'Flutter in Action',
      'description': 'Complete Programming Guide to learn Flutter'
    });
    // ignore: deprecated_member_use
    print(ref.documentID);
  }
}
