import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:onestep/notification/Controllers/firebaseChatController.dart';
import 'package:onestep/notification/Controllers/notificationManager.dart';
import 'package:onestep/notification/chatpage/productsChatPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'time/chat_time.dart';

//채팅 1페이지 일 때 원본
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
        //body: _buildList(),
        body: ScrollableTabsDemo(),
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
    Stream userChatListStream1 = FirebaseFirestore.instance
        .collection('chattingroom')
//        .where("read_count", isEqualTo: 2)
        //.where("cusers", arrayContains: "V92paJ9JAOfkT5Yn7euAKiZfpoS2")
        .where("cusers", arrayContains: FirebaseApi.getId())
        .orderBy('timestamp', descending: true)
        //.limit(2)
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
                    if (chatroomData.data() != null) {
                      return ListTile(
                        title: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(chatroomData['boardtype']),
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
                              Text(
                                chatroomData['title'],
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                  //  fontStyle: FontStyle.italic,
                                ),
                              ),
                              SizedBox(width: 10, height: 10),
                              Spacer(),
                              GetTime(chatroomData),
                            ],
                          ),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '닉네임 : ',
                            ),
                            //SizedBox(width: 10, height: 10),
                            Text('type : text : ' +
                                chatroomData.data()["recent_text"].toString()),
                            SizedBox(width: 10, height: 10),
                            Spacer(),
                            Text("1"),
                          ],
                        ),
                        onTap: () {
                          print("idtest");
                          //얘는 일단 냅둬얒함
                          NotificationManager.navigateToChattingRoom(
                            context,
                            chatroomData["cusers"][0],
                            chatroomData["cusers"][1],
                            chatroomData["postId"],
                          );
                        },
                      );
                    } else {
                      print("##반환없음");
                      return Container();
                    }
                  }).toList())
                : Text("채팅없을경우");
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
              //_onClickNotification;
              print(Text('우측 상단'));
              FirebaseChatController().createChatingRoomToFirebaseStorage(
                false,
                "Board_Free",
                "임시타이틀",
                FirebaseApi.getId(),
                "friendId",
              );
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
