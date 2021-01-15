import 'package:flutter/material.dart';
import '../notificationMain copy.dart';

class ScrollableTabsDemo extends StatefulWidget {
  static const String routeName = '/material/scrollable-tabs';
  ScrollableTabsDemoState createState() => ScrollableTabsDemoState();
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

class ScrollableTabsDemoState extends State<ScrollableTabsDemo>
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
    final Color iconColor = Theme.of(context).accentColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scrollable tabs'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),

          ///Note: Here I assigned 40 according to me. You can adjust this size acoording to your purpose.
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 4,
                    color: Color(0xFF000000),
                  ),
                  insets: EdgeInsets.only(left: 0, right: 8, bottom: 4)),
              controller: _controller,
              isScrollable: true,
              labelPadding: EdgeInsets.only(left: 8, right: 0),
              tabs: _allPages.map<Tab>((_Page page) {
                return Tab(text: page.text, icon: Icon(page.icon));
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
                        ? NotificationMain2()
                        : Center(child: Text(position.toString())));
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
