import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "쪽지 보내기",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          FlatButton(
            onPressed: () {
              // sendMail();
            },
            child: Text("보내기"),
          )
        ],
      ),
      body: Center(child: Container(child: Text("쪽지"))),
    );
  }
}
