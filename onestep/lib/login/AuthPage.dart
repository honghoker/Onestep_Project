import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:onestep/login/CheckAuth.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  String currentUserId;
  String checkPassword;
  DateTime sendTime;
  AuthScreen(this.currentUserId, this.checkPassword, this.sendTime);

  @override
  _AuthScreenState createState() =>
      _AuthScreenState(currentUserId, checkPassword, sendTime);
}

class _AuthScreenState extends State<AuthScreen> {
  String checkPassword;
  String currentUserId;
  DateTime sendTime;
  bool _isEmailChecked = false;
  bool _isEmailUnderLine = true;
  String tempEmail = "";
  bool _isAuthNumber = true;
  bool _isEmailDupliCheck = false;

  _AuthScreenState(this.currentUserId, this.checkPassword, this.sendTime);

  TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: tempEmail);
    emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: emailController.text.length));
  }

  // 지금 보니 안써도 될거 같은데 나중에 확인
  Stream<DocumentSnapshot> get _a {
    return FirebaseFirestore.instance
        .collection('users')
        .doc("$currentUserId")
        .snapshots();
  }

  // db 수정
  void updateAuth() {
    FirebaseFirestore.instance
        .collection('users')
        .doc("$currentUserId")
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

  sendMail() async {
    String _username = 'leedool3003@gmail.com';
    String _password = 'alstjsdl421!';

    final _smtpServer = gmail(_username, _password);

    final message = Message()
      ..from = Address(_username)
      ..recipients.add(
          '5414030@stu.kmu.ac.kr') // 받는사람 email -> 계명대 @stu.kmu.ac.kr 인지 확인해서 보내는 예외처리 해야함
      // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      // ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject =
          'Test Dart Mailer library :: 😀 :: ${DateTime.now().add(Duration(hours: 9))}' // title
      // ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html =
          "<h1>Test</h1>\n<p>Hey! Here's some $checkPassword</p>\n본 인증 코드는 5분동안 유효합니다. "; // body of the email

    try {
      // final sendReport = await send(message, _smtpServer,timeout: Duration(hours: 60));
      final sendReport = await send(message, _smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
    // var connection = PersistentConnection(_smtpServer);
    // await connection.send(message);
    // connection.close();
  }

  //
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
        _isEmailUnderLine = true;
        _isEmailDupliCheck = true;
      });
    } else {
      setState(() {
        _isEmailUnderLine = false;
        _isEmailDupliCheck = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CheckAuth checkAuth = Provider.of<CheckAuth>(context);
    final _myController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("학교인증"),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
            stream: _a,
            builder: (context, snapshot) {
              return Column(
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
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("학교 off365 email을 적어주세요"),
                          ),
                          Container(
                            child: Text("ex) 학번@stu.kmu.ac.kr"),
                          ),
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
                                          color: _isEmailUnderLine == true
                                              ? Colors.grey
                                              : Colors.red)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: _isEmailUnderLine == true
                                              ? Colors.grey
                                              : Colors.red)),
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
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15, 50, 0),
                                child: Text(
                                  "이메일 형식이 잘못되었거나 중복입니다.",
                                  style: TextStyle(color: Colors.red),
                                )),
                            offstage: _isEmailUnderLine == true ? true : false,
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Container(
                              width: 300,
                              child: RaisedButton(
                                onPressed: () async {
                                  checkPassword = await getRandomNumber();
                                  if (_isEmailChecked == true) {
                                    setState(() {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
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
                                                  child: Text(
                                                    "인증번호가 메일로 전송되었습니다",
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: <Widget>[
                                              new FlatButton(
                                                child: new Text("확인"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                      // sendMail();
                                      // sendTime = DateTime.now()
                                      //     .add(Duration(hours: 9));
                                    });
                                  } else {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
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
                                                  child: Text(
                                                    "이메일 중복확인을 해주세요",
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: <Widget>[
                                              new FlatButton(
                                                child: new Text("확인"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                },
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
                                          color: _isAuthNumber == true
                                              ? Colors.grey
                                              : Colors.red)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: _isAuthNumber == true
                                              ? Colors.grey
                                              : Colors.red)),
                                ),
                              ),
                            ),
                          ),
                          Offstage(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 150, 0),
                              child: Text(
                                "잘못된 인증번호입니다.",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            offstage: _isAuthNumber == true ? true : false,
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
                                                    BorderRadius.circular(
                                                        10.0)),
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
                                                  child: Text(
                                                    "인증번호가 재전송 되었습니다.",
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: <Widget>[
                                              new FlatButton(
                                                child: new Text("확인"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                    // sendMail();
                                    // sendTime =
                                    //     DateTime.now().add(Duration(hours: 9));
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
                                if (DateTime.now()
                                        .add(Duration(hours: 9))
                                        .isBefore(sendTime
                                            .add(Duration(minutes: 5))) &&
                                    checkPassword == _myController.text) {
                                  print("성공");
                                  // checkAuth.successAuth();
                                  // updateAuth();
                                  // Navigator.of(context).pop();
                                } else {
                                  print("실패");
                                  setState(() {
                                    _isAuthNumber = false;
                                  });
                                  // print("${snapshot.data.data()['authTest']}");
                                  // Navigator.of(context).pop();
                                }
                              },
                              child: Text("인증"),
                            ),
                          ),

                          // Container(
                          //   child: Text(""),
                          // )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
