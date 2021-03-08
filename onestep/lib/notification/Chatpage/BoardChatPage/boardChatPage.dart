import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:onestep/notification/Controllers/chatNavigationManager.dart';
import 'package:onestep/notification/time/chat_time.dart';

class BoardChatPage extends StatefulWidget {
  BoardChatPage({Key key}) : super(key: key);

  @override
  _BoardChatPageState createState() => _BoardChatPageState();
}

class _BoardChatPageState extends State<BoardChatPage>
    with AutomaticKeepAliveClientMixin<BoardChatPage> {
  _BoardChatPageState();

  @override
  build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: _buildList(),
        //body: ScrollableTabsDemo(),
        backgroundColor: Colors.white);
  }

  Widget _buildList() {
    Stream boardChatListStream = FirebaseFirestore.instance
        .collection('boardChattingroom')
//        .where("read_count", isEqualTo: 2)
        .where("users", arrayContains: FirebaseApi.getId())
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
                            getBoardChatReadCounts(chatroomData.id),
                          ],
                        ),
                        onTap: () {
                          ChatNavigationManager.navigateToBoardChattingRoom(
                            context,
                            chatroomData["users"][0],
                            chatroomData["users"][1],
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

  StreamBuilder getBoardChatReadCounts(String chattingRoomId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('boardChattingroom')
          .doc(chattingRoomId)
          .collection('message')
          .where("idTo", isEqualTo: FirebaseApi.getId())
          .where("isRead", isEqualTo: false)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          snapshot.data.toString();
          print("####" + snapshot.data.size.toString());
        } else
          return Text("사이즈 없음");

        return Text(snapshot.data.size.toString());
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
