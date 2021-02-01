import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:rxdart/rxdart.dart';

class HomeNotificationPage extends StatefulWidget {
  @override
  _HomeNotificationPageState createState() => _HomeNotificationPageState();
}

Stream<QuerySnapshot> mergedStream;

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

final makeBody = Container(
  child: StreamBuilder(
      stream: combineStream(),
      builder: (context, snapshot) {
        if (snapshot.data == null) return new Text(""); // 이거 안넣어주면 오류남

        // 현재는 documentSnapshot 요게 sort 부분이 없는데 최신순으로 정렬되어있음
        // 지금 documentSnapshot1 이 최근글이 밑으로 가는 정렬이라서
        // 나중에 documentSnapshot1 요부분 sort 변경
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
            return b.compareTo(a);
          });
        documentSnapshot1.forEach((f) {
          print("@@@@@ f1 ${f.data()['time']}");
        });

        print(documentSnapshot1.toString());

        List<Map<String, dynamic>> mappedData = [];
        for (QueryDocumentSnapshot doc in documentSnapshot) {
          mappedData.add(doc.data());
        }

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container();
          default:
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: mappedData.length,
              itemBuilder: (BuildContext context, int index) {
                return makeCard(mappedData, index);
              },
            );
        }
      }),
);

makeCard(List<Map<String, dynamic>> mappedData, int index) {
  return Card(
    elevation: 8.0,
    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(color: Colors.grey[400]),
      child: makeListTile(mappedData, index),
    ),
  );
}

makeListTile(List<Map<String, dynamic>> mappedData, int index) {
  return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Icon(Icons.autorenew, color: Colors.white),
      ),
      title: Text(
        "Introduction to Driving",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: <Widget>[
              // Icon(Icons.linear_scale, color: Colors.yellowAccent),
              Text(" Intermediate", style: TextStyle(color: Colors.white))
            ],
          ),
          Text("${mappedData[index]['notiTitle']}",
              style: TextStyle(color: Colors.white))
        ],
      ),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0));
}

class _HomeNotificationPageState extends State<HomeNotificationPage> {
  @override
  void initState() {
    super.initState();
    // _testB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("알림", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: makeBody,
    );
  }
}
