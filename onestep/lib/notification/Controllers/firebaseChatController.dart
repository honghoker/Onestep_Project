import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../main.dart';

class FirebaseChatController {
  Future<void> normalForm(String userUid, String chatId) async {
    // userImageFile,
    try {
      FirebaseFirestore.instance.collection("").doc(userUid).update({
        //"id": userUid,
        chatId: true,
      });
    } catch (e) {
      print(e.message);
    }
  }

  Future<void> createChatingRoomToFirebaseStorage(bool products, String boardId,
      String title, String userUid, String friendId) async {
    // userImageFile,
    String _boardtype = "초기값";
    try {
      if (products == true) {
        _boardtype = "장터게시판";
      } else if (products == false) {}

      var nowTime = DateTime.now().millisecondsSinceEpoch.toString();

      FirebaseFirestore.instance.collection("chattingroom").doc(nowTime).set({
        "boardtype": _boardtype, //boardtype, title 가져와야한다.
        "title": title, //title
        "read_count": 0,
        "cusers": [userUid, friendId],
        "recent_chattime": "최근 채팅 시간",
        "recent_text": "최근 텍스트 update ",
        "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
      }).whenComplete(() {
        print("저장완료");
      }).catchError((onError) {
        print(onError);
      });
    } catch (e) {
      print(e.message);
    }
  }

  Future<Null> logoutUser(var context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    print('##로그아웃 버튼 누름');
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
        (Route<dynamic> route) => false);
  }
}
