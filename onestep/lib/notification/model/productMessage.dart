import 'package:firebase_database/firebase_database.dart';

class ProductMessage {
  String content;
  String idFrom;
  String idTo;
  bool isRead;
  String timestamp;
  int type;

  ProductMessage({
    this.content,
    this.idFrom,
    this.idTo,
    this.isRead,
    this.timestamp,
    this.type,
  });

  ProductMessage.forMapSnapshot(dynamic snapshot) {
    content = snapshot["content"];
    idFrom = snapshot["idFrom"];
    idTo = snapshot["idTo"];
    isRead = snapshot["isRead"];
    timestamp = snapshot["timestamp"];
    type = snapshot["type"];
  }

//채팅방 ID
  DatabaseReference createChatID(String chatId) {
    return FirebaseDatabase.instance.reference().child("path").child(chatId);
  }

  createChat(String chatId) {
    createChatID(chatId).set(toJson());
  }

  toJson() {
    print("리얼타임 투제이슨 실행");
    //print("리얼타임내부:" + boardType);
    return {
      "content": content,
      "idFrom": idFrom,
      "idTo": idTo,
      "isRead": isRead,
      "timestamp": timestamp,
      "type": type,
    };
  }
}
