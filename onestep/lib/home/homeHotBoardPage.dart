import 'package:flutter/material.dart';

class HomeHotBoardPage extends StatefulWidget {
  @override
  _HomeHotBoardPageState createState() => _HomeHotBoardPageState();
}

class _HomeHotBoardPageState extends State<HomeHotBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text("Hot 게시물"),
      ),
      body: Center(
        child: Container(
          child: Text("HotBoardPage"),
        ),
      ),
    );
  }
}