import 'package:flutter/material.dart';
import 'package:onestep/api/firebase_api.dart';

import '../inChattingRoom.dart';

class NotificationManager {
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
}
