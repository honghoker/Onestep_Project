import 'package:flutter/material.dart';
import 'package:onestep/BoardLib/Boardmain.dart';
import 'package:onestep/cloth/clothWidget.dart';
import 'package:onestep/community/communityWidget.dart';
import 'package:onestep/home/homeWidget.dart';
import 'package:onestep/myinfo/myinfoWidget.dart';
import 'package:onestep/notification/test.dart';

class MyHomePage extends StatefulWidget {
  final String currentUserId;

  MyHomePage({Key key, @required this.currentUserId}) : super(key: key);

  @override
  _MyHomePageState createState() =>
      _MyHomePageState(currentUserId: currentUserId);
}

class _MyHomePageState extends State<MyHomePage> {
  final String currentUserId;

  _MyHomePageState({Key key, @required this.currentUserId});

  int _bottombarindex;

  @override
  initState() {
    _bottombarindex = 0;
    super.initState();
  }

  final List<Widget> _bottomWidgetList = [
    HomeWidget(),
    ClothWidget(),
    BoardMain(),
    NotificationWidget23(),
    MyinfoWidget(),
  ];

  Widget getBottomBar() {
    return BottomNavigationBar(
      currentIndex:
          _bottombarindex, // this will be set when a new tab is tapped
      onTap: (int index) {
        setState(() {
          this._bottombarindex = index;
          print(this._bottombarindex);
          print('##겟 바텀바');

          if (index == 3) {
            print('message');
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
      appBar: AppBar(
        title: Text(
          currentUserId,
          textScaleFactor: 0.9,
        ),
      ),
      body: _bottomWidgetList[_bottombarindex],
      bottomNavigationBar: getBottomBar(),
    );
  }
}
