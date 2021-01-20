import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onestep/api/firebase_api.dart';

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

  Future<void> createChatingRoomToFirebaseStorage(
    bool products,
    String boardId,
    String title,
    String userUid,
    String friendId,
  ) async {
    // userImageFile,
    String _boardtype = "초기값";
    try {
      if (products == true) {
        //1. 장터게시판
        _boardtype = "장터게시판";
      } else if (products == false) {
        //2. 그외 게시판
        FirebaseFirestore.instance
            .collection("Board")
            .doc("test")
            .get()
            .then((value) {
          _boardtype = value["boardName"];
          print("일반게시판명 : " + _boardtype);
        }).whenComplete(() {
          var nowTime = DateTime.now().millisecondsSinceEpoch.toString();
          print("일반게시판명 얘가 먼저 돔 : " + _boardtype);
          FirebaseFirestore.instance
              .collection("chattingroom")
              .doc(nowTime)
              .set({
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
        });
      }
    } catch (e) {
      print(e.message);
    }
  }

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
              .collection(boardId) //찬섭이한테 통일하는건지 물어봐
              .doc(postId) //입력받아야함
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
              "read_count": 0, //sum(is_read)
              "cusers": [myUid, friendUid],
              "recent_text": "최근 텍스트 update ",
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

  Future<void> createProductChatingRoomToFirebaseStorage(
    String productId,
    String chatId,
  ) async {
    String myUid = FirebaseApi.getId();
    String title;
    String friendUid;
    String productImageUrl;
    // userImageFile,
    print("##create pro chat");
    try {
      FirebaseFirestore.instance
          .collection("products")
          .doc(productId)
          .get()
          .then((value) {
        title = value["title"];
        friendUid = value["uid"];
        productImageUrl = value["images"][0];
      }).whenComplete(
        () {
          var nowTime = DateTime.now().millisecondsSinceEpoch.toString();
          FirebaseFirestore.instance
              .collection("chattingroom")
              .doc(chatId)
              .set({
            "boardtype": "장터게시판",
            "title": title,
            "postId": productId,
            "read_count": 0, //sum(is_read)
            "cusers": [myUid, friendUid],
            "productImage": productImageUrl,
            "recent_text": "최근 텍스트 update ",
            "timestamp": nowTime,
          }).whenComplete(() {
            Fluttertoast.showToast(msg: '채팅방을 생성했습니다.');
            print("##저장완료");
          }).catchError((onError) {
            Fluttertoast.showToast(msg: '채팅방 생성에 실패했습니다.');

            print(onError);
          });
        },
      );
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
