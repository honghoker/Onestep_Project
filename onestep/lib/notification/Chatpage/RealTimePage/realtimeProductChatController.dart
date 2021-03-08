import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:onestep/notification/model/productSendMessage.dart';
import 'package:onestep/notification/widget/chatBadge.dart';
import 'package:provider/provider.dart';
import 'package:onestep/notification/ChatCountProvider/chatCount.dart';

class RealtimeProductChatController {
  final databaseReference = FirebaseDatabase.instance.reference();

  //Product Chat Count
  DatabaseReference productChatMessageReference = FirebaseDatabase.instance
      .reference()
      .child("chattingroom")
      .child("productchat"); //Chat Message Ref
  int productChatcount = 0;

  var logger = Logger(
    //level: Level.debug,
    printer: PrettyPrinter(),
  );

  Future<void> createProductChatingRoomToRealtimeFirebaseStorage2(
      ProductSendMessage productSendMessage) async {
    String myUid = FirebaseApi.getId();
    String title;
    String friendUid;
    String productImageUrl;
    // userImageFile,
    logger.e("리얼타임 채팅 - 챗컨트롤러 0. 내부 진입");

    try {
      FirebaseFirestore.instance
          .collection("products")
          .doc(productSendMessage.postId)
          .get()
          .then((value) {
        title = value["title"];
        friendUid = value["uid"];
        productImageUrl = value["images"][0];
      }).whenComplete(
        () {
          var nowTime = DateTime.now().millisecondsSinceEpoch.toString();
//Realtime data base
          logger.e("리얼타임 채팅 - 챗컨트롤러 1. 스토어 값 읽기 완료");
          databaseReference
              .child("chattingroom")
              .child("productchat")
              .child(productSendMessage.chattingRoomId)
              //.child("roominfo")
              .set({
            "boardtype": "장터게시판",
            "title": title,
            "chatId": productSendMessage.chattingRoomId,
            "postId": productSendMessage.postId,
            "users": {
              myUid: true,
              friendUid: true,
            },
            "productImage": productImageUrl,
            "recentText": "채팅방이 생성되었습니다!",
            "timestamp": nowTime,
          }).whenComplete(() {
            logger.e("리얼타임 채팅 - 챗컨트롤러 2. 채팅방 생성 완료 후  메세지 전송");
            waitLog();
            databaseReference
                .child("chattingroom")
                .child("productchat")
                .child(productSendMessage.chattingRoomId)
                //.child("roominfo")
                .once()
                .then((DataSnapshot snapshot) {
              print('Data : ${snapshot.value}');

//                      notificationLogger("i", "누가먼저돌까요2 else 방생성안함");
            });

            onSendToProductMessage(productSendMessage);
            logger.e("리얼타임 채팅 - 챗컨트롤러 3. 메세지 전송 완료");
          }); //채팅방 생성 whenComplete
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
    ProductSendMessage productSendMessage,
  ) {
    String contentMsg = productSendMessage.contentMsg;
    int type = productSendMessage.type;
    String myId = FirebaseApi.getId();
    String friendId = productSendMessage.friendId;
    String chattingRoomId = productSendMessage.chattingRoomId;
    TextEditingController textEditingController =
        productSendMessage.textEditingController;
    ScrollController listScrollController =
        productSendMessage.listScrollController;
    logger.e("리얼타임 채팅 - 샌드 메세지 2-1. 메세지 전송 시작");

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
        "idTo": {friendId: false},
        //"idTo": friendId,
        "timestamp": messageId,
        "content": contentMsg,
        "type": type,
        //"isRead": false,
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
          "recentText": contentMsg,
          "timestamp": messageId,
        });
      });

      listScrollController.animateTo(0.0,
          duration: Duration(microseconds: 300), curve: Curves.easeOut);
      logger.e("리얼타임 채팅 - 샌드 메세지 2-2. 메세지 전송 완료");
    } //if
    else {
      logger.e("리얼타임 채팅 - 샌드 메세지 2-3. 메세지 전송 실패");

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

  StreamBuilder getRealtimeProductChatReadCounts(String chattingRoomId) {
    bool onlyOneStream = false;
    print("#read# on $chattingRoomId");
    return StreamBuilder(
        stream: productChatMessageReference
            .child('$chattingRoomId/message')
            .orderByChild("idTo/${FirebaseApi.getId()}")
            .equalTo(false)

            // .orderByChild("isRead")
            // .equalTo(false)
            .onValue, //조건1.  타임스탬프 기준
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container();
            //CircularProgressIndicator();
            default:
              if (snapshot == null ||
                  !snapshot.hasData ||
                  snapshot.data.snapshot.value == null) {
                return Text("없음 " + productChatcount.toString());
              } else if (snapshot.hasData) {
                onlyOneStream = false;
                print("#realpro Strmsg top 값 있음");

                // productChatcount = 0;

                DataSnapshot dataValues = snapshot.data.snapshot;
                Map<dynamic, dynamic> values = dataValues.value;
                print("#realpro Strmsg top value : " + values.toString());

                print("#read# start $productChatcount ${values.length}");

                // values.forEach((key, values) {
                //   productChatcount += 1; //해당되는 채팅마다 채팅개수 증가
                // });
                // print("#read# $productChatcount");
                if (onlyOneStream == false) {
                  onlyOneStream = true;
                  print("##only $onlyOneStream");
                  return chatCountBadge(values.length);
                }
                // return listProductMessage.length > 0
                //     ? ListView.builder(
                //         padding: EdgeInsets.all(10.0),
                //         shrinkWrap: true,
                //         reverse: true,
                //         controller: listScrollController,
                //         itemCount: listProductMessage.length,
                //         itemBuilder: (context, index) {
                //           return createItem(
                //               index, listProductMessage[index]);
                //         },
                //       )
                //     : Text("생성된 채팅방이 없습니다. . !");
              } else
                return Text("채팅방 카운트 Error");
          }
        }); //플렉
  }

  StreamBuilder getProductChatReadCounts(chattingRoomId, int chatListCount) {
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
