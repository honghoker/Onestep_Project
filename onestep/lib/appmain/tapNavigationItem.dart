import 'package:flutter/material.dart';
import 'package:onestep/BoardLib/Boardmain.dart';
import 'package:onestep/cloth/clothWidget.dart';
import 'package:onestep/cloth/providers/productProvider.dart';
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
          page: Consumer<ProuductProvider>(
            builder: (context, productProvider, _) => ClothWidget(
              productProvider: productProvider,
            ),
          ),
          icon: Icon(Icons.shopping_cart),
          title: Text("장터"),
        ),
        TabNavigationItem(
          page: Boardmain(),
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
