import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;

  HomeScreen({Key key, @required this.currentUserId}) : super(key: key);

  @override
  _HomeScreenState createState() =>
      _HomeScreenState(currentUserId: currentUserId);
}

class _HomeScreenState extends State<HomeScreen> {
  final String currentUserId;

  _HomeScreenState({Key key, @required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentUserId),
      ),
      body: (RaisedButton.icon(
        onPressed: logoutUser,
        icon: Icon(Icons.close),
        label: Text("Sign Out 바로뜨면 안됨@@"),
      )),
    );
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<Null> logoutUser() async {
    print('##로그아웃 버튼 누름');
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
        (Route<dynamic> route) => false);
  }
}

class UserResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {}
}
