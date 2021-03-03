import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onestep/api/firebase_api.dart';

class BoardChatController {
  Future<void> createBoardChatingRoomToFirebaseStorage(
    String boardId, //게시판Id
    String postId, //게시글Id
    String chatId, //생성 챗 Id
  ) async {
    String myUid = FirebaseApi.getId();
    String title;
    String friendUid;
    String boardName;
    // userImageFile,
    try {
      FirebaseFirestore.instance
          .collection("Board")
          .doc(boardId)
          .get()
          .then((value) {
        boardName = value["boardName"];
      }).whenComplete(
        () {
          FirebaseFirestore.instance
              .collection("Board")
              .doc(boardId)
              .collection(boardId)
              .doc(postId)
              .get()
              .then((value) {
            title = value["title"];
            friendUid = value["uid"];
          }).whenComplete(() {
            var nowTime = DateTime.now().millisecondsSinceEpoch.toString();
            FirebaseFirestore.instance
                .collection("boardChattingroom")
                .doc(chatId)
                .set({
              "boardtype": boardName,
              "title": title,
              "boardId": boardId,
              "postId": postId,
              "users": [myUid, friendUid],
              "recent_text": "채팅방이 생성되었습니다!",
              "timestamp": nowTime,
            }).whenComplete(() {
              Fluttertoast.showToast(msg: '채팅방을 생성했습니다.');
              print("##저장완료");
            }).catchError((onError) {
              Fluttertoast.showToast(msg: '채팅방 생성에 실패했습니다.');

              print(onError);
            });
          });
        },
      );
    } catch (e) {
      print(e.message);
    }
  }
  //Chat Main ChatCount

  StreamBuilder getBoardCountText() {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseApi.getId())
            .collection("chatcount")
            .doc(FirebaseApi.getId())
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data.toString());
          } else
            return Text("error");
          if (snapshot.data.data()['boardchatcount'] != null) {
            print("####누적 채팅 : ${snapshot.data.data()['nickname']}");
          }
          return Text(
            snapshot.data.data()['boardchatcount'].toString(),
            style: TextStyle(fontSize: 8, color: Colors.white),
          );
        });
  }
}
