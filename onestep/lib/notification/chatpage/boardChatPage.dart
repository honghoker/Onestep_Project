import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:onestep/notification/Controllers/firebaseChatController.dart';
import 'package:onestep/notification/Controllers/notificationManager.dart';
import 'package:onestep/notification/time/chat_time.dart';

class BoardChatPage extends StatefulWidget {
  BoardChatPage({Key key}) : super(key: key);

  @override
  _BoardChatPageState createState() => _BoardChatPageState();
}

class _BoardChatPageState extends State<BoardChatPage> {
  _BoardChatPageState();

  @override
  build(BuildContext context) {
    return Scaffold(
        body: _buildList(),
        //body: ScrollableTabsDemo(),
        backgroundColor: Colors.white);
  }

  Widget _buildList() {
    Stream boardChatListStream = FirebaseFirestore.instance
        .collection('boardChattingroom')
//        .where("read_count", isEqualTo: 2)
        .where("cusers", arrayContains: FirebaseApi.getId())
        .orderBy('timestamp', descending: true)
        //.limit(2)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: boardChatListStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            Text('Loading from chat_main...');

            return Container(
              child: Center(
                child: CircularProgressIndicator(), //유저 로딩
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
                              Text(chatroomData.data()["boardtype"]),
                              SizedBox(
                                width: 5,
                              ),
                              Text(chatroomData.data()["title"]),
                              SizedBox(width: 10, height: 10),
                              Spacer(),
                              GetTime(chatroomData),
                            ],
                          ),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            //SizedBox(width: 10, height: 10),
                            Text(chatroomData.data()["recent_text"]),
                            SizedBox(width: 10, height: 10),
                            Spacer(),
                            Text("1"),
                          ],
                        ),
                        onTap: () {
                          NotificationManager.navigateToBoardChattingRoom(
                            context,
                            chatroomData["cusers"][0],
                            chatroomData["cusers"][1],
                            "Board_Free",
                            chatroomData["postId"],
                          );
                        },
                      );
                      //여기 사이에 들어가야 함.
                    } // if 종료
                    else {
                      print("##반환없음");
                      return Container();
                    }
                  }).toList())
                : Text("채팅없음");
          }
        });
  }
}
