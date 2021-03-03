import 'package:firebase_database/firebase_database.dart';

class ProductChat {
  String boardType;
  String title;
  String postId;
  String user1;
  String user2;
  String productImage;
  String recenTtext;
  String timeStamp;
  //String key;
  String users;
  //List<String> users;

  DatabaseReference databasereference =
      FirebaseDatabase.instance.reference().child("path");

  ProductChat({
    this.boardType,
    this.title,
    this.postId,
    // this.user1,
    // this.user2,
    //this.key,
    this.productImage,
    this.recenTtext,
    this.timeStamp,
    this.users,
  });

  ProductChat.forMapSnapshot(dynamic snapshot) {
    //key = snapshot.key;
    boardType = snapshot['roominfo']["boardtype"];
    title = snapshot['roominfo']["title"];
    postId = snapshot['roominfo']["postId"];
    productImage = snapshot['roominfo']["productImage"];
    recenTtext = snapshot['roominfo']["recent_text"];
    timeStamp = snapshot['roominfo']["timestamp"];
    users = snapshot['roominfo']["users"].toString();
    user1 = snapshot['roominfo']["users"][0];
    user2 = snapshot['roominfo']["users"][1];
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
      "boardtype": boardType,
      "title": title,
      "postId": postId,
      "productImage": productImage,
      "recentText": recenTtext,
      "timestamp": timeStamp,
      "users": [user1, user2],
    };
  }

  load() {
    print(" $boardType, $postId, $productImage, $recenTtext, $timeStamp");
  }

//안씀
  ProductChat.forSnapshot(DataSnapshot snapshot) {
    print("####에드 폴 호출");
    print(
        "####에드 폴스냅샷 넣기전 ${snapshot.key} ${snapshot.value["boardtype"]} ${snapshot.value["users"]}");
    //key = snapshot.key;
    boardType = snapshot.value["boardtype"];
    title = snapshot.value["title"];
    postId = snapshot.value["postId"];
    // user1 = snapshot.value["users"][0],
    // user2 = snapshot.value["users"][1],
    productImage = snapshot.value["productImage"];
    recenTtext = snapshot.value["recentText"];
    timeStamp = snapshot.value["timestamp"];
    users = snapshot.value["users"].toString();
    print("####에드 다넣음");
    // print(
    //     "####에드 폴스냅샷 내부 $key $boardType $title $postId $productImage $recenTtext $timeStamp $users");
  }

  factory ProductChat.fromFireStore(Map<dynamic, dynamic> snapshot) {
    //print("snapshot sss" + snapshot['boardtype']);
    return ProductChat(
      boardType: snapshot['boardtype'],
      title: snapshot["title"],
      postId: snapshot["postId"],
      // user1: snapshot['users'][0],
      // user2: snapshot['users'][1],
      productImage: snapshot["productImage"],
      recenTtext: snapshot["recentText"],
      timeStamp: snapshot["timestamp"],
      // users: snapshot['users']
      //[0] + snapshot['users'][1],
    );
  }
}
