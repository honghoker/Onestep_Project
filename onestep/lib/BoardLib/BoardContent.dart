import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:like_button/like_button.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:onestep/notification/Controllers/notificationManager.dart';
import 'package:tip_dialog/tip_dialog.dart';
import 'package:onestep/BoardLib/BoardProvi/boardClass.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:onestep/cloth/imageFullViewerWIdget.dart';
import 'package:flutter/animation.dart';
import 'package:onestep/api/firebase_api.dart';

class BoardContent extends StatefulWidget {
  final BoardData boardData;
  BoardContent({this.boardData});

  @override
  _Board createState() => new _Board();
}

class _Board extends State<BoardContent>
// with TickerProviderStateMixin
{
  BoardData boardData;
  var _onFavoriteClicked;
  //If clicked favorite button, activate this animation
  AnimationController _favoriteAnimationController;
  // Animation _favoriteAnimation;
  //index is not null and must have to get index
  String currentUID;
  ScrollController _scrollController;
  Map<String, dynamic> _imageMap = {};
  List<dynamic> _imageList = [];
  Map boardDataFutureBuilderMap;
  @override
  void initState() {
    super.initState();
    boardData = widget.boardData;
    // currentUID = FirebaseApi.getId();
    // _settingFavoriteAnimation();

    _onFavoriteClicked = false;
    _scrollController = ScrollController();
    watchCountUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: <Widget>[
        // Container(
        //   //Dynamic height Size
        //   height: MediaQuery.of(context).size.height,
        //   // alignment: AlignmentA,
        //   child:
        SingleChildScrollView(
            controller: _scrollController,
            // child: Expanded(
            // height: MediaQuery.of(context).size.height,
            child: Column(children: <Widget>[
              // Title Container
              setTitle(boardData.title),
              //Date Container
              setDateNVisitor(boardData.createDate, boardData.watchCount),
              // FutureBuilder(future:,builder: builder,AsyncSnapshot snapshot){}
              setBoardContent(),
              imageContent(),
            ])),
        // ),
        // ),
        TipDialogContainer(
          duration: const Duration(milliseconds: 400),
          maskAlpha: 0,
        )
      ]),
    ));
  }

  Future<void> watchCountUpdate() async {
    if (currentUID != boardData.uid) {
      final FirebaseFirestore _db = FirebaseFirestore.instance;
      String _boardID = boardData.boardId.toString();
      String _documentID = boardData.documentId.toString();
      _db
          .collection("Board")
          .doc(_boardID)
          .collection(_boardID)
          .doc(_documentID)
          .update({"watchCount": boardData.watchCount + 1});
      _db.disableNetwork();
    }
  }

  _getImageContent() async {
    currentUID = await FirebaseApi.getId();
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    String _boardID = boardData.boardId.toString();
    String _documentID = boardData.documentId.toString();
    return _db
        .collection("Board")
        .doc(_boardID)
        .collection(_boardID)
        .doc(_documentID)
        .get();
  }

  Widget imageContent() {
    return FutureBuilder(
      future: _getImageContent(),
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
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {});
                  },
                )
              ]));
            } else {
              return Column(children: [
                _setImageContent(snapshot.data),
                setScrapAndFavoriteButton()
              ]);
            }
        }
      },
    );
  }

  _setImageContent(DocumentSnapshot snapshot) {
    boardDataFutureBuilderMap = snapshot.data();

    _imageMap = snapshot.data()["imageCommentList"];
    List<dynamic> _commentList = _imageMap["COMMENT"];
    List<dynamic> _imageURi = _imageMap["IMAGE"];
    List<dynamic> _imageWidgetList = [];
    // _imageURi.forEach((element) {})
    List<Widget> _imageContainer = [];

    _imageURi.asMap().forEach((index, element) async {
      _imageList.add(
        CachedNetworkImage(
          imageUrl: element.toString(),
          placeholder: (context, url) => CupertinoActivityIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      );
      _imageContainer.add(GestureDetector(
          onTap: () {
            print('$index');
            Navigator.of(context).pushNamed('/CustomFullViewer',
                arguments: {"INDEX": index, "IMAGES": _imageURi});
          },
          child: Container(
              padding: EdgeInsets.all(10.0), child: _imageList[index])));
    });
    return Column(
      children: _imageContainer,
    );

    // return Column(children: [
    //   GestureDetector(
    //       onTap: () {
    //         Navigator.pushNamed(context, '/ImageFullViewer',
    //             arguments: {"INDEX": 0, "IMAGES": _imageList});
    //       },
    //       child: Container(
    //         child: _imageList[0],
    //       ))
    // ]);
  }

  getBoardData() async {
    // DocumentSnapshot documentSnapshot = await doc_
  }

  Widget setTitle(String title) {
    return Container(
      width: double.infinity,
      child: Container(
          margin: EdgeInsets.only(left: 5),
          child: Text(title ?? "",
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: new TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 1))
      ]),
    );
  }

  Widget setDateNVisitor(DateTime createTime, int watch) {
    String _dateTime =
        createTime.add(Duration(hours: 9)).toString().split('.')[0];
    return Container(
      child: Container(
          margin: EdgeInsets.only(top: 5, right: 5),
          // alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end, //Start from Right
            children: <Widget>[
              IconTheme(
                child: Icon(Icons.access_time, size: 20),
                data: new IconThemeData(color: Colors.grey),
              ),
              Text(
                _dateTime,
                style: new TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              Text(
                ' | ',
                style: new TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              IconTheme(
                child: Icon(
                  Icons.remove_red_eye,
                  size: 20,
                ),
                data: new IconThemeData(color: Colors.grey),
              ),
              Text(
                watch.toString(),
                style: new TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ],
          )),
    );
  }

  Widget setBoardContent() {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
      ),
      padding: EdgeInsets.all(5),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Text(boardData.textContent.toString(),
          style: TextStyle(fontSize: 15)),
    );
  }

  // _scrollPosition(bool isLiked) async {
  //   _scrollController.attach(_scrollController.position);

  //   // return !isLiked;
  // }

  Widget setScrapAndFavoriteButton() {
    double width = MediaQuery.of(context).size.width;
    // AnimationController _favoriteAnimationController =
    //     AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    return boardDataFutureBuilderMap.runtimeType != null
        ? Container(
            margin: EdgeInsets.only(bottom: 10, top: 5),
            // padding: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
                border:
                    Border(top: BorderSide(width: 0.5, color: Colors.grey))),
            height: 30,
            // padding: EdgeInsets.only(left: 7.0),
            child: Stack(
              children: <Widget>[
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: <Widget>[
                //     //Set Favorite Button
                Positioned(
                  left: width / 40,
                  child: LikeButton(
                    isLiked: boardDataFutureBuilderMap["favoriteUserList"]
                        .contains(currentUID),
                    onTap: _clickFavoriteButton,
                    size: 30,
                    circleColor:
                        CircleColor(start: Colors.grey, end: Colors.red),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: Colors.red,
                      dotSecondaryColor: Colors.orange,
                    ),
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.favorite,
                        color: isLiked ? Colors.red : Colors.grey,
                        size: 30,
                      );
                    },
                    likeCount: boardData.favoriteCount,
                    countBuilder: (int count, bool isLiked, String text) {
                      var color = isLiked ? Colors.red[900] : Colors.grey;
                      Widget result;
                      if (count == 0) {
                        result = Text(
                          "Love",
                          style: TextStyle(color: color),
                        );
                      } else
                        result = Text(
                          text,
                          style: TextStyle(color: color),
                        );
                      return result;
                    },
                  ),
                ),
                Positioned(
                  left: width * (1 / 5),
                  child: IconButton(
                      padding: EdgeInsets.only(bottom: 0),
                      alignment: Alignment.topCenter,
                      icon: Icon(
                        Icons.near_me_outlined,
                        size: 30,
                      ),
                      onPressed: () {
                        print("###dt");
                        print("###" +
                            FirebaseApi.getId() +
                            "###" +
                            boardData.uid.toString() +
                            "##board##" +
                            boardData.boardId.toString() +
                            "###" +
                            boardData.documentId.toString());

                        NotificationManager.navigateToBoardChattingRoom(
                          context,
                          FirebaseApi.getId(),
                          boardData.uid,
                          boardData.boardId, //게시판id
                          boardData.documentId, //게시글id
                        );
                      }),
                ),

                //Set Scrap Button
                Positioned(
                  left: width * (14 / 17),
                  child: LikeButton(
                    // padding: EdgeInsets.only(left: 20),
                    size: 30,
                    circleColor:
                        CircleColor(start: Colors.grey, end: Colors.yellow),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: Colors.yellow,
                      dotSecondaryColor: Colors.yellow,
                    ),
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.bookmark,
                        color: isLiked ? Colors.yellow : Colors.grey,
                        size: 30,
                      );
                    },
                    likeCount: 999,
                    countBuilder: (int count, bool isLiked, String text) {
                      var color = isLiked ? Colors.yellow[900] : Colors.grey;
                      Widget result;
                      if (count == 0) {
                        result = Text(
                          "love",
                          style: TextStyle(color: color),
                        );
                      } else
                        result = Text(
                          text,
                          style: TextStyle(color: color),
                        );
                      return result;
                    },
                  ),
                ),
              ],
            )
            // ]
            // )

            )
        : CupertinoActivityIndicator();
  }

  checkLikeButton() {
    return boardDataFutureBuilderMap["favoriteUserList"].contains(currentUID);
  }

  Future<bool> _clickFavoriteButton(bool isLike) async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    if (!isLike) {
      print(boardDataFutureBuilderMap["favoriteUserList"]);
      // print("Like");

      String _boardID = boardData.boardId.toString();
      String _documentID = boardData.documentId.toString();
      _db
          .collection("Board")
          .doc(_boardID)
          .collection(_boardID)
          .doc(_documentID)
          .update({
        "favoriteCount": boardDataFutureBuilderMap["favoriteCount"] + 1,
        "favoriteUserList": boardDataFutureBuilderMap["favoriteUserList"]
          ..add(boardData.uid)
      });
    } else {
      String _boardID = boardData.boardId.toString();
      String _documentID = boardData.documentId.toString();
      _db
          .collection("Board")
          .doc(_boardID)
          .collection(_boardID)
          .doc(_documentID)
          .update({
        "favoriteCount": boardDataFutureBuilderMap["favoriteCount"] - 1,
        "favoriteUserList": boardDataFutureBuilderMap["favoriteUserList"]
          ..remove(boardData.uid)
      });
    }
    return !isLike;
  }

  Future _setPopUpFavoriteIcon() async {
    TipDialogHelper.show(
        tipDialog: new TipDialog.builder(bodyBuilder: (context) {
      return Opacity(
        opacity: 0.9,
        child: new Container(
            color: Colors.white,
            width: 90,
            height: 90,
            alignment: Alignment.center,
            child: Icon(
              Icons.favorite,
              size: 90,
              color: Colors.red,
            )),
      );
    }));
  }

  @override
  void dispose() {
    super.dispose();
    _favoriteAnimationController?.dispose();
  }
}
