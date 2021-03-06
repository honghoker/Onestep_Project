import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'BoardComment/bottomsheep_widget.dart';
import 'package:async/async.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:io' show Platform;

class BoardContent extends StatefulWidget {
  final BoardData boardData;
  BoardContent({this.boardData});

  @override
  _Board createState() => new _Board();
}

class _Board extends State<BoardContent> with SingleTickerProviderStateMixin
// with TickerProviderStateMixin
{
  final String REFRESH_COMMENT = "COMMENT";
  final String REFRESH_IMAGE = "IMAGE";
  final String REFRESH_LIKEBUTTON = "LIKEBUTTON";
  final String COMMENT_COLLECTION_NAME = "Comment";
  final String REFRESH_UNDERCOMMENT = "UNDERCOMMENT";
  final _scrollController = ScrollController(keepScrollOffset: true);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var boardContentSnapshot;

  AnimationController _animationController;

  AsyncMemoizer _imageMemoizer = AsyncMemoizer();
  AsyncMemoizer _likeButtonMemoizer = AsyncMemoizer();
  AsyncMemoizer _commentMemoizer = AsyncMemoizer();
  Map<String, dynamic> _commentMemoizerMapping;

  double device_width;
  double device_height;

  BoardData boardData;
  var _onFavoriteClicked;
  Map favorite_data;
  //If clicked favorite button, activate this animation
  AnimationController _favoriteAnimationController;
  TextEditingController _textEditingControllerComment;
  String currentUID;

  bool isImageRefresh;
  bool isLikeButtonRefresh;
  bool isCommentRefresh;
  bool isUnderCommentRefresh;

  ClickedCommentData _clickedCommentData;
  Map<String, dynamic> _imageMap = {};
  List<dynamic> _imageList = [];
  bool isCommentBoxVisible;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _clickedCommentData = new ClickedCommentData(
        commentDocumentId: null, isCommentClicked: false);
    _textEditingControllerComment = TextEditingController();
    currentUID = FirebaseApi.getId();
    boardData = widget.boardData;
    isCommentBoxVisible = false;
    isImageRefresh =
        isLikeButtonRefresh = isCommentRefresh = isUnderCommentRefresh = true;
    _commentMemoizerMapping = {};
    _onFavoriteClicked = false;

    watchCountUpdate();
  }

  setPopupMenuButton(bool isItself) {
    return isItself
        ? [
            PopupMenuItem(child: Text("수정하기"), value: "Alter"),
            PopupMenuItem(
                child: Text(
                  "삭제",
                  style: TextStyle(color: Colors.redAccent),
                ),
                value: "Delete")
          ]
        : [
            PopupMenuItem(
                child: Text(
                  "신고하기",
                  style: TextStyle(color: Colors.redAccent),
                ),
                value: "Report")
          ];
  }

  @override
  Widget build(BuildContext context) {
    device_width = MediaQuery.of(context).size.width;
    device_height = MediaQuery.of(context).size.height;
    return new Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(device_height / 20),
          child: AppBar(
            backgroundColor: Colors.white,
            title: setTitle(boardData.title),
            actions: [
              PopupMenuButton(
                  onSelected: (route) {
                    print(route);
                  },
                  itemBuilder: (BuildContext bc) =>
                      setPopupMenuButton(boardData.uid == currentUID))
            ],
          ),
        ),
        key: _scaffoldKey,
        body: SafeArea(
          child: Stack(alignment: Alignment.bottomCenter, children: <Widget>[
            Container(
              //Dynamic height Size
              height: device_height,
              // alignment: AlignmentA,
              child: SingleChildScrollView(
                  controller: _scrollController,
                  // child: Expanded(
                  // height: MediaQuery.of(context).size.height,
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    // Title Container
                    // setTitle(boardData.title),
                    //Date Container
                    setDateNVisitor(boardData.createDate, boardData.watchCount),
                    // FutureBuilder(future:,builder: builder,AsyncSnapshot snapshot){}
                    setBoardContent(),
                    imageContent(),
                    buttonContent(),
                    createCommentListMethod(),

                    commentBoxExpanded(isCommentBoxVisible),
                  ])),
            ),

            commentBoxContainer(),
            TipDialogContainer(
              duration: const Duration(seconds: 2),
            ),
            // )
          ]),
        ));
  }

  Future<void> watchCountUpdate() async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    String _boardID = boardData.boardId.toString();
    String _documentID = boardData.documentId.toString();
    _db
        .collection("Board")
        .doc(_boardID)
        .collection(_boardID)
        .doc(_documentID)
        .update({"watchCount": boardData.watchCount + 1});
  }

  futureBuilderFetchRefreshMethod(
      {String refreshType, bool onlyUnderCommentRefresh, String commentId}) {
    if (refreshType == REFRESH_IMAGE) {
      if (isImageRefresh) {
        _imageMemoizer = AsyncMemoizer();
        isImageRefresh = false;
      }
      return this._imageMemoizer.runOnce(() async {
        return await _fetchData();
      });
    } else if (refreshType == REFRESH_LIKEBUTTON) {
      if (isLikeButtonRefresh) {
        _likeButtonMemoizer = AsyncMemoizer();
        isLikeButtonRefresh = false;
      }
      return this._likeButtonMemoizer.runOnce(() async {
        return await _fetchData();
      });
    } else if (refreshType == REFRESH_COMMENT) {
      if (isCommentRefresh) {
        _commentMemoizer = AsyncMemoizer();
        isCommentRefresh = false;
        _clickedCommentData = ClickedCommentData(
            commentDocumentId: null, isCommentClicked: false);
        _commentMemoizerMapping = {};
      }
      return this._commentMemoizer.runOnce(() async {
        return await _commentFetchDataMethod();
      });
    }
    //  else if (refreshType == REFRESH_UNDERCOMMENT) {
    //   if (isCommentRefresh) {
    //     _underCommentMemoizer = AsyncMemoizer();
    //     isUnderCommentRefresh = false;
    //     _clickedCommentData = ClickedCommentData();
    //     // _underCommentMemoizer = AsyncMemoizer();
    //   }
    //   return this._underCommentMemoizer.runOnce(() async {
    //     return await _fetchDataUnderComment(commentId);
    //   });
    // }
  }

  _fetchDataUnderComment(String commentId) {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    String _boardID = boardData.boardId.toString();
    String _documentID = boardData.documentId.toString();

    return _db
        .collection("Board")
        .doc(_boardID)
        .collection(_boardID)
        .doc(_documentID)
        .collection(COMMENT_COLLECTION_NAME)
        .doc(commentId)
        .collection(COMMENT_COLLECTION_NAME)
        .orderBy("createDate")
        .get();
  }

  _fetchData() {
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

  _commentFetchDataMethod() {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    String _boardID = boardData.boardId.toString();
    String _documentID = boardData.documentId.toString();
    print("documentId " + _documentID);
    print("boardId " + _boardID);
    return _db
        .collection("Board")
        .doc(_boardID)
        .collection(_boardID)
        .doc(_documentID)
        .collection(COMMENT_COLLECTION_NAME)
        // .orderBy("createDate")
        .get();
  }

  _underCommentFutureBuilder(String commentDocumentId) {
    var future;
    if (!_commentMemoizerMapping.containsKey(commentDocumentId)) {
      String key = commentDocumentId;
      AsyncMemoizer asyncMemoizer = AsyncMemoizer();
      var value = asyncMemoizer.runOnce(() async {
        return await _fetchDataUnderComment(commentDocumentId);
      });
      _commentMemoizerMapping.addAll({key: value});
    }
    future = _commentMemoizerMapping[commentDocumentId];

    return FutureBuilder(
      future: future,
      // futureBuilderFetchRefreshMethod(
      //     refreshType: REFRESH_UNDERCOMMENT, commentId: commentDocumentId),
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
                    setState(() {
                      isCommentRefresh = true;
                    });
                  },
                )
              ]));
            } else {
              // bool haveUnderComment = snapshot.data.length != 0;
              return Container(
                  child: _commentContainerMethod(snapshot.data,
                      isUnderComment: true,
                      parentCommentId: commentDocumentId));
            }
        }
      },
    );
  }

  Widget imageContent() {
    return FutureBuilder(
      future: futureBuilderFetchRefreshMethod(refreshType: REFRESH_IMAGE),
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
                    setState(() {
                      isImageRefresh = true;
                    });
                  },
                )
              ]));
            } else {
              return Container(
                child: _setImageContent(snapshot.data),
              );
            }
        }
      },
    );
  }

  Widget buttonContent() {
    return FutureBuilder(
      future: futureBuilderFetchRefreshMethod(refreshType: REFRESH_LIKEBUTTON),
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
                    setState(() {
                      isLikeButtonRefresh = true;
                    });
                  },
                )
              ]));
            } else {
              return Container(child: setScrapAndFavoriteButton(snapshot.data));
            }
        }
      },
    );
  }

  _setImageContent(DocumentSnapshot snapshot) {
    boardContentSnapshot = snapshot.data();
    _imageMap = snapshot.data()["imageCommentList"];
    List<dynamic> _commentList = _imageMap["COMMENT"];
    List<dynamic> _imageURi = _imageMap["IMAGE"];
    // _imageURi.forEach((element) {})
    List<Widget> _imageContainer = [];
    // _commentList.forEach((element) {
    //   print(element);
    // });

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
            Navigator.of(context).pushNamed('/CustomFullViewer',
                arguments: {"INDEX": index, "IMAGES": _imageURi});
          },
          child: Container(
            margin: EdgeInsets.all(10),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.all(10.0), child: _imageList[index]),
                Container(
                    margin: EdgeInsets.only(left: 10, bottom: 5),
                    child: Text(
                      _commentList[index],
                      style: TextStyle(fontSize: 15),
                    ))
              ],
            ),
          )));
    });
    return Column(
      children: _imageContainer,
    );
  }

  Widget setTitle(String title) {
    return GestureDetector(
      onTap: () {
        _scrollController.position
            .moveTo(0.5, duration: Duration(milliseconds: 500));
      },
      child: Container(
        margin: EdgeInsets.only(left: 5),
        width: device_width,
        child: Text(
          title,
          style: new TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          maxLines: 1,
        ),
      ),
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

  Widget setScrapAndFavoriteButton(DocumentSnapshot snapshot) {
    favorite_data = snapshot.data();

    // AnimationController _favoriteAnimationController =
    //     AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    return favorite_data.runtimeType != null
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
                  left: device_width / 40,
                  child: LikeButton(
                    isLiked:
                        favorite_data["favoriteUserList"].contains(currentUID),
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
                    likeCount: favorite_data["favoriteCount"],
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
                  left: device_width * (1 / 5),
                  child: IconButton(
                      padding: EdgeInsets.only(bottom: 0),
                      alignment: Alignment.topCenter,
                      icon: Icon(
                        Icons.near_me_outlined,
                        size: 30,
                      ),
                      onPressed: () {
                        // print("###dt");
                        // print("###" +
                        //     FirebaseApi.getId() +
                        //     "###" +
                        //     boardData.uid.toString() +
                        //     "##board##" +
                        //     boardData.boardId.toString() +
                        //     "###" +
                        //     boardData.documentId.toString());

                        NotificationManager.navigateToBoardChattingRoom(
                          context,
                          FirebaseApi.getId(),
                          boardData.uid,
                          boardData.boardId, //게시판id
                          boardData.documentId, //게시글id
                        );
                      }),
                ),
                //CommentButton
                Positioned(
                  left: device_width * (2 / 5),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isCommentBoxVisible = !isCommentBoxVisible;
                        if (!isCommentBoxVisible)
                          _clickedCommentData.isCommentClicked = false;
                      });
                      _scrollController.position.moveTo(double.infinity,
                          duration: Duration(milliseconds: 500));
                    },
                    padding: EdgeInsets.only(bottom: 0),
                    alignment: Alignment.topCenter,
                    icon: Icon(
                      Icons.add_comment_rounded,
                      color: Colors.yellow,
                      size: 33,
                    ),
                  ),
                ),
                Positioned(
                  left: device_width * (3 / 5),
                  child: IconButton(
                    padding: EdgeInsets.only(bottom: 0),
                    alignment: Alignment.topCenter,
                    icon: Icon(
                      Icons.flag,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                ),

                //Set Scrap Button
                Positioned(
                  left: device_width * (14 / 17),
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

  Future<bool> _clickFavoriteButton(bool isLike) async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    if (!isLike) {
      // print("Like");

      String _boardID = boardData.boardId.toString();
      String _documentID = boardData.documentId.toString();
      _db
          .collection("Board")
          .doc(_boardID)
          .collection(_boardID)
          .doc(_documentID)
          .update({
        "favoriteCount": favorite_data["favoriteUserList"].length + 1,
        "favoriteUserList": favorite_data["favoriteUserList"]
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
        "favoriteCount": favorite_data["favoriteUserList"].length - 1,
        "favoriteUserList": favorite_data["favoriteUserList"]
          ..remove(boardData.uid)
      });
    }
    return !isLike;
  }

  commentBoxContainer() {
    return Visibility(
      visible: isCommentBoxVisible,
      child: Container(
        margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        color: Colors.grey[300],
                        spreadRadius: 5)
                  ]),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          commentBoxHideMethod();
                          _clickedCommentData.isCommentClicked = false;
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          if (_textEditingControllerComment.text == null ||
                              _textEditingControllerComment.text == '') {
                            _scaffoldKey.currentState.showSnackBar(new SnackBar(
                              content: Text("댓글 작성내용이 없습니다."),
                              duration: Duration(seconds: 1),
                            ));
                          } else {
                            if (!_clickedCommentData.isCommentClicked) {
                              commentSaveMethod();
                            } else {
                              _clickedCommentData.isCommentClicked = false;
                              commentSaveMethod(isUnderCommentSave: true);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 100, minHeight: 50),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 10, right: 5),
                      margin: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        maxLines: null,
                        controller: _textEditingControllerComment,
                        decoration: InputDecoration.collapsed(
                            hintText: setCommentHintText(false)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createCommentListMethod() {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    String _boardID = boardData.boardId.toString();
    String _documentID = boardData.documentId.toString();
    print("documentId " + _documentID);
    print("boardId " + _boardID);
    return FutureBuilder(
      future: futureBuilderFetchRefreshMethod(refreshType: REFRESH_COMMENT),
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
                    setState(() {
                      isCommentRefresh = true;
                    });
                  },
                )
              ]));
            } else {
              return _commentContainerMethod(snapshot.data);
            }
        }
      },
    );
  }

  String _commentNameMethod(QuerySnapshot snapshot) {
    List commentList;
    String name = '';
    if (boardContentSnapshot != null) {
      commentList = boardContentSnapshot["commentUserUidList"] ?? [];
      if (commentList.isNotEmpty) {
        for (int i = 0; i < commentList.length; i++) {
          String uid = commentList[i];
          if (uid == currentUID) {
            name = "익명 " + (i + 1).toString();
            break;
          }
        }
      } else
        name = "익명 1";
    }
    return name;
  }

  String _commentCreateTimeMethod(var createTimeStamp) {
    DateTime _convertDateTime = DateTime.fromMicrosecondsSinceEpoch(
        createTimeStamp.microsecondsSinceEpoch);

    String _hhmmss = _convertDateTime.toString().split(' ')[1].split('.')[0];
    String _days;
    if (_convertDateTime.difference(DateTime.now()).inDays.toString() == '0') {
      _days = " 오늘 ";
    } else {
      _days = DateTime(_convertDateTime.year, _convertDateTime.month,
                  _convertDateTime.day)
              .toString()
              .split(' ')[0] +
          ' ';
    }
    return _days + _hhmmss;
  }

  String setCommentHintText(bool isUnderComment, {String who}) {
    return isUnderComment ? who + "의 댓글달기" : "이 글에 댓글달기";
  }

  commentSaveMethod({bool isUnderCommentSave}) async {
    isUnderCommentSave = isUnderCommentSave ?? false;
    if (boardContentSnapshot != null) {
      List commentList = boardContentSnapshot["commentUserUidList"] ?? [];
      if (!commentList.contains(currentUID)) {
        var _db = FirebaseFirestore.instance;
        String _boardID = boardData.boardId.toString();
        String _documentID = boardData.documentId.toString();
        _db
            .collection("Board")
            .doc(_boardID)
            .collection(_boardID)
            .doc(_documentID)
            .update({"commentUserUidList": commentList..add(currentUID)});
      }
    }
    TipDialogHelper.loading("저장 중입니다.\n 잠시만 기다려주세요.");
    String commentText = _textEditingControllerComment.text.trimRight();
    bool result;

    result = await Comment(
            boardDocumentId: boardData.documentId,
            boardId: boardData.boardId,
            text: commentText,
            name: "fix")
        .toFireStore(context,
            isUnderCommentSave: isUnderCommentSave,
            commentDocumentId: _clickedCommentData.commentDocumentId);

    if (result ?? false) {
      TipDialogHelper.dismiss();
      TipDialogHelper.success("저장 완료!");

      setState(() {
        isCommentRefresh = true;
        isCommentBoxVisible = false;
        _textEditingControllerComment.clear();
      });
    }
  }

  commentBoxHideMethod() {
    if (_textEditingControllerComment.text != '') {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('작성 중'),
            content: Text("작성된 내용은 저장이 되지 않습니다."),
            actions: <Widget>[
              FlatButton(
                child: Text('나가기'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    isCommentBoxVisible = false;
                    _textEditingControllerComment.clear();
                  });
                },
              ),
              FlatButton(
                child: Text('유지'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        isCommentBoxVisible = false;
      });
    }
  }

  commentBoxExpanded(bool isCommentBoxVisible) {
    return isCommentBoxVisible
        ? SizedBox(
            child: Container(),
            height: device_height * (1 / 4),
          )
        : SizedBox(height: device_height / 20);
  }

  _commentContainerMethod(QuerySnapshot snapshot,
      {bool isUnderComment, String parentCommentId}) {
    isUnderComment = isUnderComment ?? false;
    int _commentLength = snapshot.size;
    String _commentName = _commentNameMethod(snapshot);
    Widget _commentWidget;
    List<Widget> _commentContainerList = [];
    List widgetList = [];
    //Create Comment Widget

    for (int i = 0; i < _commentLength; i++) {
      widgetList.add(ObjectKey(i));
      var _commentData = snapshot.docs[i];
      bool wasClickedLikeButton = false;
      bool isDeleted = _commentData["isDelete"] ?? false;
      bool deletedWithInDay;
      if (_commentData["favoriteUserList"] !=
          null) if (_commentData["favoriteUserList"].contains(currentUID)) {
        wasClickedLikeButton = true;
      }
      //댓삭튀 방지
      //show Delete Comment if deleted date within today
      //Check deleted date
      if (isDeleted) {
        DateTime _deletedDate = _commentData["deleteDate"].toDate();
        var diffToNow = DateTime.now().difference(_deletedDate);
        deletedWithInDay = diffToNow.inDays < 1;
      }

      bool isItSelf = _commentData["uid"] == FirebaseApi.getId();
      String _createDate = _commentCreateTimeMethod(_commentData["createDate"]);

      bool _clickHighlight = _clickedCommentData.clickedMethod(
            _commentData.id,
          ) ??
          false;
      _commentWidget = GestureDetector(
        onDoubleTap: () {
          setState(() {
            if (!isDeleted) if (isUnderComment) {
              _commentDataUpdateMethod(_commentData, _commentData.id,
                  isLiked: true,
                  isUndo: false,
                  underComment: true,
                  parentCommentId: parentCommentId);
            } else {
              _commentDataUpdateMethod(_commentData, _commentData.id,
                  isLiked: true, isUndo: false, underComment: false);
            }
          });
        },
        onLongPress: isDeleted
            ? () {
                //Show Deleted Comment Text
                DateTime _deletedDate = _commentData["deleteDate"].toDate();
                var diffToNow = DateTime.now().difference(_deletedDate);
                print(diffToNow.inDays);
                if (deletedWithInDay)
                  showGeneralDialog(
                      barrierColor: Colors.black.withOpacity(0.5),
                      transitionBuilder: (context, a1, a2, widget) {
                        return Transform.scale(
                          scale: a1.value,
                          child: Opacity(
                            opacity: a1.value,
                            child: AlertDialog(
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                              content: Text(_commentData["text"]),
                            ),
                          ),
                        );
                      },
                      transitionDuration: Duration(milliseconds: 200),
                      barrierDismissible: true,
                      barrierLabel: '',
                      context: context,
                      pageBuilder: (context, animation1, animation2) {});
              }
            : null,
        onTap: () {
          // print("current isClicked Status " +
          //     _clickedCommentData.isCommentClicked.toString());
          // print("clicked comment id " +
          //     _clickedCommentData.commentDocumentId.toString());
          // print("current CommentData id " + _commentData.id);
          // print("is Correct " +
          //     (_commentData.id == _clickedCommentData.commentDocumentId)
          //         .toString());
          setState(() {
            _clickedCommentData.commentDocumentId = _commentData.id;
            _clickedCommentData.isCommentClicked = true;
          });

          bool isClicked = false;

          //Set BottomSheet
          if (Platform.isAndroid) {
            //Color Change when you click the comment
            setState(() {
              _clickedCommentData.isCommentClicked = true;
            });
            showMaterialModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              builder: (context) => Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                height: device_height / 3,
                child: Column(children: [
                  Container(
                    key: ObjectKey(i),
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                    child: SizedBox(
                      width: device_width / 7,
                      height: device_height / 100,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[400]),
                      ),
                    ),
                  ),
                  //set BottomSheet Button
                  _setCommentButtonMethod(
                      onTap: () {
                        isClicked = true;
                        Navigator.pop(context);
                        setState(() {
                          _clickedCommentData.commentDocumentId =
                              _commentData.id;
                          _clickedCommentData.isCommentClicked = true;
                          isCommentBoxVisible = true;
                        });
                      },
                      text: Text(
                        "댓글 달기",
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      )),
                  _setCommentButtonMethod(
                    text: Text(
                      "채팅 시작하기",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ),
                  _setCommentButtonMethod(
                    onTap: isItSelf
                        ? () {
                            if (!isDeleted) {
                              if (!isUnderComment) {
                                setState(() {
                                  isCommentRefresh = true;
                                  Navigator.pop(context);
                                  _commentDataUpdateMethod(
                                      _commentData, _commentData.id);
                                });
                              } else {
                                setState(() {
                                  isCommentRefresh = true;
                                  Navigator.pop(context);
                                  _commentDataUpdateMethod(
                                      _commentData, _commentData.id,
                                      underComment: true,
                                      parentCommentId: parentCommentId,
                                      isUndo: false);
                                });
                              }
                              //Delete

                            } else {
                              //Already Deleted
                              Navigator.pop(context);
                              Future.delayed(Duration(milliseconds: 1000));
                              _scaffoldKey.currentState
                                  .showSnackBar(new SnackBar(
                                content: Text("이미 삭제된 댓글입니다!"),
                                duration: Duration(seconds: 1),
                              ));
                            }
                          }
                        : null,
                    text: Text(
                      isItSelf ? "삭제하기" : "신고하기",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ),
                ]),
              ),
            ).then((value) {
              setState(() {
                if (!isClicked) _clickedCommentData.isCommentClicked = false;
              });
            });
          } else if (Platform.isIOS) {
            showCupertinoModalBottomSheet(
                context: context, builder: (context) => Container());
          }
        },
        child: Container(
          padding: EdgeInsets.all(5),
          margin: !isUnderComment
              ? EdgeInsets.only(top: 5.0, left: 10, right: 10)
              : EdgeInsets.only(top: 5.0, left: 30),
          decoration: BoxDecoration(
            color: _clickHighlight ? Colors.yellowAccent : Colors.white,
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
          width: device_width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                          child: Text(
                        _commentName,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      )),
                      !isDeleted
                          ? Row(children: [
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Icon(
                                  wasClickedLikeButton
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.redAccent,
                                  size: 15,
                                ),
                              ),
                              Text(_commentData["favoriteCount"].toString())
                            ])
                          : Container()
                    ],
                  ),
                  //Show Comment anonymous name
                  Container(
                    // child: Text(_commentData["createDate"].runtimeType.toString())
                    child: Text(
                      _createDate,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  )
                ],
              ),
              //Show Comment Text
              Container(
                margin: EdgeInsets.only(left: 5),
                child: !isDeleted
                    ? Text(_commentData["text"])
                    : Text(
                        "삭제 된 댓글입니다.",
                        style: TextStyle(
                            //Can See deleted text => blueAccent
                            color: deletedWithInDay
                                ? Colors.blueAccent
                                : Colors.redAccent,
                            fontWeight: FontWeight.bold),
                      ),
              )
            ],
          ),
        ),
      );

      _commentContainerList.add(Column(
        children: [_commentWidget, _underCommentFutureBuilder(_commentData.id)],
      ));
    }

    return Container(
      child: Column(
        children: _commentContainerList,
      ),
    );
  }

  //Comment Alter Method
  _commentDataUpdateMethod(var commentData, String documentId,
      {bool isUndo, bool underComment, String parentCommentId, bool isLiked}) {
    underComment = underComment ?? false;
    isUndo = isUndo ?? false;
    isLiked = isLiked ?? false;
    String _boardID = boardData.boardId.toString();
    String _documentID = boardData.documentId.toString();
    if (!isLiked) {
      if (!underComment) {
        //If NOT underComment
        FirebaseFirestore.instance
            .collection("Board")
            .doc(_boardID)
            .collection(_boardID)
            .doc(_documentID)
            .collection(COMMENT_COLLECTION_NAME)
            .doc(documentId)
            .update({
          "isDelete": !isUndo ? true : false,
          "deleteDate": Timestamp.fromDate(DateTime.now())
        });
      } else {
        //If underComment
        FirebaseFirestore.instance
            .collection("Board")
            .doc(_boardID)
            .collection(_boardID)
            .doc(_documentID)
            .collection(COMMENT_COLLECTION_NAME)
            .doc(parentCommentId)
            .collection(COMMENT_COLLECTION_NAME)
            .doc(documentId)
            .update({
          "isDelete": !isUndo ? true : false,
          "deleteDate": Timestamp.fromDate(DateTime.now())
        });
      }
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: !isUndo ? Text("댓글이 삭제되었습니다.") : Text("되돌리기!"),
        action: !isUndo
            ? SnackBarAction(
                label: "되돌리기",
                onPressed: () {
                  if (!underComment) {
                    _commentDataUpdateMethod(commentData, documentId,
                        isUndo: true);
                    setState(() {
                      isCommentRefresh = true;
                    });
                  } else {
                    _commentDataUpdateMethod(commentData, documentId,
                        isUndo: true,
                        underComment: true,
                        // commentDocumentId: commentDocumentId,
                        parentCommentId: parentCommentId);
                    setState(() {
                      isCommentRefresh = true;
                    });
                  }
                })
            : null,
        duration: Duration(milliseconds: 1500),
      ));
    } else {
      print(commentData["favoriteUserList"].add(currentUID));
      if (!underComment) {
        //If NOT underComment
        FirebaseFirestore.instance
            .collection("Board")
            .doc(_boardID)
            .collection(_boardID)
            .doc(_documentID)
            .collection(COMMENT_COLLECTION_NAME)
            .doc(documentId)
            .update({
          "favoriteCount": commentData["favoriteCount"] + 1,
          "favoriteUserList": commentData["favoriteUserList"]..add(currentUID)
        });
        setState(() {});
      } else {
        //If underComment
        FirebaseFirestore.instance
            .collection("Board")
            .doc(_boardID)
            .collection(_boardID)
            .doc(_documentID)
            .collection(COMMENT_COLLECTION_NAME)
            .doc(parentCommentId)
            .collection(COMMENT_COLLECTION_NAME)
            .doc(documentId)
            .update({
          "favoriteCount": commentData["favoriteCount"] + 1,
          "favoriteUserList": commentData["favoriteUserList"]..add(currentUID)
        });
        setState(() {});
      }
    }
  }

  _setCommentButtonMethod({
    Text text,
    Function onTap,
  }) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          // margin: EdgeInsets.only(top: 10,bottom: 10),
          width: device_width,
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
            color: Colors.grey,
            width: 1,
          ))),
          child: Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Center(child: text ?? Text("")
                // Text(
                //   text ?? "",
                //   style: TextStyle(color: Colors.red, fontSize: 18),
                ),
          ),
        ));
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
    _animationController.dispose();
    _favoriteAnimationController?.dispose();
  }
}

class ClickedCommentData {
  String commentDocumentId;
  bool isCommentClicked = false;
  ClickedCommentData({this.commentDocumentId, this.isCommentClicked});
  bool clickedMethod(String clickedCommentId) {
    if (isCommentClicked != null) if (isCommentClicked) {
      if (commentDocumentId != null) if (commentDocumentId == clickedCommentId)
        return true;
    }
    return false;
  }
}
