import 'dart:async';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:onestep/moor/moor_database.dart';
import 'package:provider/provider.dart';
import 'package:moor_flutter/moor_flutter.dart' as mf;

class HomeNotificationPage extends StatefulWidget {
  @override
  _HomeNotificationPageState createState() => _HomeNotificationPageState();
}

Stream<QuerySnapshot> mergedStream;
ScrollController _scrollController = ScrollController();

// 공지 (알림) -> notiEntire true (전체공지) or userUid 으로 판별하는 개인알림
Stream<List<QuerySnapshot>> combineStream() {
  Stream a = FirebaseFirestore.instance
      .collection('notification')
      .where('userUid', isEqualTo: FirebaseApi.getId())
      .snapshots();
  Stream b = FirebaseFirestore.instance
      .collection('notification')
      .where('notiEntire', isEqualTo: true)
      .snapshots();
  return StreamZip([a, b]);
}

class _HomeNotificationPageState extends State<HomeNotificationPage> {
  @override
  void initState() {
    super.initState();
    // keepScrollOffset
    // _scrollController.keepScrollOffset
    // _scrollController.addListener(() {
    //   print('offset = ${_scrollController.offset}');
    // });
  }

  NotificationCheck notification;

  makeBody(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // print("click");
      },
      child: StreamBuilder(
          stream: combineStream(),
          builder: (context, snapshot) {
            if (snapshot.data == null) return new Text(""); // 이거 안넣어주면 오류남

            // 현재는 documentSnapshot 요게 sort 부분이 없는데 최신순으로 정렬되어있음
            // 지금 documentSnapshot1 이 최근글이 밑으로 가는 정렬이라서
            // 나중에 documentSnapshot1 요부분 sort 변경 -> 해결
            List<DocumentSnapshot> documentSnapshot = [];
            List<dynamic> querySnapshot = snapshot.data.toList();
            querySnapshot.forEach((query) {
              documentSnapshot.addAll(query.docs);
            });
            documentSnapshot.forEach((f) {
              print("@@@@@ f ${f.data()['time']}");
            });

            List<DocumentSnapshot> documentSnapshot1 = [];
            documentSnapshot1 = documentSnapshot.toList()
              ..sort((key1, key2) {
                Timestamp a = key2.data()['time'];
                Timestamp b = key1.data()['time'];
                return a.compareTo(b);
              });
            documentSnapshot1.forEach((f) {
              print("@@@@@ f1 ${f.data()['time']}");
            });

            print(documentSnapshot1.toString());

            List<Map<String, dynamic>> mappedData = [];
            for (QueryDocumentSnapshot doc in documentSnapshot1) {
              mappedData.add(doc.data());
              // print("doc = ${doc.id}");
            }

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Container();
              default:
                return ListView.builder(
                  key: PageStorageKey("any_text_here"),
                  scrollDirection: Axis.vertical,
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: mappedData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return makeCard(mappedData, index,
                        documentSnapshot1[index].id, context);
                  },
                );
            }
          }),
    );
  }

  makeCard(List<Map<String, dynamic>> mappedData, int index, String id,
      BuildContext context) {
    NotificationChecksDao p =
        Provider.of<AppDatabase>(context).notificationChecksDao;
        print(id);
    return StreamBuilder<mf.QueryRow>(
        stream: p.watchsingleNotificationCheck(id),
        builder: (context, snapshot) {
          // print(snapshot.hasData ? "sex" : "cex");
          print("@@@@@@@@@@@ makecard");
          return Card(
            elevation: 8.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                  // 전체공지거나 읽은 알림은 회색, 안읽은 개인 알림은 검은색
                  // color: (mappedData[index]['notiChecked'] == true ||
                  //         mappedData[index]['notiEntire'] == true)
                  color: snapshot.hasData ? Colors.black : Colors.grey[400]),
              child: makeListTile(mappedData, index, id, context),
            ),
          );
        });
  }

  makeListTile(List<Map<String, dynamic>> mappedData, int index, String id,
      BuildContext context) {
    NotificationChecksDao p =
        Provider.of<AppDatabase>(context).notificationChecksDao;
    return StreamBuilder<mf.QueryRow>(
        stream: p.watchsingleNotificationCheck(id),
        builder: (context, snapshot) {
          return GestureDetector(
            onTap: () {
              print("snapshot.hasData = ${snapshot.hasData}}");
              if (!snapshot.hasData) {
                notification = NotificationCheck(docId: id);
                p.insertNotificationCheck(notification);
                print("sex ${snapshot.hasData}");
                // FirebaseFirestore.instance
                //     .collection("notification")
                //     .doc("$id")
                //     .update({
                //   "notiChecked": true,
                // });
                // setState(() {});
                // print("click = $id}");
              } else {
                print("전체공지 Click");
              }
              print("click = $id}");
              // 상세 공지 (알림) form 으로 이동
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => NotificationPage(),
              // ));
              // setState(() {});
            },
            child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                leading: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: BoxDecoration(
                      border: Border(
                          right:
                              BorderSide(width: 1.0, color: Colors.white24))),
                  child: Icon(Icons.autorenew, color: Colors.white),
                ),
                title: Text(
                  "${mappedData[index]['notiTitle']}",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: <Widget>[
                        // Icon(Icons.linear_scale, color: Colors.yellowAccent),
                        Text("${mappedData[index]['notiContent']}",
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                    Text(
                        "${DateTime.parse(mappedData[index]['time'].toDate().toString())}",
                        style: TextStyle(color: Colors.white))
                  ],
                ),
                trailing: Icon(Icons.keyboard_arrow_right,
                    color: Colors.white, size: 30.0)),
          );
        });
  }

  // final _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      appBar: AppBar(
        title: Text("알림", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: makeBody(context),
    );
  }
}
