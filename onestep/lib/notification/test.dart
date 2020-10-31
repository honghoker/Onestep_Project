import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onestep/notification/login/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'googletest.dart';

class NotificationWidget23 extends StatelessWidget {
  SharedPreferences preferences;
  final GoogleSignIn googleSignIn = GoogleSignIn();

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
        ].map((child) {
          return Card(
            child: child,
          );
        }).toList(),
      ),
    );
  }

  void changePreferences() async {
    preferences = await SharedPreferences.getInstance();
    preferences.setString('id', '바꿈 ㅎ');
    print('preferences test 저장 완료.');
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
}
