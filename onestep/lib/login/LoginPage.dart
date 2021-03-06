import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:onestep/appmain/myhomepage.dart';
import 'package:onestep/notification/Controllers/loginController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'ProgressWidget.dart';
import 'joinPage.dart';

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

//        "id": userUid,
//         "nickname": userName,
// //        "photoUrl": userImageFile,
//         "authUniversity": "",
//         "userLevel": 1, // 0: BAN / 1: GUEST / 2:AUTHENTIFICATION USER
//         "userScore": 100, //장터 평가, 유저 신고 점수 , 100 이하일 경우 불량 유저
//         "userUniversity": "", //universityID
//         "userUniversityEmail": "", //학교인증 이메일
//         "userEmail": "", //User Email
//         "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),

    preferences = await SharedPreferences.getInstance();
    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      // var arg = preferences.getString('id') ?? '아이디없음';
      var arg = FirebaseApi.getId();
//      var arg = preferences.getString('id') ?? '아이디없음';
      // 이거 살려야함
      Navigator.of(context).pushReplacementNamed('/MainPage?UID=$arg');

//       var arg = firebaseAuth.currentUser.uid;
// //      var arg = preferences.getString('id') ?? '아이디없음';

//       // 로그인 성공
//       // Navigator.of(context).pushReplacementNamed('/MainPage?UID=$arg');

//       // 회원가입으로
      // Navigator.of(context).pushNamed('/JoinPage?UID=$arg');

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       //builder: (context) => NotificationWidget23(),
      //       builder: (context) => MyHomePage(
      //         //currentUserId: 'test',
      //         currentUserId: preferences.getString('id') ?? '아이디없음',
      //       ),
      //     ));
    } else {
      //Fluttertoast.showToast(msg: '안된답니다~' + currentUser.uid);
    }
    this.setState(() {
      isLoading = false;
    });

    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      throw UnimplementedError();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white
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
                    fontSize: 42.0,
                    color: Colors.black,
                    fontFamily: "Signatra",
                    fontWeight: FontWeight.bold),
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
      print("### s SS");
      final QuerySnapshot resultQuery = await FirebaseFirestore.instance
          .collection("users")
          .where("id", isEqualTo: firebaseUser.uid)
          .get();
      final List<DocumentSnapshot> documentSnapshots = resultQuery.docs;

      if (documentSnapshots.length == 0) {
        LoginController.instanace.saveUserInfoToFirebaseStorage(
            firebaseUser.uid,
            firebaseUser.displayName,
            //firebaseUser.photoURL,
            DateTime.now().millisecondsSinceEpoch.toString());
        // FirebaseFirestore.instance
        //     .collection("users")
        //     .doc(firebaseUser.uid)
        //     .set({
        //                 "id": firebaseUser.uid,
        //   "nickname": firebaseUser.displayName,
        //   "photoUrl": firebaseUser.photoURL,
        //   "aboutMe": "저장",
        //   "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),

        // });
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

      // Fluttertoast.showToast(msg: "로그인 완료");
      Fluttertoast.showToast(
          msg: "userlevel = ${documentSnapshots[0]["userLevel"]}");

      this.setState(() {
        isLoading = false;
      });
      
      // // 회원가입으로 넘어가는 navigator
      // Navigator.of(context).pushNamed('/JoinPage?UID=${firebaseUser.uid}');

      // // 찬섭이형 예시 코드 여기 확인
      // // Navigator.of(context)
      // //     .pushReplacementNamed('/MainPage?UID=${firebaseUser.uid}');

      // userLevel 이 0 이면 회원가입으로 1 이면 이미 회원가입 완료한 사람
      if (documentSnapshots[0]["userLevel"] == 0) {
        // 회원가입으로 넘어가는 navigator
        Navigator.of(context).pushNamed('/JoinPage?UID=${firebaseUser.uid}');
      } else {
        // 메인으로 넘어감
        Navigator.of(context)
            .pushReplacementNamed('/MainPage?UID=${firebaseUser.uid}');

        // 회원가입 작업하려고 잠시 회원가입창으로 이거 지워야함
        // Navigator.of(context).pushNamed('/JoinPage?UID=${firebaseUser.uid}');
      }

      Fluttertoast.showToast(msg: 'uid 하단' + currentUser.uid);
    }
    //Signin Not Success - signin Failed
    else {
      Fluttertoast.showToast(msg: '로그인 실패');
      this.setState(() {
        isLoading = false;
      });
    }
  }
}
