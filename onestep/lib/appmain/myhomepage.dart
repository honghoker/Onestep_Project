import 'package:flutter/material.dart';
import 'package:onestep/cloth/clothWidget.dart';
import 'package:onestep/cloth/providers/productProvider.dart';
import 'package:onestep/home/homeWidget.dart';
import 'package:onestep/myinfo/myinfoWidget.dart';
import 'package:onestep/notification/chatpage/chatMainPage.dart';
import 'package:provider/provider.dart';
import 'package:onestep/BoardLib/boardMain.dart';
import 'package:onestep/notification/ChatCountProvider/chatCount.dart';
import 'package:onestep/notification/Controllers/firebaseChatController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onestep/api/firebase_api.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

  int _bottombarindex;

  @override
  initState() {
    _bottombarindex = 0;
    super.initState();
  }

  final List<Widget> _bottomWidgetList = [
    HomeWidget(),
    Consumer<ProuductProvider>(
      builder: (context, productProvider, _) => ClothWidget(
        productProvider: productProvider,
      ),
    ),
    Boardmain(),
//    NotificationMain(),
    ChatMainPage(),
    MyinfoWidget(),
  ];

  Widget getBottomBar(BuildContext context) {
    final chatCount = Provider.of<ChatCount>(context); //카운트 프로바이더
    return BottomNavigationBar(
      currentIndex:
          _bottombarindex, // this will be set when a new tab is tapped
      onTap: (int index) {
        setState(() {
          this._bottombarindex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false, // title 안보이게 설정
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home,
              color: _bottombarindex == 0 ? Colors.pink : Colors.black),
          title: Text('홈'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart,
              color: _bottombarindex == 1 ? Colors.pink : Colors.black),
          title: Text('장터'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list,
              color: _bottombarindex == 2 ? Colors.pink : Colors.black),
          title: Text('게시판'),
        ),
        BottomNavigationBarItem(
          title: Text("알림"),
          icon:
              // Stack(
              //   children: [
              //     new Icon(
              //       Icons.notifications_none,
              //       size: 25,
              //       color: Colors.black,
              //     ),
              //     Positioned(
              //       top: 1,
              //       right: 1,
              //       child: Stack(
              //         children: [
              //           FirebaseChatController().getAllChatCount(),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              FirebaseChatController().getChatBottomBar(),
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.notifications_none,
        //       color: _bottombarindex == 3 ? Colors.pink : Colors.black),
        //   title: Text('알림'),
        // ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline,
              color: _bottombarindex == 4 ? Colors.pink : Colors.black),
          title: Text('내정보'),
        )
      ],
    );
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  static DateTime currentBackPressTime;

  bool isEnd() {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      _globalKey.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text("한번더 누르면 종료"),
        ));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          // appbar 삭제
          // appBar: AppBar(
          //   title: Text(
          //     "",
          //     // currentUserId,
          //     textScaleFactor: 0.9,
          //   ),
          // ),
          key: _globalKey,
          body: _bottomWidgetList[_bottombarindex],
          bottomNavigationBar: getBottomBar(context),
        ),
        onWillPop: () async {
          bool result = isEnd();
          return await Future.value(result);
        });
  }
}
