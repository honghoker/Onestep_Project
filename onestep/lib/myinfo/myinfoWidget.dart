import 'package:flutter/material.dart';
import 'package:onestep/cloth/providers/myProductProvider.dart';
import 'package:onestep/myinfo/myinfoMyWrite.dart';
import 'package:provider/provider.dart';

class MyinfoWidget extends StatefulWidget {
  @override
  _MyinfoWidgetState createState() => _MyinfoWidgetState();
}

class _MyinfoWidgetState extends State<MyinfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          '내정보',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.account_circle),
                  color: Colors.black,
                  iconSize: 100,
                  onPressed: () {},
                ),
              ),
            ),
            Center(
              child: Container(
                child: Text(
                  "김성훈",
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Container(
                  child: Text(
                    "계명대학교",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications_none),
                        onPressed: () {},
                      ),
                      Text("공지사항"),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.check_circle),
                        onPressed: () {},
                      ),
                      Text("인증"),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {},
                      ),
                      Text("App 설정"),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(60, 10, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("내가 쓴 글"),
                    Padding(
                      padding: const EdgeInsets.only(right: 35.0),
                      child: IconButton(
                        icon: Icon(Icons.keyboard_arrow_right),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Consumer<MyProductProvider>(
                              builder: (context, myProductProvider, _) =>
                                  MyinfoMyWrite(
                                myProductProvider: myProductProvider,
                              ),
                            ),
                          ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(60, 10, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("고객센터"),
                    Padding(
                      padding: const EdgeInsets.only(right: 35.0),
                      child: IconButton(
                        icon: Icon(Icons.keyboard_arrow_right),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(60, 10, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("약관 확인"),
                    Padding(
                      padding: const EdgeInsets.only(right: 35.0),
                      child: IconButton(
                        icon: Icon(Icons.keyboard_arrow_right),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
