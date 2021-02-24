import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestep/home/noticeDetailView.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "공지사항",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('notice')
              .orderBy('time', descending: true)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Container();
              default:
                return Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: ListView(
                    // QureySnapshot -> Document 데이터 접근할 때 이런식으로
                    children: snapshot.data.docs.map((DocumentSnapshot doc) {
                      Timestamp tempTime = doc.data()['time'];
                      return InkWell(
                        onTap: () {
                          print("doc id = ${doc.id}");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  NoticeDetailView("Notice", doc.id)));
                        },
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(doc.data()['title']),
                              subtitle: Text(
                                  DateTime.parse(tempTime.toDate().toString())
                                      .toString()),
                            ),
                            Divider(
                              height: 0,
                              thickness: 2,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
            }
          },
        ));
  }
}
