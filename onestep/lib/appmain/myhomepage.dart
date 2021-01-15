import 'package:flutter/material.dart';
import 'package:onestep/cloth/clothWidget.dart';
import 'package:onestep/cloth/providers/productProvider.dart';
import 'package:onestep/home/homeWidget.dart';
import 'package:onestep/myinfo/myinfoWidget.dart';
import 'package:onestep/notification/chatpage/productsChatPage.dart';
import 'package:onestep/notification/notificationMain.dart';
import 'package:provider/provider.dart';
import 'package:onestep/BoardLib/boardMain.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({Key key});

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
    BoardMain(),
//    NotificationMain(),
    ScrollableTabsDemo(),
    MyinfoWidget(),
  ];

  Widget getBottomBar() {
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
          icon: Icon(Icons.notifications_none,
              color: _bottombarindex == 3 ? Colors.pink : Colors.black),
          title: Text('알림'),
        ),
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
          key: _globalKey,
          body: _bottomWidgetList[_bottombarindex],
          bottomNavigationBar: getBottomBar(),
        ),
        onWillPop: () async {
          bool result = isEnd();
          return await Future.value(result);
        });
  }
}
