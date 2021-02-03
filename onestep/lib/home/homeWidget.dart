import 'package:flutter/material.dart';
import 'package:onestep/profile/profileWidget.dart';
import 'package:onestep/search/provider/searchProvider.dart';
import 'package:onestep/search/widget/searchAllWidget.dart';
import 'package:provider/provider.dart';

import 'homeHotBoardBody.dart';
import 'homeNoticeBody.dart';

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
                    builder: (context) => Consumer<SearchProvider>(
                      builder: (context, searchProvider, _) => SearchAllWidget(
                        searchProvider: searchProvider,
                      ),
                    ),
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
                      //   Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => HomeNotificationPage(),
                      // ));
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
                        color: Colors.red,
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
