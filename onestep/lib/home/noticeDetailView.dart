import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoticeDetailView extends StatefulWidget {
  final String docId;
  final String flag;

  const NoticeDetailView([this.flag, this.docId]);

  @override
  _NoticeDetailViewState createState() => _NoticeDetailViewState(flag, docId);
}

class _NoticeDetailViewState extends State<NoticeDetailView> {
  String docId;
  String flag;
  _NoticeDetailViewState(this.flag, this.docId);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder(
          // Notice -> 공지사항 상세뷰
          // Notification -> 알림 상세뷰
          future: flag == "Notice"
              ? FirebaseFirestore.instance.collection("notice").doc(docId).get()
              : FirebaseFirestore.instance
                  .collection("notification")
                  .doc(docId)
                  .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Container();
              default:
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            child: Image.asset('images/onestep icon.png'),
                            width: 70,
                            height: 70,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text("one step"),
                              ),
                              Container(
                                child: Text(
                                    "${DateTime.parse(snapshot.data.data()['time'].toDate().toString()).toString()}"),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Container(child: Text("content")),
                      ),
                    ],
                  ),
                );
            }
          },
        ));
  }
}
