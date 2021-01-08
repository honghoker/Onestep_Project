import 'package:cloud_firestore/cloud_firestore.dart';

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
        "recent_text": "뭐바",
        "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
      });
    } catch (e) {
      print(e.message);
    }
  }
}
