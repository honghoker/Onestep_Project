import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onestep/BoardLib/BoardProvi/boardProvider.dart';
import 'package:onestep/BoardLib/boardMain.dart';
import 'package:provider/provider.dart';

class BoardCategoryList extends StatelessWidget {
  double device_width;
  double device_height;
  ScrollController scrollController = new ScrollController();
  BoardCategoryList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    device_height = MediaQuery.of(context).size.height;
    device_width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("게시판"),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              margin: EdgeInsets.all(device_width / 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.library_books_outlined,
                      color: Colors.green[100],
                    ),
                    title: Text("나의 글"),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.mode_comment_rounded,
                      color: Colors.green[100],
                    ),
                    title: Text("나의 댓글"),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.book_rounded,
                      color: Colors.yellow[600],
                    ),
                    title: Text("나의 스크랩"),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.favorite,
                      color: Colors.redAccent[100],
                    ),
                    title: Text("인기글"),
                  ),
                  ListTile(
                    leading: Container(
                        child: Stack(children: [
                      Container(
                          child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(math.pi),
                              child: Icon(
                                Icons.mode_comment,
                                color: Colors.red[100],
                              ))),
                      Container(
                          margin: EdgeInsets.all(3),
                          child: Icon(
                            Icons.mode_comment,
                            color: Colors.blue[100],
                          )),
                      Container(
                          margin: EdgeInsets.all(6),
                          child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(math.pi),
                              child: Icon(Icons.mode_comment,
                                  color: Colors.red[100]))),
                      Container(
                          margin: EdgeInsets.all(9),
                          child: Icon(Icons.mode_comment,
                              color: Colors.blue[100])),
                    ])),
                    title: Text(
                      "콜로세움",
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ))),
                    child: ListTile(
                      leading: Container(
                          child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Icon(
                              Icons.shopping_cart,
                              color: Colors.red[200],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Transform.rotate(
                              angle: math.pi / 4,
                              child: Icon(
                                Icons.card_giftcard,
                                color: Colors.red[200],
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      )),
                      title: Text("공동 구매"),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              margin: EdgeInsets.all(device_width / 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Container(
                        child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.red[200],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Transform.rotate(
                            angle: math.pi / 4,
                            child: Icon(
                              Icons.card_giftcard,
                              color: Colors.red[200],
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    )),
                    title: Text("공동 구매"),
                  ),
                  ListTile(
                    leading: Container(
                        child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Icon(
                            Icons.shopping_cart,
                            color: Colors.red[200],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Transform.rotate(
                            angle: math.pi / 4,
                            child: Icon(
                              Icons.card_giftcard,
                              color: Colors.red[200],
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    )),
                    title: Text("공동 구매"),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.shopping_cart_rounded,
                      color: Colors.red[200],
                    ),
                    title: Text("공동 구매"),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.red[200],
                    ),
                    title: Text("공동 구매"),
                  ),
                  futurebuilderWidget()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  fetchData() {
    return FirebaseFirestore.instance.collection("Board").get();
  }

  futurebuilderWidget() {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return CupertinoActivityIndicator();
          default:
            if (snapshot.hasError) {
              return Center(
                  child: Column(
                children: [Text("데이터 불러오기에 실패하였습니다. 네트워크 연결상태를 확인하여 주십시오.")],
              ));
            } else if (snapshot.hasData) {
              return Container(
                  child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  List<BoardCategory> boardCategoryList = BoardCategory.values;
                  String categoryKR = '';
                  for (int i = 0; i < boardCategoryList.length; i++) {
                    print(boardCategoryList[i].categoryEN);
                    if (boardCategoryList[i].categoryEN ==
                        snapshot.data.docs[index].id) {
                      categoryKR = boardCategoryList[i].categoryKR;
                      break;
                    }
                  }
                  return Container(
                    child: Text(categoryKR),
                  );
                },
              ));
            }
        }
      },
    );
  }
}
