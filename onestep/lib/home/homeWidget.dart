import 'package:flutter/material.dart';
import 'package:onestep/home/homeNotificationPage.dart';
import 'package:onestep/moor/moor_database.dart';
import 'package:onestep/search/provider/searchProvider.dart';
import 'package:onestep/search/widget/searchAllWidget.dart';
import 'package:provider/provider.dart';

import 'homeHotBoardBody.dart';
import 'homeNoticeBody.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    NotificationChksDao p =
        Provider.of<AppDatabase>(context).notificationChksDao;
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
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomeNotificationPage(),
                      ));
                      // 쪽지 form 보려고 test
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => MessagePage(),
                      // ));
                    },
                  ),
                  StreamBuilder(
                      stream: p.watchNotificationAll(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Positioned(
                              top: 8,
                              right: 10,
                              child: Icon(
                                  // check 다 했으면 아이콘이 없는 쪽으로 코드 변경
                                  null),
                            );

                          default:
                            bool chk = true;
                            if (snapshot.data != null) {
                              List<NotificationChk> notiList = snapshot.data;
                              chk = notiList.isEmpty;
                            }
                            return Positioned(
                              top: 8,
                              right: 10,
                              child: chk
                                  ? Container()
                                  : Icon(
                                      Icons.brightness_1,
                                      color: Colors.red,
                                      size: 15,
                                    ),
                            );
                        }
                      }),
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
