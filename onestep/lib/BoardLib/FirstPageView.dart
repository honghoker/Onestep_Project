import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'BoardList.dart';
import 'ListView_Pcs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:swipedetector/swipedetector.dart';
import 'BoardContent.dart';
import 'BoardPersonal.dart';
import 'BoardFloatingButton.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class FirstPageView extends StatefulWidget {
  @override
  FirstPageViewState createState() => FirstPageViewState();
}

class FirstPageViewState extends State<FirstPageView>
    with TickerProviderStateMixin {
  GeneralBoard _generalBoard;
  final RefreshController _refreshController = RefreshController();
  int _previousIndex;
  int selectedIndex = 0;
  ScrollController _scrollController;
  bool _dialVisible = true;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(_scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
  }

  void setDialVisible(bool value) {
    setState(() {
      _dialVisible = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    _generalBoard = new GeneralBoard();
    return Scaffold(
      drawer:
          new Drawer(child: new BoardList(context).buildBoardListView(context)),
      appBar: AppBar(),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 50),
        child: Visibility(
          visible: _dialVisible,
          child: FloatingActionButton(
            onPressed: null,
            child: Icon(Icons.edit),
            // both default to 16
            // marginRight: 18,
            // marginBottom: 20,
            // animatedIcon: AnimatedIcons.menu_close,
            // animatedIconTheme: IconThemeData(size: 22.0),
            // // this is ignored if animatedIcon is non null
            // // child: Icon(Icons.add),

            // // If true user is forced to close dial manually
            // // by tapping main button and overlay is not rendered.
            // closeManually: false,
            // curve: Curves.bounceIn,
            // overlayColor: Colors.black,
            // overlayOpacity: 0.5,
            // onOpen: () => print('OPENING DIAL'),
            // onClose: () => print('DIAL CLOSED'),
            tooltip: 'Speed Dial',
            heroTag: 'speed-dial-hero-tag',
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 8.0,
            shape: CircleBorder(),
          ),
        ),
      ),
      //Custom Refresh indicator widget
      //https://medium.com/flutter-community/how-to-create-your-own-pull-to-refresh-custom-refresh-indicator-widget-in-flutter-a3aa4e8bb42d
      //Refresh method : https://protocoderspoint.com/flutter-pull-to-refresh-using-smartrefresh-library/
      body: testBody(context),
    );
  }

  Widget _dropDownRefresh() {
    return SmartRefresher(
      controller: _refreshController,
      // scrollController: _scrollController,
      enablePullDown: true,
      header: WaterDropMaterialHeader(
        backgroundColor: Colors.grey,
      ),
      onRefresh: () => pullToRefresh(100),
      child: _generalBoard.buildListView(controller: _scrollController),
    );
  }

  void _leftSwipeRedo(BuildContext context) {
    _previousIndex = _generalBoard.previousIndex;
    print('left swipe');
    if (_generalBoard.previousIndex != null) {
      Navigator.of(context).push(CupertinoPageRoute(
          fullscreenDialog: false,
          builder: (context) =>
              BoardStateful(index: _generalBoard.previousIndex)));
    }
  }

  Widget testBody(BuildContext context) {
    return SwipeDetector(
      child: _dropDownRefresh(),
      onSwipeLeft: () => _leftSwipeRedo(context),
      swipeConfiguration: SwipeConfiguration(
          horizontalSwipeMaxHeightThreshold: 10, horizontalSwipeMinVelocity: 0),
    );
  }

  void onItemTapped(int index) {}
  //Pull To Refresh Method
  Future pullToRefresh(var CurrentBoardCode) async {
    await Future.delayed(Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }
}
