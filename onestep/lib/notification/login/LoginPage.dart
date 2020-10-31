import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onestep/appmain/myhomepage.dart';
import 'package:onestep/notification/login/ProgressWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences preferences;

  bool isLoggedIn = false;
  bool isLoading = false;
  User currentUser;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoggedIn = true;
    });

    preferences = await SharedPreferences.getInstance();

    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(
              currentUserId: currentUser.uid,
            ),
          ));
    }
    Fluttertoast.showToast(msg: 'uid 상단' + currentUser.uid);
    print('uid 상단' + currentUser.uid);
    this.setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.lightBlueAccent, Colors.white],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Onestep project Reboot',
              style: TextStyle(
                  fontSize: 42.0, color: Colors.white, fontFamily: "Signatra"),
            ),
            GestureDetector(
              onTap: controlSignIn,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 270,
                      height: 65.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/images/google_signin_button.png"),
                          //fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: isLoading ? circularProgress() : Container(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Null> controlSignIn() async {
    preferences = await SharedPreferences.getInstance();
    this.setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    final User firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    //Signin Sucess
    if (firebaseUser != null) {
      final QuerySnapshot resultQuery = await Firestore.instance
          .collection("users")
          .where("id", isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documentSnapshots = resultQuery.documents;

      if (documentSnapshots.length == 0) {
        Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .setData({
          "nickname": firebaseUser.displayName,
          "photoUrl": firebaseUser.photoURL,
          "id": firebaseUser.uid,
          "aboutMe": "저장",
          "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
          "chattingWith": null,
        });
      } else {
        //Write data to Local
        currentUser = firebaseUser;
        await preferences.setString("id", documentSnapshots[0]["id"]);
        await preferences.setString(
            "nickname", documentSnapshots[0]["nickname"]);
        await preferences.setString(
            "photoUrl", documentSnapshots[0]["photoUrl"]);
        await preferences.setString("aboutMe", documentSnapshots[0]["aboutMe"]);
      }
      Fluttertoast.showToast(msg: "로그인 완료");
      print('##9 로그인 완료');

      this.setState(() {
        isLoading = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(
              currentUserId: firebaseUser.uid,
            ),
          ));
      Fluttertoast.showToast(msg: 'uid 하단' + currentUser.uid);
      print('uid 하단' + currentUser.uid);
    }
    //Signin Not Success - signin Failed
    else {
      print('##10 로그인 실패');
      Fluttertoast.showToast(msg: '로그인 실패');
      this.setState(() {
        isLoading = false;
      });
    }
  }
}
