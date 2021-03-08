import 'package:flutter/material.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:onestep/notification/Chatpage/BoardChatPage/inBoardChattingRoom.dart';
import 'package:onestep/notification/Chatpage/ProductChatPage/inChattingRoom.dart';

class ChatNavigationManager {
  static void navigateToChattingRoom(
      var context, String myUid, String friendUid, String postId) {
    print("## 노티 $myUid $friendUid $postId");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InChattingRoomPage(
                  myUid: FirebaseApi.getId() == myUid ? myUid : friendUid,
                  friendId: FirebaseApi.getId() != myUid ? myUid : friendUid,
                  postId: postId,
                )));
  }

  static void navigateToBoardChattingRoom(var context, String myUid,
      String friendUid, String boardId, String postId) {
    print("## 노티 $myUid $friendUid $boardId $postId");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InBoardChattingRoomPage(
                  myUid: FirebaseApi.getId() == myUid ? myUid : friendUid,
                  friendId: FirebaseApi.getId() != myUid ? myUid : friendUid,
                  postId: postId,
                  boardId: boardId,
                )));
  }
}
