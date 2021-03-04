import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:onestep/notification/widget/chatBadge.dart';
import 'package:provider/provider.dart';
import 'package:onestep/notification/ChatCountProvider/chatCount.dart';

class ProductChatController {
  final databaseReference = FirebaseDatabase.instance.reference();

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
            "users": [myUid, friendUid],
            "productImage": productImageUrl,
            "recent_text": "채팅방이 생성되었습니다!",
            "timestamp": nowTime,
          }).whenComplete(() {
            Fluttertoast.showToast(msg: '채팅방을 생성했습니다.');
            print("##저장완료");
          }).catchError((onError) {
            Fluttertoast.showToast(msg: '채팅방 생성에 실패했습니다.');

            print(onError);
          });
//Realtime data base
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
            databaseReference
                .child("chattingroom")
                .child("productchat")
                .child(chatId)
                //.child("roominfo")
                .once()
                .then((DataSnapshot snapshot) =>
                    {print('Data : ${snapshot.value}')});
          });
        },
      );
    } catch (e) {
      print(e.message);
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
