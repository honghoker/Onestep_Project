import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'googletest.dart';
import 'package:async/async.dart' show StreamGroup;

class NotificationWidget23 extends StatelessWidget {
  SharedPreferences preferences;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  final _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("로그아웃"),
            subtitle: Text("로그아웃 현재 id 출력"),
            onTap: () {
              logoutandGetPreferences(context);
            },
          ),
          ListTile(
            title: Text('변경'),
            onTap: () {
              changePreferences();
            },
          ),
          ListTile(
            title: Text('임시저장'),
            onTap: save,
          )
        ].map((child) {
          return Card(
            child: child,
          );
        }).toList(),
      ),
    );
  }

  void logoutandGetPreferences(context) async {
    preferences = await SharedPreferences.getInstance();
    String a = preferences.getString('id');
    print('preferences test 불러오기.' + a);

    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
        (Route<dynamic> route) => false);
  }

  void changePreferences() async {
    preferences = await SharedPreferences.getInstance();
    preferences.setString('id', '바꿈 ㅎ');
    print('preferences test 저장 완료.');
    //test();
    //getData();
    //test3();
    test4();
  }

  Future<int> getValue({int delay, int value}) =>
      Future.delayed(Duration(seconds: delay), () => Future.value(value));

  void test() {
    final f1 = getValue(delay: 0, value: 1);
    final f2 = getValue(delay: 0, value: 2);
    final f3 = getValue(delay: 0, value: 3);
    final f4 = getValue(delay: 0, value: 4);

    Future.wait([f1, f2, f3, f4])
        .then((value) => print('@@' + value.toString()));
  }

  void getData() async {
    print("@@async test");
    List<Stream<QuerySnapshot>> streams = [];
    final someCollection = Firestore.instance.collection("tests");
    var firstQuery = someCollection.where('a').snapshots();
    print("@@async q1 ");

    var secondQuery = someCollection.where('b').snapshots();
    print("@@async q2" + secondQuery.toString());
    streams.add(firstQuery);
    streams.add(secondQuery);

    Stream<QuerySnapshot> results = StreamGroup.merge(streams);
    await for (var res in results) {
      res.documents.forEach((docResults) {
        print(docResults.data);
        print("@@async 반복 : " + res.toString());
      });
    }
  }

  void test3() {
    // String title = "";
    // _firestore
    //     .collection("books")
    //     .document("on_intelligence")
    //     .get()
    //     .then((DocumentSnapshot ds) {
    //   title = ds.get('title');
    //   print(title);
    // });
    //삭제 부분인데 전체임
    print('@@ tests 전체 출력');
    Firestore.instance.collection('tests').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        print(ds.reference);
      }
    });
    print('@@ tests 전체 출력 완료');
  }

  Map<String, String> d;

  // Map<String, dynamic> user = jsonDecode(jsonString);

  // print('Howdy, ${user['name']}!');
  // print('We sent the verification link to ${user['email']}.');

  void test4() async {
    print('@@ test4 실행');

    // Firestore.instance.collection('test2').getDocuments().then((snapshot) {
    //   for (DocumentSnapshot ds in snapshot.documents) {
    //     print('@@ test4 2   2323: ' + ds.data().toString());
    //     //d = ds.data();
    //     //ds.reference.delete();
    //   }
    //   print('@@ test4 실행 종료');
    // });

    print('@ 스트림 합치기 시작.');
    List<Stream<QuerySnapshot>> streams = [];
    final someCollection = Firestore.instance.collection("chattest");

    var secondsQuery =
        someCollection.where('송신자', isEqualTo: '수명김').snapshots();
    streams.add(secondsQuery);

    var firstQuery = someCollection.where('수신자', isEqualTo: '수명김').snapshots();
    streams.add(firstQuery);

    Stream<QuerySnapshot> results = StreamGroup.merge(streams);
    AsyncSnapshot<QuerySnapshot> results2;

    List<DocumentSnapshot> documents = results2.data.documents;

    await for (var res in results) {
      res.documents.forEach((docResults) {
        print("@@스트림 결과  반복1 : " + docResults.data().toString());
        //print("@@스트림 결과  반복 : " + docResults.data.toString());
      });
    }
  }

  void save() {
    print('@@저장완료.');
    //ignore: deprecated_member_use
    _firestore
        .collection('chattest')
        .document(DateTime.now().millisecondsSinceEpoch.toString())
        // ignore: deprecated_member_use
        .setData({
      '송신자': '수명김',
      '수신자': '아이시스',
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }
}
