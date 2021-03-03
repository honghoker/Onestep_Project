import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:like_button/like_button.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:flutter/animation.dart';
import 'package:onestep/notification/Controllers/chatNavigationManager.dart';
import 'package:tip_dialog/tip_dialog.dart';
import 'package:onestep/BoardLib/BoardProvi/boardClass.dart';

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
  Animation _favoriteAnimation;
  //index is not null and must have to get index

  ScrollController _scrollController;
  Map<String, dynamic> _imageMap = {};
  @override
  void initState() {
    super.initState();
    boardData = widget.boardData;
    // _settingFavoriteAnimation();

    _onFavoriteClicked = false;
    _scrollController = ScrollController();
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
              imageContent(),
              setBoardContent()
            ])),
        // ),
        // ),
        TipDialogContainer(
          duration: const Duration(milliseconds: 400),
          maskAlpha: 0,
        )
      ]),
    ));

    // if (snapshot.connectionState == ConnectionState.none) {
    //   return Center(
    //       child: Text("데이터 불러오기에 실패하였습니다. 네트워크 연결상태를 확인하여 주십시오."));
    // } else if (snapshot.hasData) {
    //   return Center(child: Text("데이터가 없습니다."));
    // }
  }

  _getImageContent() async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    return _db
        .collection("Board")
        .doc(boardData.boardId.toString())
        .collection(boardData.boardId.toString())
        .snapshots()
        .map((list) => list.docs
            .map((doc) => ImageContentComment.fromFireStore(doc))
            .toList());
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
              return Container(
                  child: Text(_getImageContent != null ? "Hi" : "hello"));
            }
        }
      },
    );
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
          margin: EdgeInsets.only(top: 5),
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
    return _setScrapAndFavoriteButton();
    // return Flexible(
    //   child: Column(
    //     children: <Widget>[
    //       Flexible(
    //         child: Container(
    //             child: SingleChildScrollView(

    //                 // controller: controller,
    //                 // scrollDirection: Axis.vertical,
    //                 child: Container(
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.stretch,
    //             children: <Widget>[
    //               GestureDetector(
    //                 onDoubleTap: () async => _setPopUpFavoriteIcon(),
    //                 // _showFavoriteAlertDialog(context);
    //                 // _favoriteConfirmAnimation(context);

    //                 child: Container(
    //                   decoration: BoxDecoration(
    //                       border: Border(
    //                           bottom:
    //                               BorderSide(color: Colors.grey, width: 5.0))),
    //                   child: Text('s'),
    //                 ),
    //               ),
    //               _setScrapAndFavoriteButton(),
    //               // Container(child: CommentList().tempCommentContainer())
    //               // .commentContainer())
    //             ],
    //           ),
    //         ))),
    //       ),
    //     ],
    //   ),
    // );
  }

  // _scrollPosition(bool isLiked) async {
  //   _scrollController.attach(_scrollController.position);

  //   // return !isLiked;
  // }

  Widget _setScrapAndFavoriteButton() {
    double width = MediaQuery.of(context).size.width;
    // AnimationController _favoriteAnimationController =
    //     AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    return Container(
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
                // onTap: () {
                //   // _scrollPosition();
                // },
                size: 30,
                circleColor: CircleColor(start: Colors.grey, end: Colors.red),
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
                likeCount: 999,
                countBuilder: (int count, bool isLiked, String text) {
                  var color = isLiked ? Colors.red[900] : Colors.grey;
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

                    ChatNavigationManager.navigateToBoardChattingRoom(
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

        );
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
