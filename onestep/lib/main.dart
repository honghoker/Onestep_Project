import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'BoardLib/Boardmain.dart';
import 'cloth/clothWidget.dart';
import 'community/communityWidget.dart';
import 'home/homeWidget.dart';
import 'myinfo/myinfoWidget.dart';
import 'notification/notificationWidget.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _bottombarindex;

  @override
  initState() {
    _bottombarindex = 0;

    super.initState();
  }

  final List<Widget> _bottomWidgetList = [
    HomeWidget(),
    ClothWidget(),
    CommunityWidget(),
    NotificationWidget(),
    MyinfoWidget(),
  ];

  Widget getBottomBar() {
    return BottomNavigationBar(
      currentIndex:
          _bottombarindex, // this will be set when a new tab is tapped
      onTap: (int index) {
        setState(() {
          this._bottombarindex = index;
          print('$index');
          if (index == 2) {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    fullscreenDialog: false,
                    builder: (context) => BoardState()));
          }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bottomWidgetList[_bottombarindex],
      bottomNavigationBar: getBottomBar(),
    );
  }
}
