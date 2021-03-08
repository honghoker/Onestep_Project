import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:onestep/notification/ChatCountProvider/chatCount.dart';
import 'package:onestep/notification/Controllers/chatNavigationManager.dart';
import 'package:onestep/notification/Controllers/productChatController.dart';
import 'package:onestep/notification/time/chat_time.dart';
import 'package:provider/provider.dart';

class ProductChatPage extends StatefulWidget {
  ProductChatPage({Key key}) : super(key: key);

  @override
  _ProductChatPageState createState() => _ProductChatPageState();
}

class _ProductChatPageState extends State<ProductChatPage>
    with AutomaticKeepAliveClientMixin<ProductChatPage> {
  //페이지 이전 상태 유지
  _ProductChatPageState();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  build(BuildContext context) {
    super.build(context);
    return Scaffold(body: _buildList(), backgroundColor: Colors.yellow);
  }

  Widget _buildList() {
    Stream userChatListStream1 = FirebaseFirestore.instance
        .collection('chattingroom')
        .where("users", arrayContains: FirebaseApi.getId())
        .orderBy('timestamp', descending: true)
        //.limit(2)
        .snapshots();
    final chatCount = Provider.of<ChatCount>(context); //카운트 프로바이더
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
            chatCount.initChatCount();

            return (1 > 0) //유저 수가 더 크면
                ? ListView(
                    shrinkWrap: true,
                    children: snapshot.data.docs.map((chatroomData) {
                      if (chatroomData.data() != null) {
                        String productsUserId;
                        chatroomData['users'][0] == FirebaseApi.getId()
                            ? productsUserId = chatroomData['users'][1]
                            : productsUserId = chatroomData['users'][0];
                        return ListTile(
                          leading: ProductChatController()
                              .getUserImage(productsUserId),
                          //leading end
                          title: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                ProductChatController()
                                    .getProductUserNickname(productsUserId),
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
                              // readCount
                              ProductChatController().getProductChatReadCounts(
                                  chatroomData.id, snapshot.data.size),
                              //Spacer(),
                              //getChatReadCounts(),
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
                            ChatNavigationManager.navigateToChattingRoom(
                              context,
                              chatroomData["users"][0],
                              chatroomData["users"][1],
                              chatroomData["postId"],
                            );
                          },
                        );
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

//상단 메뉴 추가
  // Widget _buildChattingRoom(var context) {
  //   return Stack(
  //     alignment: Alignment.center,
  //     children: <Widget>[
  //       IconButton(
  //           icon: Icon(Icons.chat_bubble),
  //           onPressed: () {
  //             //_onClickNotification;
  //             print(Text('우측 상단'));
  //             //createRecord();
  //           }),
  //       Positioned(
  //         top: 12.0,
  //         right: 10.0,
  //         width: 10.0,
  //         height: 10.0,
  //         child: Container(
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             //color: AppColors.notification,
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }
}
