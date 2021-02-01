import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:onestep/home/homeNotificationPage.dart';

import 'homeHotBoardBody.dart';
import 'homeHotBoardPage.dart';
import 'homeImagesBody.dart';
import 'homeNoticeBody.dart';
import 'homeSearchResultPage.dart';
import 'message/messagePage.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

final List<String> imgList = [
  "https://cdn.pixabay.com/photo/2020/09/01/06/10/lake-5534341__340.jpg",
  "https://cdn.pixabay.com/photo/2019/09/24/09/58/marrakech-4500910__340.jpg",
  "https://cdn.pixabay.com/photo/2019/12/02/07/07/autumn-4667080__340.jpg"
];

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    final double _itemHeight = (_size.height - kToolbarHeight - 24) / 1.9;
    final double _itemWidth = _size.width / 2;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("홈", style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                color: Colors.black,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomeSearchResultPage(),
                  ));
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Stack(children: [
                  IconButton(
                    icon: Icon(Icons.notifications_none),
                    color: Colors.black,
                    onPressed: () {
                       // 알림으로 넘어가는 부분
                        Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomeNotificationPage(),
                      ));
                      // 쪽지 form 보려고 test
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => MessagePage(),
                      // ));
                    },
                  ),
                  Positioned(
                      top: 8,
                      right: 10,
                      child: Icon(
                        Icons.brightness_1,
                        color:Colors.red,
                        size: 15,
                      ))
                ]),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              HomeNoticeBody(),
              HomeHotBoardBody(),
              // HomeImagesBody(_itemWidth, _itemHeight),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeSearchResult {}
