import 'package:flutter/material.dart';
import 'package:onestep/notification/login/LoginPage.dart';
import 'googletest.dart';

class NotificationWidget23 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Google Sign-In Demo 오아스 테스트"),
            subtitle: Text("누르면 구글 인증ds"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GoogleSignInDemo2()));
            },
          ),
          ListTile(
            title: Text('기존 정보'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
              //builder: (context) => NotificationWidget()));
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
}
