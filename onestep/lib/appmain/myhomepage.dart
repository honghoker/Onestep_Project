import 'package:flutter/material.dart';
import 'package:onestep/cloth/clothWidget.dart';
import 'package:onestep/cloth/providers/productProvider.dart';
import 'package:onestep/home/homeWidget.dart';
import 'package:onestep/myinfo/myinfoWidget.dart';
import 'package:onestep/notification/chatpage/chatMainPage.dart';
import 'package:provider/provider.dart';
import 'package:onestep/BoardLib/boardMain.dart';
import 'package:onestep/appmain/tapNavigationItem.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({Key key});

  int _currentIndex;

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  static DateTime currentBackPressTime;

  @override
  initState() {
    _currentIndex = 0;
    super.initState();
  }

//   final List<Widget> _bottomWidgetList = [
//     HomeWidget(),
//     Consumer<ProuductProvider>(
//       builder: (context, productProvider, _) => ClothWidget(
//         productProvider: productProvider,
//       ),
//     ),
//     Boardmain(),
// //    NotificationMain(),
//     ChatMainPage(),
//     MyinfoWidget(),
//   ];

  // Widget getBottomBar() {
  //   return BottomNavigationBar(
  //     currentIndex:
  //         _bottombarindex, // this will be set when a new tab is tapped
  //     onTap: (int index) {
  //       setState(() {
  //         this._bottombarindex = index;
  //       });
  //     },
  //     type: BottomNavigationBarType.fixed,
  //     showSelectedLabels: false,
  //     showUnselectedLabels: false, // title 안보이게 설정
  //     items: [
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.home,
  //             color: _bottombarindex == 0 ? Colors.pink : Colors.black),
  //         title: Text('홈'),
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.shopping_cart,
  //             color: _bottombarindex == 1 ? Colors.pink : Colors.black),
  //         title: Text('장터'),
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.list,
  //             color: _bottombarindex == 2 ? Colors.pink : Colors.black),
  //         title: Text('게시판'),
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.notifications_none,
  //             color: _bottombarindex == 3 ? Colors.pink : Colors.black),
  //         title: Text('알림'),
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.person_outline,
  //             color: _bottombarindex == 4 ? Colors.pink : Colors.black),
  //         title: Text('내정보'),
  //       )
  //     ],
  //   );
  // }

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
    return SafeArea(
      child: WillPopScope(
          child: Scaffold(
            key: _globalKey,
            body: IndexedStack(
              index: _currentIndex,
              children: [
                for (final tabItem in TabNavigationItem.items) tabItem.page,
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              fixedColor: Colors.pink,
              currentIndex: _currentIndex,
              onTap: (int index) => setState(() => _currentIndex = index),
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false, // title 안보이게 설정
              items: [
                for (final tabItem in TabNavigationItem.items)
                  BottomNavigationBarItem(
                    icon: tabItem.icon,
                    title: tabItem.title,
                  )
              ],
            ),
          ),
          onWillPop: () async {
            bool result = isEnd();
            return await Future.value(result);
          }),
    );
  }
}
