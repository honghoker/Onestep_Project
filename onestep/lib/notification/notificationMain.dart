import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:onestep/notification/Controllers/firebaseChatController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'inChattingRoom.dart';
import 'time/chat_time.dart';

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
        appBar: AppBar(
          title: Text('채팅&알림'),
          actions: [
            _buildExpandedTitle(),
            _buildChattingRoom(context),
          ],
        ),
        body: _buildList(),
        backgroundColor: Colors.white);
  }

  Widget _buildList() {
    // return FutureBuilder(
    //     future: FirebaseApi.getId(),
    //     builder: (BuildContext ctx, AsyncSnapshot<String> snapshot1) {
    //       if (snapshot1.hasData) {
    //         print("@@@ snapshotdata = ${snapshot1.data}");
    //         Stream userChatListStream = FirebaseFirestore.instance
    //             .collection('user_chatlist')
    //             .doc(snapshot1.data)
    //             .snapshots();
    // );

    // Stream userChatListStream = FirebaseFirestore.instance
    //     .collection('user_chatlist')
    //     .doc(FirebaseApi.getId())
    //     .snapshots();
    var test22 = 1;
    Stream userChatListStream1 = FirebaseFirestore.instance
        .collection('chattingroom')
//        .where("read_count", isEqualTo: 2)
        .where("cusers", arrayContains: "EeSxjIzFDGWuxmEItV7JheMDZ6C2")
//        .orderBy('timestamp', descending: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: userChatListStream1,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            Text('Loading from chat_main...');
            return Container(
              child: Center(
                child: CircularProgressIndicator(), //유저 없어서 로딩
              ),
              color: Colors.white.withOpacity(0.7),
            );
          } else {
            return (1 > 0) //유저 수가 더 크면
                ? ListView(
                    children: snapshot.data.docs.map((chatroomData) {
                    //return ListTile();
                    return Text("$test22 dd 포함된 채팅방 id : " +
                        chatroomData.id +
                        "     " +
                        chatroomData["cusers"][0] +
                        "     " +
                        chatroomData["cusers"][1]);
                  }).toList())
                : Text("뭐씨");
          }

          return Container();
        });
    //   } else {
    //     return Container();
    //   }
    // });
  }

  Widget _buildExpandedTitle() {
    return Expanded(
      child: Center(
          child: Text(
        '알림메인 텍스트 채팅구조 변경',
        textScaleFactor: 1.5,
      )),
    );
  }

  Widget _buildChattingRoom(var context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.chat_bubble),
            onPressed: () {
              FirebaseChatController().saveArrayContain();
              //_onClickNotification;
              print(Text('빌트스택 우측'));
              //FirebaseChatController().whereTest();
              //FirebaseChatController().createChatingRoomToFirebaseStorage2();

              //FirebaseChatController().logoutUser(context);

              // Firestore.instance
              //     .collection('chattinglist')
              //     .getDocuments()
              //     .then((snapshot) {
              //   for (DocumentSnapshot ds in snapshot.docs) {
              //     ds.reference.delete();
              //   }
              // });

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
