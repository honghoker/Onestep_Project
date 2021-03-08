import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:onestep/notification/Chatpage/RealTimePage/inRealTimeChattingRoom.dart';
import 'package:onestep/notification/widget/chatBadge.dart';
import 'package:provider/provider.dart';
import 'package:onestep/notification/ChatCountProvider/chatCount.dart';

class RealtimeProductChatController {
  final databaseReference = FirebaseDatabase.instance.reference();
  var logger = Logger(
    //level: Level.debug,
    printer: PrettyPrinter(),
  );

  Future<void> createProductChatingRoomToRealtimeFirebaseStorage(
    String productId,
    String chatId,
  ) async {
    String myUid = FirebaseApi.getId();
    String title;
    String friendUid;
    String productImageUrl;
    // userImageFile,
    print("##create pro chat");
    logger.e("누가먼저돌까요2-1 채팅방 생성 메소드 실행");

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
//Realtime data base
          logger.e("누가먼저돌까요2-2 스토어 값 read 완료, 채팅방 생성 시작");
          databaseReference
              .child("chattingroom")
              .child("productchat")
              .child(chatId)
              //.child("roominfo")
              .set({
            "boardtype": "장터게시판",
            "title": title,
            "postId": productId,
            "users": {
              myUid: true,
              friendUid: true,
            },
            "productImage": productImageUrl,
            "recent_text": "채팅방이 생성되었습니다!",
            "timestamp": nowTime,
          }).whenComplete(() {
            logger.e("누가먼저돌까요2-3 채팅방 생성완료 후 프린트 whencomplete");
            waitLog();
            databaseReference
                .child("chattingroom")
                .child("productchat")
                .child(chatId)
                //.child("roominfo")
                .once()
                .then((DataSnapshot snapshot) {
              print('Data : ${snapshot.value}');

//                      notificationLogger("i", "누가먼저돌까요2 else 방생성안함");
            });
          });
        },
      );
    } catch (e) {
      print(e.message);
    }
  }

  void waitLog() {
    logger.v("누가먼저돌까요2-4 채팅방 생성완료 후 함수실행");
  }

  void onSendToProductMessage(
    String contentMsg,
    int type,
    String myId,
    String friendId,
    String chattingRoomId,
    TextEditingController textEditingController,
    ScrollController listScrollController,
  ) {
    print("누가먼저돌까요3 메세지넘김 $contentMsg");
    //type = 0 its text msg
    //type = 1 its imageFile
    //type = 2 its sticker image
    if (contentMsg != "") {
      print("누가먼저돌까요3 메세지 낫 널 $contentMsg");

      textEditingController.clear();
      String messageId = DateTime.now().millisecondsSinceEpoch.toString();

//RealTime
      DatabaseReference productChatMessageReference = FirebaseDatabase.instance
          .reference()
          .child("chattingroom")
          .child("productchat")
          .child(chattingRoomId)
          .child("message")
          .child(messageId);

      DatabaseReference productChatReference = FirebaseDatabase.instance
          .reference()
          .child("chattingroom")
          .child("productchat")
          .child(chattingRoomId);

      productChatMessageReference.set({
        "idFrom": myId,
        "idTo": friendId,
        "timestamp": messageId,
        "content": contentMsg,
        "type": type,
        "isRead": false,
      }).whenComplete(() {
        switch (type) {
          case 1:
            contentMsg = "사진을 보냈습니다.";
            break;
          case 2:
            contentMsg = "이모티콘을 보냈습니다.";
            break;
        }
        productChatReference.update({
          "recent_text": contentMsg,
          "timestamp": messageId,
        });
      });

      listScrollController.animateTo(0.0,
          duration: Duration(microseconds: 300), curve: Curves.easeOut);
    } //if
    else {
      Fluttertoast.showToast(msg: 'Empty Message. Can not be send.');
    }
  }

  Future getUserId(String proUserId) async {
    return FirebaseFirestore.instance.collection('users').doc(proUserId).get();
  }

  FutureBuilder getProductUserNickname(String proUserId) {
    return FutureBuilder(
      future: getUserId(proUserId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          //return CircularProgressIndicator();
          default:
            if (snapshot.hasData == false) {
              return CircularProgressIndicator();
            }

            if (snapshot.data['nickname'] == "") {
              return Text("닉네임 오류");
            } else if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 15),
              );
            } else {
              return AutoSizeText(
                snapshot.data['nickname'],
                style: TextStyle(fontSize: 15),
                minFontSize: 10,
                stepGranularity: 10,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            }
        }
      },
    );
  }

  FutureBuilder getUserImage(String proUserId) {
    return FutureBuilder(
      future: getUserId(proUserId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          //return CircularProgressIndicator();
          default:
            if (snapshot.hasData == false) {
              return CircularProgressIndicator();
            }

            if (snapshot.data['photoUrl'] == "") {
              //프로필사진 미설정
              return LayoutBuilder(builder: (context, constraint) {
                return Icon(
                  Icons.supervised_user_circle,
                  size: 50,
                  //constraint.biggest.height,
                );
              });
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(fontSize: 15),
                ),
              );
            } else {
              return Expanded(
                child: ExtendedImage.network(
                  snapshot.data['photoUrl'],
                  fit: BoxFit.cover,
                  height: 50,
                  width: 50,
                  cache: true,
                ),
              );
            }
        }
      },
    );
  }

  Future<void> setToFirebaseProductChatCount(int chatCount) async {
    print("ChatCount 파이어베이스 저장 몇번?");
    //if (counts == 1)
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseApi.getId())
        .collection("chatcount")
        .doc(FirebaseApi.getId())
        .update({
      "productchatcount": chatCount,
    }).whenComplete(() {
      //Fluttertoast.showToast(msg: '채팅방카운트를 업데이트했습니다.');
      print("##챗카운트 업데이트 성공");
    }).catchError((onError) {
      Fluttertoast.showToast(msg: '채팅방카운트를 업데이트 실패.');

      print(onError);
    });
  }

  StreamBuilder getProductChatReadCounts(chattingRoomId, int chatListCount) {
    int inchatListCount = 0;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chattingroom')
            .doc(chattingRoomId)
            .collection('message')
            .where("idTo", isEqualTo: FirebaseApi.getId())
            .where("isRead", isEqualTo: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          final chatCount =
              Provider.of<ChatCount>(context); // Counter 타입의 데이터를 가져옴.
          //print("ChatCount Controller Init");
          //chatCount.initChatCount();
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text("");
            default:
              if (snapshot.hasData) {
                snapshot.data.toString();
                print("####data on " + snapshot.data.size.toString());
              } else
                return Text("x");
              // if (snapshot.data.size > 0) {
              //값 없어도 갱신시켜줘야한다.
              chatCount.setProductChatCount(snapshot.data.size);

              setToFirebaseProductChatCount(chatCount.getProductChatCount());
              print("ChatCount " + chatListCount.toString());
              //}
              return Container(
                  width: 20,
                  height: 20,
                  // decoration: snapshot.data.size.toString() != "0"
                  //     ? BoxDecoration(shape: BoxShape.circle, color: Colors.red)
                  //     : BoxDecoration(),
                  child: Center(
                    child: snapshot.data.size.toString() != "0"
                        ? chatCountBadge(snapshot.data.size)
                        // Badge(
                        //     toAnimate: true,
                        //     borderRadius: BorderRadius.circular(8),
                        //     badgeColor: Colors.blue,
                        //     badgeContent: Text(
                        //       snapshot.data.size.toString()
                        //       //+ snapshot.data.docs[1]['isRead'].toString()
                        //       ,
                        //       style:
                        //           TextStyle(fontSize: 8, color: Colors.white),
                        //     ),
                        //     //child: Icon(Icons.ac_unit, color: Colors.white),
                        //   )
                        : Text(""),
                  ));
          }
        });
  }

  //Chat Main ChatCount
  StreamBuilder getProductCountText() {
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
          if (snapshot.data.data()['productchatcount'] != null) {
            //print("####누적 채팅 : ${snapshot.data.data()['nickname']}");
          }
          return Text(
            snapshot.data.data()['productchatcount'].toString(),
            style: TextStyle(fontSize: 8, color: Colors.white),
          );
        });
  }
}
