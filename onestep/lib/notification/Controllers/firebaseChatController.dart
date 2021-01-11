import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../main.dart';

class FirebaseChatController {
  Future<void> createChatListToFirebaseStorage(
      String userUid, String chatId) async {
    // userImageFile,
    try {
      FirebaseFirestore.instance
          .collection("user_chatlist")
          .doc(userUid)
          .update({
        //"id": userUid,
        chatId: true,
      });
    } catch (e) {
      print(e.message);
    }
  }

  Future<void> whereTest() async {
    print("count");
    // userImageFile,
    try {
      FirebaseFirestore.instance
          .collection("chattingroom")
          .where("read_count", isEqualTo: 0)
          .get()
          .then((QuerySnapshot ds) {
        print("count!!!");

        ds.docs.forEach((doc) => print(doc["count@@@"]));
      });
    } catch (e) {
      print("count fail");

      print(e.message);
    }
  }

  Future<void> createChatingRoomToFirebaseStorage(
      String userUid, String friendId, String chatId) async {
    // userImageFile,
    try {
      FirebaseFirestore.instance.collection("chattingroom").doc(chatId).update({
        "board": "자유게시판",
        "read_count": 0,
        "receive_user": userUid,
        "send_user": friendId,
        "recent_chattime": "오늘",
        "recent_text": "안녕하세요.",
        "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
      });
    } catch (e) {
      print(e.message);
    }
  }

  Future<void> createChatingRoomToFirebaseStorage2(
      String userUid, String friendId) async {
    // userImageFile,
    try {
      var nowTime = DateTime.now().millisecondsSinceEpoch.toString();
      FirebaseFirestore.instance.collection("chattingroom").doc(nowTime)
          //.doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        "board": "게시판 이름 정하세요",
        "read_count": 0,
        "receive_user": userUid,
        "send_user": friendId,
        "recent_chattime": "최근 채팅 시간",
        "recent_text": "최근 텍스트 update ",
        "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
      });

      FirebaseFirestore.instance
          .collection("user_chatlist")
          .doc(userUid)
          .update({
        //"id": userUid,
        nowTime: true,
      });
      FirebaseFirestore.instance
          .collection("user_chatlist")
          .doc(friendId)
          .update({
        //"id": userUid,
        nowTime: true,
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
