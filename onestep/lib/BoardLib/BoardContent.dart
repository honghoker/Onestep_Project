import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:like_button/like_button.dart';
import 'package:meta/meta.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'CommentInBoardContent.dart';
import 'package:flutter/animation.dart';
import 'package:tip_dialog/tip_dialog.dart';

final String IOSTHEME = 'IOS';
final String ANDROIDTHEME = 'Android';
final Color POPUP_FAVORITE_BACKGROUND_COLOR = Colors.black.withOpacity(0.1);

class BoardStateful extends StatefulWidget {
  final int index;
  final String boardName;
  BoardStateful({this.index, this.boardName});
  @override
  Board createState() => new Board(index: index, boardName: boardName);
}

class Board extends State<BoardStateful> with TickerProviderStateMixin {
  final int index;
  final String boardName;
  var _onFavoriteClicked;
  //If clicked favorite button, activate this animation
  AnimationController _favoriteAnimationController;
  Animation _favoriteAnimation;
  //index is not null and must have to get index
  TabController _tabcontroller;
  ScrollController _scrollController;
  Board({@required this.index, this.boardName}) : assert(index != null);
  @override
  void initState() {
    super.initState();
    _settingFavoriteAnimation();
    _tabcontroller = TabController(length: 2, vsync: this, initialIndex: 0);
    _onFavoriteClicked = false;
    _scrollController = ScrollController();
  }

  void _settingFavoriteAnimation() {
    //Refer to https://medium.com/flutterdevs/example-animations-in-flutter-2-1034a52f795b
    _favoriteAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));
    _favoriteAnimation = Tween(begin: 70.0, end: 90.0).animate(CurvedAnimation(
        curve: Curves.bounceOut, parent: _favoriteAnimationController));
    _favoriteAnimationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _favoriteAnimationController.dispose();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: <Widget>[
        _boardContent(context),
        TipDialogContainer(
          duration: const Duration(milliseconds: 300),
          maskAlpha: 0,
        )
      ]),
    ));
  }

  Widget _boardContent(BuildContext context) {
    return Container(
      //Dynamic height Size
      height: MediaQuery.of(context).size.height,
      // alignment: AlignmentA,
      child: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(children: <Widget>[
                //Title Container
                _setTitle(),
                //Date Container
                _setDateNVisitor(),
                _setBoardContent(buildcontext: context),
              ]))),
    );
  }

  Widget _setTitle({BuildContext context}) {
    return Container(
      child: Row(children: <Widget>[
        Container(
            margin: EdgeInsets.only(left: 5),
            child: Text('Title',
                maxLines: 1,
                style:
                    new TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))
      ]),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 1))
      ]),
    );
  }

  Widget _setDateNVisitor({BuildContext context}) {
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
                'Date',
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
                'watch',
                style: new TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ],
          )),
    );
  }

  Widget _setBoardContent({@required BuildContext buildcontext}) {
    return Flexible(
      child: Column(
        children: <Widget>[
          Flexible(
            child: Container(
                child: SingleChildScrollView(

                    // controller: controller,
                    // scrollDirection: Axis.vertical,
                    child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  GestureDetector(
                    onDoubleTap: () async => _setPopUpFavoriteIcon(),
                    // _showFavoriteAlertDialog(context);
                    // _favoriteConfirmAnimation(context);

                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.grey, width: 5.0))),
                      child: Text(
                          'abcdefghijklmnopqrstuvwxyzabcdabcdefghijabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzklmnopqrstuvwxyz abcdefghijklmnopqrstuvwxyz abcdefghijklmnopqrstuvwxyz abcdefghijklmnopqrstuvwxyz abcdefghijklmnopqrstuvwxyz efghijklmnopqrstuvwxyzab  cdefghijklmn opqrstuvwxyzabcdefghijklm   opqrstuvwxyzabcd    fghijklmnopqrstuvwxyzabcd   efghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz'),
                    ),
                  ),
                  _setScrapAndFavoriteButton(),
                  Container(
                      child: CommentList(buildcontext).tempCommentContainer())
                  // .commentContainer())
                ],
              ),
            ))),
          ),
        ],
      ),
    );
  }

  Future<bool> _scrollPosition(bool isLiked) async {
    _scrollController.attach(_scrollController.position);

    return !isLiked;
  }

  Widget _setScrapAndFavoriteButton() {
    // AnimationController _favoriteAnimationController =
    //     AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    return Container(
        padding: EdgeInsets.only(left: 7.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //Set Favorite Button
            LikeButton(
              // onTap: _scrollPosition,
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
            //Set Scrap Button
            LikeButton(
              padding: EdgeInsets.only(left: 20),
              size: 30,
              circleColor: CircleColor(start: Colors.grey, end: Colors.yellow),
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
              likeCount: 665,
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
          ],
        ));
  }

  Future _onDropDownRefresh(
      {@required RefreshController refreshController}) async {
    await Future.delayed(Duration(seconds: 1));
    _favoriteAnimationController?.dispose();
    refreshController.refreshCompleted();
  }

  Future _setPopUpFavoriteIcon() async {
    TipDialogHelper.show(
        tipDialog: new TipDialog.builder(bodyBuilder: (context) {
      return new Container(
          color: POPUP_FAVORITE_BACKGROUND_COLOR,
          width: 90,
          height: 90,
          alignment: Alignment.center,
          child: Icon(
            Icons.favorite,
            size: 90,
            color: Colors.red,
          ));
    }));
  }

  @override
  void dispose() {
    super.dispose();
    _favoriteAnimationController?.dispose();
  }
}
