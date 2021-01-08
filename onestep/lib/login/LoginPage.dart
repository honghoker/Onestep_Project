import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onestep/appmain/myhomepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'ProgressWidget.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences preferences; //내부 키벨류저장

  bool isLoggedIn = false;
  bool isLoading = false;
  User currentUser;

  @override
  void initState() {
    super.initState();
    isSignedIn();
    print('로그인 초기상태 1 ' + isLoggedIn.toString());
  }

  void isSignedIn() async {
    this.setState(() {
      isLoggedIn = true;
      print('로그인 상태 반환0 ' + isLoggedIn.toString());
    });

    preferences = await SharedPreferences.getInstance();
    print('로그인 상태 반환1 ' + isLoggedIn.toString());
    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      print('로그인 상태 반환2 ' + isLoggedIn.toString());
      Navigator.push(
          context,
          MaterialPageRoute(
            //builder: (context) => NotificationWidget23(),
            builder: (context) => MyHomePage(
              //currentUserId: 'test',
              currentUserId: preferences.getString('id') ?? '아이디없음',
            ),
          ));
    } else {
      //Fluttertoast.showToast(msg: '안된답니다~' + currentUser.uid);
    }
    //Fluttertoast.showToast(msg: 'uid 상단' + currentUser.uid);
    //print('uid 상단' + currentUser.uid);
    this.setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white
          // gradient: LinearGradient(
          //   begin: Alignment.topRight,
          //   end: Alignment.bottomLeft,
          //   colors: [Colors.lightBlueAccent, Colors.white],
          // ),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(top: 130),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Onestep',
                style: TextStyle(
                    fontSize: 42.0, color: Colors.black, fontFamily: "Signatra",fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 130),
                child: GestureDetector(
                  onTap: controlSignIn,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 330,
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
                ),
              )
            ],
          ),
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

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    final User firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    //Signin Sucess
    if (firebaseUser != null) {
      print('파이어베이스는 널이 아니야' + firebaseUser.uid);
      final QuerySnapshot resultQuery = await FirebaseFirestore.instance
          .collection("users")
          .where("id", isEqualTo: firebaseUser.uid)
          .get();
      final List<DocumentSnapshot> documentSnapshots = resultQuery.docs;

      if (documentSnapshots.length == 0) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .set({
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
