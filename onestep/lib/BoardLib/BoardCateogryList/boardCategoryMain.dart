import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onestep/BoardLib/BoardProvi/boardProvider.dart';
import 'package:onestep/BoardLib/boardMain.dart';
import 'package:provider/provider.dart';

class BoardCategoryList extends StatefulWidget {
  BoardCategoryList({
    Key key,
  }) : super(key: key);

  @override
  _BoardCategoryListState createState() => _BoardCategoryListState();
}

class _BoardCategoryListState extends State<BoardCategoryList> {
  List<BoardCategory> boardCategoryList = [];

  @override
  void initState() {
    super.initState();

    // boardCategoryList = boardCateogryProvider.categorys;
  }

  fetchData() {
    return FirebaseFirestore.instance.collection("Board").get();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Column(children: [
                Text("데이터 불러오기에 실패하였습니다. 네트워크 연결상태를 확인하여 주십시오."),
                Text("${snapshot.hasError}"),
              ]));
            } else {
              // bool haveUnderComment = snapshot.data.length != 0;
              return Container(child: Text(snapshot.data.docs[0].id));
            }
        }
      },
    );
  }

  listviewBuilder() {}
}
