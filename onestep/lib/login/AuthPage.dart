import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:onestep/home/sendMail.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

bool _timeOver;

// ignore: must_be_immutable
class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    print('animation.value  ${animation.value} ');
    // timer 0초
    if (animation.value == 0) {
      _timeOver = true;
    }
    // print('inMinutes ${clockTimer.inMinutes.toString()}');
    // print('inSeconds ${clockTimer.inSeconds.toString()}');
    // print(
    //     'inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');

    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 15,
        color: Colors.red,
      ),
    );
  }
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  String checkPassword;
  bool _isEmailChecked = false;
  bool _isEmailErrorUnderLine = true;
  bool _isEmailDupliCheckUnderLine = true;
  bool _isSendUnderLine = true;
  String tempEmail = "";
  bool _isAuthNumber = true;
  bool _isTimeOverChecked = true;
  bool _isTimerChecked = false;
  bool _isSendClick = false;

  TextEditingController emailController;
  AnimationController _controller;
  int levelClock = 10;

  _AuthScreenState();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController(text: tempEmail);
    emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: emailController.text.length));
    levelClock = 10;
    _controller = AnimationController(
        duration: Duration(seconds: levelClock),
        vsync:
            this // gameData.levelClock is a user entered number elsewhere in the applciation
        );

    _timeOver = false;
    // _isTimerChecked = false;
  }

  void updateAuth() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseApi.getId())
        .update({"userUniversityEmail": true});
  }

  Future getRandomNumber() async {
    var _random = Random();
    var numMin = 0x30;
    // var numMax = 0x39;
    // var charMin = 0x41;
    var charMax = 0x5A;
    var skipCharacter = [0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F, 0x40];
    var checkNumber = [];

    while (checkNumber.length <= 6) {
      var tmp = numMin + _random.nextInt(charMax - numMin);
      // skip 안됌..
      if (skipCharacter.contains(skipCharacter)) {
        continue;
      }
      checkNumber.add(tmp);
    }
    return String.fromCharCodes(checkNumber.cast<int>());
  }

  authEmailNickNameCheck(String text) async {
    _isEmailChecked = false;
    QuerySnapshot ref = await FirebaseFirestore.instance
        .collection('users')
        .where("userUniversityEmail", isEqualTo: text)
        .get();

    List<QueryDocumentSnapshot> docRef = ref.docs;

    if (text.contains("@stu.kmu.ac.kr") && docRef.isEmpty) {
      setState(() {
        _isEmailChecked = true;
        _isEmailErrorUnderLine = true;
        _isEmailDupliCheckUnderLine = true;
        _isEmailDupliCheckUnderLine = true;
        _isSendUnderLine = true;

        _isTimerChecked = false;
        _controller.reset();
      });
    } else {
      setState(() {
        _isEmailErrorUnderLine = false;
        _isEmailDupliCheckUnderLine = true;
        _isSendUnderLine = true;

        _isTimerChecked = false;
        _isSendClick = false;
        _controller.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // CheckAuth checkAuth = Provider.of<CheckAuth>(context);
    final _myController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("학교인증"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "OneStep 과 함께",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Container(
                    child: Text(
                      "즐거운 대학생활을",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Container(
                    child: Text(
                      "지금 바로 RUN",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Container(
                  child: Text("학교 off365 email을 적어주세요"),
                ),
              ),
            ),
            Center(
              child: Container(
                child: Text("ex) 학번@stu.kmu.ac.kr"),
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: 300,
                      child: TextField(
                        controller: emailController,
                        onChanged: (text) {
                          tempEmail = text;
                        },
                        decoration: InputDecoration(
                          hintText: "이메일",
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: (_isEmailErrorUnderLine == false ||
                                          _isEmailDupliCheckUnderLine == false)
                                      ? Colors.red
                                      : Colors.grey)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: (_isEmailErrorUnderLine == false ||
                                          _isEmailDupliCheckUnderLine == false)
                                      ? Colors.red
                                      : Colors.grey)),
                          suffix: _isEmailChecked
                              ? GestureDetector(
                                  child: Text("확인완료"),
                                  onTap: () {
                                    authEmailNickNameCheck(
                                        emailController.text);
                                  },
                                )
                              : GestureDetector(
                                  child: Text("중복확인"),
                                  onTap: () {
                                    authEmailNickNameCheck(
                                        emailController.text);
                                  },
                                ),
                        ),
                      ),
                    ),
                  ),
                  Offstage(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text(
                          "이메일 형식이 잘못되었거나 중복입니다.",
                          style: TextStyle(color: Colors.red),
                        )),
                    offstage: _isEmailErrorUnderLine == true ? true : false,
                  ),
                  Offstage(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text(
                          "이메일 중복확인을 해주세요.",
                          style: TextStyle(color: Colors.red),
                        )),
                    offstage:
                        _isEmailDupliCheckUnderLine == true ? true : false,
                  ),
                  Offstage(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text(
                          "인증번호가 메일로 전송되었습니다.",
                          style: TextStyle(color: Colors.grey),
                        )),
                    offstage: _isSendUnderLine == true ? true : false,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Container(
                      width: 300,
                      child: _isSendClick == false
                          ? RaisedButton(
                              onPressed: () async {
                                checkPassword = await getRandomNumber();
                                print("checkPassword = $checkPassword");
                                if (_isEmailChecked == true) {
                                  setState(() {
                                    _isSendUnderLine = false;
                                    _isEmailErrorUnderLine = true;
                                    _isEmailDupliCheckUnderLine = true;
                                    _isTimerChecked = true;

                                    _isAuthNumber = true;
                                    _isTimeOverChecked = true;
                                    _isSendClick = true;
                                  });
                                  // sendMail(1,checkPassword,emailController.text);
                                  _controller.forward();
                                } else {
                                  setState(() {
                                    _isEmailDupliCheckUnderLine = false;
                                    _isSendUnderLine = true;
                                    _isEmailErrorUnderLine = true;
                                  });
                                }
                              },
                              child: Text("전송"),
                            )
                          : RaisedButton(
                              color: Colors.black,
                              onPressed: () {},
                              child: Text("전송"),
                            ),
                    ),
                  ),
                  Container(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextField(
                        controller: _myController,
                        decoration: InputDecoration(
                          hintText: "인증번호",
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: (_isAuthNumber == false ||
                                          _isTimeOverChecked == false)
                                      ? Colors.red
                                      : Colors.grey)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: (_isAuthNumber == false ||
                                          _isTimeOverChecked == false)
                                      ? Colors.red
                                      : Colors.grey)),
                          isDense: true,
                          suffixIconConstraints:
                              BoxConstraints(minWidth: 0, minHeight: 0),
                          suffixIcon: _isTimerChecked
                              ? Countdown(
                                  animation: StepTween(
                                    begin:
                                        levelClock, // THIS IS A USER ENTERED NUMBER
                                    end: 0,
                                  ).animate(_controller),
                                )
                              : Text(""),
                        ),
                      ),
                    ),
                  ),
                  Offstage(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Text(
                        "잘못된 인증번호입니다.",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    offstage: _isAuthNumber == true ? true : false,
                  ),
                  Offstage(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Text(
                        "제한시간이 경과하였습니다.",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    offstage: _isTimeOverChecked == true ? true : false,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: Container(
                      width: 300,
                      child: RaisedButton(
                        onPressed: () async {
                          checkPassword = await getRandomNumber();
                          setState(() {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    title: Column(
                                      children: <Widget>[
                                        new Text(""),
                                      ],
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Center(
                                          child: _isEmailChecked == true
                                              ? Text(
                                                  "인증번호가 재전송 되었습니다.",
                                                )
                                              : Text("이메일 중복확인을 해주세요."),
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      _isEmailChecked == true
                                          ? FlatButton(
                                              child: Text("확인"),
                                              onPressed: () {
                                                setState(() {
                                                  _isSendClick = true;
                                                  _isTimeOverChecked = true;
                                                  _isAuthNumber = true;
                                                  _timeOver = false;
                                                  levelClock = 10;
                                                  _controller = AnimationController(
                                                      duration: Duration(
                                                          seconds: levelClock),
                                                      vsync:
                                                          this // gameData.levelClock is a user entered number elsewhere in the applciation
                                                      );

                                                  _controller.forward();
                                                });
                                                Navigator.pop(context);
                                              },
                                            )
                                          : FlatButton(
                                              child: Text("확인"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                    ],
                                  );
                                });
                            // sendMail(1,checkPassword,emailController.text);
                          });
                        },
                        child: Text("재전송"),
                      ),
                    ),
                  ),
                  Container(
                    width: 300,
                    child: RaisedButton(
                      onPressed: () {
                        // 5분 안에 인증해야함
                        if (_timeOver == false &&
                            checkPassword == _myController.text) {
                          print("성공");
                          // checkAuth.successAuth();
                          // updateAuth();
                          // Navigator.of(context).pop();
                        } else if (_timeOver == true) {
                          print("time over 실패");
                          setState(() {
                            _isTimeOverChecked = false;
                            _isAuthNumber = true;
                          });
                          // print("${snapshot.data.data()['authTest']}");
                          // Navigator.of(context).pop();
                        } else {
                          print("인증번호 매칭 실패");
                          setState(() {
                            _isTimeOverChecked = true;
                            _isAuthNumber = false;
                          });
                        }
                      },
                      child: Text("인증"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
