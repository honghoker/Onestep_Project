import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:onestep/BoardLib/CustomException/customThrow.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import '../boardMain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onestep/BoardLib/BoardProvi/boardClass.dart';
import 'package:onestep/BoardLib/CreateAlterBoard/parentState.dart';

class FreeBoard extends StatefulWidget {
  final Function callback;
  FreeBoard({Key key, this.callback}) : super(key: key);
  @override
  _FreeBoardState createState() => _FreeBoardState();
}

class _FreeBoardState extends _BoardListParentState<FreeBoard> {
  @override
  setBoardData() => Provider.of<List<FreeBoardList>>(context, listen: false);

  @override
  setFabCallBack() {
    fabCallback = widget.callback;
  }
}

abstract class _BoardListParentState<T extends StatefulWidget>
    extends State<T> {
  setFabCallBack();
  setBoardData();
  Function fabCallback;
  ScrollController _scrollController;
  bool isScrollDirectionUp;
  List<FreeBoardList> boardDataList;
  @override
  void initState() {
    isScrollDirectionUp = true;
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollDirectionUp == true) {
          isScrollDirectionUp = false;
          fabCallback(isScrollDirectionUp);
        }
      } else {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (isScrollDirectionUp == false) {
            isScrollDirectionUp = true;
            fabCallback(isScrollDirectionUp);
          }
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getData() async {
    boardDataList = Provider.of<List<FreeBoardList>>(context);
    return boardDataList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CupertinoActivityIndicator());
            default:
              if (snapshot.hasError) {
                return Center(
                    child: Column(children: [
                  Text("데이터 불러오기에 실패하였습니다. 네트워크 연결상태를 확인하여 주십시오."),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {});
                    },
                  )
                ]));
              } else if (!snapshot.hasData) {
                return Center(child: CupertinoActivityIndicator());
              } else {
                if (boardDataList.length == 0) {
                  return Center(child: Text("새 게시글로 시작해보세요!"));
                } else {
                  return Container(
                      child: ListView.builder(
                          controller: _scrollController,
                          //PageStorageKey is Keepping ListView scroll position when switching pageview
                          key: PageStorageKey<String>("value"),
                          //Bottom Padding
                          padding: const EdgeInsets.only(
                              bottom: kFloatingActionButtonMargin + 60),
                          itemCount: boardDataList.length,
                          itemBuilder: (context, index) =>
                              _buildListCard(context, index)));
                }
              }
          }
        });
    // boardDataList = setBoardData();
    // return boardDataList == null
    //     ? CupertinoActivityIndicator()
    //     : Container(
    //         child: ListView.builder(
    //             controller: _scrollController,
    //             //PageStorageKey is Keepping ListView scroll position when switching pageview
    //             key: PageStorageKey<String>("value"),
    //             //Bottom Padding
    //             padding: const EdgeInsets.only(
    //                 bottom: kFloatingActionButtonMargin + 60),
    //             itemCount: boardDataList.length,
    //             itemBuilder: (context, index) =>
    //                 _buildListCard(context, index)));
  }

  Widget _buildListCard(BuildContext context, int index) {
    // print(temp
    //     .id); //SOMETING//SOMETING//SOMETING//SOMETING//SOMETING//SOMETING//SOMETING//SOMETING
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(1.0),
          //Click Animation
          child: InkWell(
              // Set Click Color
              splashColor: Colors.grey,
              //Click Event
              onTap: () {
                Navigator.of(context).pushNamed('/BoardContent',
                    arguments: {"BOARD_DATA": boardDataList[index]});
              },
              child: Column(
                children: <Widget>[
                  firstColumnLine(index),
                  secondColumnLine(index),
                  thirdColumnLine(index)
                  // Container:() => show_icon_favorite(a);

                  // Expanded(child: Text('dd')),
                  // Expanded(
                  //   child: Text('data'),
                  // )
                ],
              ))),
    );
  }

  firstColumnLine(int index) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        //Title Container
        titleContainerMethod(title: boardDataList[index].title ?? ""),
        // _commentCountMethod(index)
      ],
    ));
  }

  secondColumnLine(int index) {
    String _checkCate = boardDataList[index].contentCategory.split('.')[1];
    String category;
    if (_checkCate == ContentCategory.QUESTION.toString().split('.')[1]) {
      category = ContentCategory.QUESTION.category;
    } else if (_checkCate ==
        ContentCategory.SMALLTALK.toString().split('.')[1]) {
      category = ContentCategory.SMALLTALK.category;
    } else if (kReleaseMode) {
      throw new CategoryException(
          "Does not match category. Please Update Enum in parentSate.dart Or If statement in boardListView.dart secondColumnLine");
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 5.0),
        ),
        Container(
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(3.0))),
            child: Text(
              category ?? "",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            )),
        Container(
          height: 20,
          alignment: Alignment.centerLeft,
          child: Container(
              margin: const EdgeInsets.only(left: 5),
              width: 300,
              child: Text(boardDataList[index].textContent ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black, fontSize: 13))),
        ),
      ],
    );
  }

  thirdColumnLine(int index) {
    return Container(
        child: Row(children: <Widget>[
      Expanded(
          child: Row(
        children: <Widget>[
          IconTheme(
              child: Icon(Icons.favorite, size: 14),
              data: new IconThemeData(color: Colors.red)),
          // Icon(Icons.favorite),
          Container(
            padding: EdgeInsets.only(left: 3),
            child: Text(
              boardDataList[index].favoriteCount.toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            ' | ',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Container(
            child: _setDateTimeText(boardDataList[index].createDate, index),
          ),
          Spacer(),
          Container(
              child: Icon(
            Icons.remove_red_eye,
            color: Colors.grey,
            size: 14,
          )),
          Container(
            padding: EdgeInsets.only(left: 3),
            child: Text(boardDataList[index].watchCount.toString()),
          )
        ],
        // Icon(Icons.favorite), child: Text('Date')
      )),
    ]));
  }

  _setDateTimeText(DateTime dateTime, int index) {
    String resultText;
    DateTime today = DateTime.now().add(Duration(hours: 9));
    today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime setUTC9 = dateTime.add(Duration(hours: 9));
    var _dateDifference = DateTime(setUTC9.year, setUTC9.month, setUTC9.day)
        .difference(today)
        .inDays;
    if (_dateDifference == 0 || _dateDifference == -1) {
      var _date = setUTC9.toString().split(' ')[1].split('.')[0];
      if (_dateDifference == 0) {
        resultText = "오늘 " + _date;
      } else {
        resultText = "어제 " + _date;
      }
    } else {
      var _date = dateTime.add(Duration(hours: 9)).toString().split('');
      int _dateLength = dateTime.toString().split('').length;
      _date.removeRange(_dateLength - 10, _dateLength);
      resultText = _date.join();
    }

    return Text(resultText);
  }

  @override
  Widget titleContainerMethod({@required String title}) {
    return Container(
        margin: const EdgeInsets.only(left: 5),
        width: 300,
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
        ));
  }

  Widget _commentCountMethod(int index) {
    int _commentCount = boardDataList[index].commentCount;
    Widget _commentCountText;
    BoxDecoration _commentBoxDecoration;
    //Under 30
    if (_commentCount < 30) {
      _commentBoxDecoration =
          new BoxDecoration(shape: BoxShape.circle, color: Colors.yellow);
      _commentCountText = new Text('$_commentCount',
          maxLines: 1,
          style: TextStyle(
              color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold));
      //Up 30 Under 50
    } else if (_commentCount >= 30 && _commentCount < 50) {
      _commentBoxDecoration =
          new BoxDecoration(shape: BoxShape.circle, color: Colors.orange);
      _commentCountText = new Text('$_commentCount',
          maxLines: 1,
          style: TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold));
      //Over 50
    } else {
      _commentBoxDecoration =
          new BoxDecoration(shape: BoxShape.circle, color: Colors.red);
      if (_commentCount <= 100) {
        _commentCountText = new Text('$_commentCount',
            maxLines: 1,
            style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold));
      } else {
        _commentCountText = new Text('100+',
            maxLines: 1,
            style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold));
      }
    }

    return Container(
        //CommentCount Container
        height: 30,
        width: 30,
        decoration: _commentBoxDecoration,
        child: Center(child: _commentCountText));
  }
}
