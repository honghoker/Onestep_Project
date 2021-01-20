import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:onestep/notification/Controllers/firebaseChatController.dart';
import 'package:onestep/notification/Controllers/notificationManager.dart';
import 'package:onestep/notification/time/chat_time.dart';

class ProductChatPage extends StatefulWidget {
  ProductChatPage({Key key}) : super(key: key);

  @override
  _ProductChatPageState createState() => _ProductChatPageState();
}

class _ProductChatPageState extends State<ProductChatPage> {
  _ProductChatPageState();

  @override
  build(BuildContext context) {
    return Scaffold(
        body: _buildList(),
        //body: ScrollableTabsDemo(),
        backgroundColor: Colors.white);
  }

  Widget _buildList() {
    Stream userChatListStream1 = FirebaseFirestore.instance
        .collection('chattingroom')
//        .where("read_count", isEqualTo: 2)
        .where("cusers", arrayContains: FirebaseApi.getId())
        .orderBy('timestamp', descending: true)
        //.limit(2)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: userChatListStream1,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            Text('Loading from chat_main...');

            return Container(
              child: Center(
                child: CircularProgressIndicator(), //유저 로딩
              ),
              color: Colors.white.withOpacity(0.7),
            );
          } else {
            return (1 > 0) //유저 수가 더 크면
                ? ListView(
                    children: snapshot.data.docs.map((chatroomData) {
                    if (chatroomData.data() != null) {
                      String productsUserId;

                      chatroomData['cusers'][0] == FirebaseApi.getId()
                          ? productsUserId = chatroomData['cusers'][1]
                          : productsUserId = chatroomData['cusers'][0];

                      return ListTile(
                        leading: getUserImage(productsUserId),
                        //leading end
                        title: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              getUserNickname(productsUserId),
                              SizedBox(width: 10, height: 10),
                              Spacer(),
                              GetTime(chatroomData),
                            ],
                          ),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            //SizedBox(width: 10, height: 10),
                            Text(chatroomData.data()["recent_text"]),
                            SizedBox(width: 10, height: 10),
                            Spacer(),
                            Text("1"),
                          ],
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Material(
                                child: ExtendedImage.network(
                                  chatroomData
                                      .data()['productImage']
                                      .toString(),
                                  width: 55,
                                  height: 55,
                                  fit: BoxFit.cover,
                                  cache: true,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          NotificationManager.navigateToChattingRoom(
                            context,
                            chatroomData["cusers"][0],
                            chatroomData["cusers"][1],
                            chatroomData["postId"],
                          );
                        },
                      );
                      //여기 사이에 들어가야 함.
                    } // if 종료
                    else {
                      print("###장터 채팅없음");
                      return Text("채팅방이 없음");
                    }
                  }).toList())
                : Text("채팅없음");
          }
        });
  }

  Widget _buildChattingRoom(var context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.chat_bubble),
            onPressed: () {
              //_onClickNotification;
              print(Text('우측 상단'));
              FirebaseChatController().createChatingRoomToFirebaseStorage(
                false,
                "Board_Free",
                "임시타이틀",
                FirebaseApi.getId(),
                "friendId",
              );
              //createRecord();
            }),
        Positioned(
          top: 12.0,
          right: 10.0,
          width: 10.0,
          height: 10.0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              //color: AppColors.notification,
            ),
          ),
        )
      ],
    );
  }

  Future getUserId(String proUserId) async {
    return FirebaseFirestore.instance.collection('users').doc(proUserId).get();
  }

  FutureBuilder getUserImage(String proUserId) {
    return FutureBuilder(
      future: getUserId(proUserId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          default:
            if (snapshot.hasData == false) {
              return CircularProgressIndicator();
            }

            if (snapshot.data['photoUrl'] == "") {
              //프로필사진 미설정
              return LayoutBuilder(builder: (context, constraint) {
                return Icon(
                  Icons.supervised_user_circle,
                  size:
                      //50,
                      constraint.biggest.height,
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
                  cache: true,
                ),
              );
            }
        }
      },
    );
  }

  FutureBuilder getUserNickname(String proUserId) {
    return FutureBuilder(
      future: getUserId(proUserId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
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
              return Text(snapshot.data['nickname']);
            }
        }
      },
    );
  }
}
