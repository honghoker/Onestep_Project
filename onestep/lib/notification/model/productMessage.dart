import 'package:firebase_database/firebase_database.dart';

class ProductMessage {
  String content;
  String idFrom;
  String idTo;
  String isRead;
  String timestamp;
  String type;

  ProductMessage({
    this.content,
    this.idFrom,
    this.idTo,
    this.isRead,
    this.timestamp,
    this.type,
  });

  ProductMessage.forMapSnapshot(dynamic snapshot) {
    content = snapshot['message']["content"];
    idFrom = snapshot['message']["idFrom"];
    idTo = snapshot['message']["idTo"];
    isRead = snapshot['message']["isRead"];
    timestamp = snapshot['message']["timestamp"];
    type = snapshot['message']["type"];
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
