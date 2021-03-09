import 'package:flutter/material.dart';
import 'package:onestep/BoardLib/BoardProvi/boardProvider.dart';
import 'package:onestep/BoardLib/Boardmain.dart';
import 'package:onestep/cloth/clothAllWidget.dart';
import 'package:onestep/cloth/providers/allProductProvider.dart';

import 'package:onestep/home/homeWidget.dart';
import 'package:onestep/myinfo/myinfoWidget.dart';
import 'package:onestep/notification/chatpage/chatMainPage.dart';
import 'package:provider/provider.dart';

class TabNavigationItem {
  final Widget page;
  final Widget title;
  final Icon icon;

  TabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });

  static List<TabNavigationItem> get items => [
        TabNavigationItem(
          page: HomeWidget(),
          icon: Icon(Icons.home),
          title: Text("홈"),
        ),
        TabNavigationItem(
          page: Consumer<AllProuductProvider>(
            builder: (context, allProductProvider, _) => ClothAllWidget(
              allProductProvider: allProductProvider,
            ),
          ),
          icon: Icon(Icons.shopping_cart),
          title: Text("장터"),
        ),
        TabNavigationItem(
          page: Consumer<BoardProvider>(
            builder: (context, boardProvider, _) => Boardmain(
              boardProvider: boardProvider,
            ),
          ),
          icon: Icon(Icons.list),
          title: Text("게시판"),
        ),
        TabNavigationItem(
          page: ChatMainPage(),
          icon: Icon(Icons.notifications_none),
          title: Text("알림"),
        ),
        TabNavigationItem(
          page: MyinfoWidget(),
          icon: Icon(Icons.person_outline),
          title: Text("내정보"),
        ),
      ];
}
