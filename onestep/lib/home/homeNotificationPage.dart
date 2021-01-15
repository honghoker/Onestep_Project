import 'package:flutter/material.dart';

class HomeNotificationPage extends StatefulWidget {
  @override
  _HomeNotificationPageState createState() => _HomeNotificationPageState();
}

class _HomeNotificationPageState extends State<HomeNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("알림", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          child: Text("알림"),
        ),
      ),
    );
  }
}
