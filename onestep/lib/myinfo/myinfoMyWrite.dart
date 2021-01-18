import 'package:flutter/material.dart';

class MyinfoMyWrite extends StatefulWidget {
  @override
  _MyinfoMyWriteState createState() => _MyinfoMyWriteState();
}

class _MyinfoMyWriteState extends State<MyinfoMyWrite> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("내가 쓴 글"),
          backgroundColor: Colors.white,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  "장터",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  "게시판",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: TabBarView(
            children: [
              Center(
                child: Text("장터", style: TextStyle(color: Colors.black)),
              ),
              Center(
                  child: Text(
                "게시판",
                style: TextStyle(color: Colors.black),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
