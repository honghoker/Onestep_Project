import 'package:flutter/material.dart';
import 'package:onestep/notification/ChatCountProvider/chatCount.dart';
import 'package:onestep/notification/Chatpage/ProductChatPage/productChatPage.dart';
import 'package:onestep/notification/Controllers/productChatController.dart';
import 'package:onestep/notification/Controllers/boardChatController.dart';
import 'package:provider/provider.dart';

import 'package:badges/badges.dart';

import 'RealTimePage/realtimePage.dart';

class ChatMainPage extends StatefulWidget {
  static const String routeName = '/material/scrollable-tabs';
  @override
  ChatMainPageState createState() => ChatMainPageState();
}

class _Page {
  const _Page({this.icon, this.text});
  final IconData icon;
  final String text;
}

const List<_Page> _allPages = <_Page>[
  _Page(
    icon: Icons.chat,
    text: '장터게시판',
  ),
  _Page(icon: Icons.post_add, text: '일반게시판'),
  // _Page(icon: Icons.check_circle, text: 'SUCCESS'),
];

class ChatMainPageState extends State<ChatMainPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: _allPages.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatCount = Provider.of<ChatCount>(context); //카운트 프로바이더
    print("chat main");
    chatCount.initChatCount();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(150, 150, 150, 1),
        title: Text(
          'Scrollable tabs ' +
              "chat main" +
              chatCount.getProductChatCount().toString() +
              chatCount.getBoardChatCount().toString(),
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),

          ///Note: Here I assigned 40 according to me. You can adjust this size acoording to your purpose.
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 4,
                    color: Color.fromRGBO(248, 247, 77, 1),
                  ),
                  insets: EdgeInsets.only(left: 0, right: 8, bottom: 4)),
              controller: _controller,
              isScrollable: true,
              labelPadding: EdgeInsets.only(left: 8, right: 0),
              tabs: _allPages.map<Tab>((_Page page) {
                print("####### ${page.text}");
                return Tab(
                  text: page.text,
                  icon: page.text == "장터게시판"
                      ? Badge(
                          toAnimate: true,
                          borderRadius: BorderRadius.circular(80),
                          badgeColor: Colors.red,
                          badgeContent:
                              ProductChatController().getProductCountText(),
                          child: Icon(page.icon,
                              color: Color.fromRGBO(248, 247, 77, 1)),
                        )
                      : Badge(
                          toAnimate: true,
                          borderRadius: BorderRadius.circular(80),
                          badgeColor: Colors.red,
                          badgeContent:
                              BoardChatController().getBoardCountText(),
                          child: Icon(page.icon,
                              color: Color.fromRGBO(169, 215, 254, 1)),
                        ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: _allPages.map<Widget>((_Page page) {
          return SafeArea(
            top: false,
            bottom: false,
            child: PageView.builder(
              itemBuilder: (context, position) {
                return Container(
                    child: (position == 0 && page.text == '장터게시판')
                        ? ProductChatPage()
                        :
                        //BoardChatPage()
                        //Text("ㄱㄷ")
                        RealTimePage());
              },
              itemCount: 1,
              // onPageChanged: (page) {
              //   if (page == _allPages.length &&
              //       (_controller.index + 1) < _controller.length) {
              //     _controller.animateTo(_controller.index + 1);
              //   }
              // },
              //itemCount: _allPages.length + 1,
            ),
          );
        }).toList(),
      ),
    );
  }
}
