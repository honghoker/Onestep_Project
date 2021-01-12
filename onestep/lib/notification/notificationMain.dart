import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep/api/firebase_api.dart';
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
    return Scaffold(body: _buildList(), backgroundColor: Colors.purple[100]);
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

    Stream userChatListStream = FirebaseFirestore.instance
        .collection('user_chatlist')
        .doc(FirebaseApi.getId())
        // .doc('EeSxjIzFDGWuxmEItV7JheMDZ6C2')
        .snapshots();

    return StreamBuilder<DocumentSnapshot>(
        stream: userChatListStream,
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Loading from chat_main...');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container();
            default:
              return ListView.builder(
                itemCount: snapshot.data.data().length,
                itemBuilder: (BuildContext ctx, int index) {
                  String chatid = snapshot.data.data().keys.elementAt(index);
                  print("@@@ chatid =  ${chatid}");
                  Stream chattingRoomStream = FirebaseFirestore.instance
                      .collection('chattingroom')
                      .doc(chatid.toString())
                      .snapshots();
                  return StreamBuilder<DocumentSnapshot>(
                    stream: chattingRoomStream,
                    builder: (BuildContext ctx, chatroomsnapshot) {
                      switch (chatroomsnapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Container();
                        default:
                          print(
                              "@@@@ id = ${chatroomsnapshot.data.id}, data =  ${chatroomsnapshot.data.data().toString()}");
                          DocumentSnapshot chatDocumentsnapshot =
                              chatroomsnapshot.data;
                          if (chatDocumentsnapshot.data() != null) {
                            return ListTile(
                              title: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                                child: Row(
                                  children: <Widget>[
                                    Text(chatDocumentsnapshot['board']),
                                    //Spacer(),
                                    SizedBox(width: 5, height: 10),
                                    // StreamBuilder(
                                    //   //product
                                    //   stream: FirebaseFirestore.instance
                                    //       .collection('products')
                                    //       .doc("WRITE_PRODUCT_ID")
                                    //       .snapshots(),
                                    //   builder: (BuildContext context,
                                    //       AsyncSnapshot productsnapshot) {
                                    //     return
                                    //Text(productsnapshot.data["title"]);
                                    //   },
                                    // ),
                                    Text(" 글 제목 가져옴"),
                                    SizedBox(width: 75, height: 10),
                                    GetTime(chatDocumentsnapshot),
                                  ],
                                ),
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '닉네임/익명 : ',
                                  ),
                                  //SizedBox(width: 10, height: 10),
                                  Text('type : text : ' +
                                      chatDocumentsnapshot
                                          .data()["recent_text"]
                                          .toString()),
                                  SizedBox(width: 10, height: 10),
                                  Spacer(),
                                  Text("1"),
                                ],
                              ),
                              onTap: () {
                                print("idtest");

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            InChattingRoomPage(
                                              myUId: snapshot.data.id ==
                                                      chatDocumentsnapshot[
                                                          "send_user"]
                                                  ? chatDocumentsnapshot[
                                                      "send_user"]
                                                  : chatDocumentsnapshot[
                                                      "receive_user"],
                                              friendId: snapshot.data.id !=
                                                      chatDocumentsnapshot[
                                                          "send_user"]
                                                  ? chatDocumentsnapshot[
                                                      "send_user"]
                                                  : chatDocumentsnapshot[
                                                      "receive_user"],
                                              chattingRoomId:
                                                  chatDocumentsnapshot.id,
                                            )));
                                // print("###########UID : " +snapshot.data.id +"sendUser : " +
                                //     chatDocumentsnapshot["send_user"] +" receUser : " +chatDocumentsnapshot["receive_user"]);
                              },
                            );
                          } else
                            return Container();
                      }
                    },
                  );
                },
              );
          }
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
