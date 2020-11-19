import 'package:flutter/material.dart';

class HomeSearchResultPage extends StatefulWidget {
  @override
  _HomeSearchResultPageState createState() => _HomeSearchResultPageState();
}

class _HomeSearchResultPageState extends State<HomeSearchResultPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text("장터"),
              ),
              Tab(
                child: Text("게시판"),
              ),
            ],
          ),
          title: Text("home search"),
        ),
        body: TabBarView(
          children: [
            Center(child: Text("장터")),
            Center(child: Text("게시판")),
          ],
        ),
      ),
    );
  }
}
