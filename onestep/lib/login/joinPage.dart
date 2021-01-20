import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:onestep/login/AuthPage.dart';

class JoinScreen extends StatefulWidget {
  final String currentUserId;
  const JoinScreen({Key key, this.currentUserId}) : super(key: key);

  @override
  _JoinScreenState createState() =>
      _JoinScreenState(currentUserId: currentUserId);
}

class _JoinScreenState extends State<JoinScreen> {
  final String currentUserId;
  _JoinScreenState({Key key, @required this.currentUserId});

  bool _isNickNameChecked = false;
  bool _isEmailChecked = false;
  bool _isEmailUnderLine = true;
  bool _isNickNameUnderLine = true;
  String tempNickName = "";
  String tempEmail = "";
  var checkPassword;
  TextEditingController emailController;
  TextEditingController nicknameController;

  @override
  void initState() {
    _isNickNameChecked = false;
    _isEmailChecked = false;
    _isEmailUnderLine = true;
    _isNickNameUnderLine = true;

    emailController = TextEditingController(text: tempEmail);
    emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: emailController.text.length));
    nicknameController = TextEditingController(text: tempNickName);
    nicknameController.selection = TextSelection.fromPosition(
        TextPosition(offset: nicknameController.text.length));
    super.initState();
  }

  // 중복확인 firebase db 수정
  // 지금은 db에 있으면 확인완료 뜸
  authEmailNickNameCheck(String text, int flag) async {
    if (flag == 1) {
      _isEmailChecked = false;
      QuerySnapshot ref = await FirebaseFirestore.instance
          .collection('users')
          .where("userEmail", isEqualTo: text)
          .get();

      List<QueryDocumentSnapshot> docRef = ref.docs;

      print("docRef.isEmpty 1 = ${docRef.isNotEmpty}");
      setState(() {
        _isEmailChecked = docRef.isEmpty;
        _isEmailUnderLine = docRef.isEmpty;
        print("docRef.isEmpty 2 = ${docRef.isNotEmpty}");
      });
    } else {
      _isNickNameChecked = false;
      QuerySnapshot ref = await FirebaseFirestore.instance
          .collection('users')
          .where("nickname", isEqualTo: text)
          .get();

      List<QueryDocumentSnapshot> docRef = ref.docs;

      print("docRef.isEmpty 1 = ${docRef.isNotEmpty}");
      setState(() {
        _isNickNameChecked = docRef.isEmpty;
        _isNickNameUnderLine = docRef.isEmpty;
        print("docRef.isEmpty 2 = ${docRef.isNotEmpty}");
      });
    }
  }

  void updateUser(String email, String nickName) {
    FirebaseFirestore.instance
        .collection("users")
        .doc("$currentUserId")
        .update({"userEmail": email, "nickName": nickName});
  }

  Future getRandomNumber() async {
    var _random = Random();
    var numMin = 0x30;
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

  // mail 수정
  sendMail() async {
    // 공용 mail 만들어야함
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("회원가입"),
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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Center(
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
                                        emailController.text, 1);
                                  },
                                )
                              : GestureDetector(
                                  child: Text("중복확인"),
                                  onTap: () {
                                    // 1 -> email, 2 -> nickname
                                    authEmailNickNameCheck(
                                        emailController.text, 1);
                                  },
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                Offstage(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 50, 0),
                    child: Text(
                      "이메일 형식이 잘못되었거나 중복입니다.",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  offstage: _isEmailUnderLine == true ? true : false,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Container(
                    width: 300,
                    child: TextField(
                      controller: nicknameController,
                      onChanged: (text) {
                        tempNickName = text;
                      },
                      decoration: InputDecoration(
                        hintText: "닉네임",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: _isNickNameUnderLine == true
                                    ? Colors.grey
                                    : Colors.red)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: _isNickNameUnderLine == true
                                    ? Colors.grey
                                    : Colors.red)),
                        suffix: _isNickNameChecked
                            ? GestureDetector(
                                child: Text("확인완료"),
                                onTap: () {
                                  authEmailNickNameCheck(
                                      nicknameController.text, 2);
                                },
                              )
                            : GestureDetector(
                                child: Text("중복확인"),
                                onTap: () {
                                  // 1 -> email, 2 -> nickname
                                  authEmailNickNameCheck(
                                      nicknameController.text, 2);
                                },
                              ),
                      ),
                    ),
                  ),
                ),
                Offstage(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 150, 0),
                    child: Text(
                      "닉네임이 중복입니다.",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  offstage: _isNickNameUnderLine == true ? true : false,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Text("학교인증 (선택사항)"),
                      ),
                      Container(
                          width: 100,
                          child: RaisedButton(
                              onPressed: () async {
                                checkPassword = await getRandomNumber();
                                print("password = $checkPassword");
                                // this is send mail
                                // sendMail();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            AuthScreen(
                                                currentUserId,
                                                checkPassword,
                                                DateTime.now()
                                                    .add(Duration(hours: 9)))));
                              },
                              child: Text("하러가기"))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Container(
                    width: 200,
                    // 이메일, 별명 (중복확인까지) 적혀있어야 가입완료 o
                    child: RaisedButton(
                      onPressed: () {
                        // test : email text 공백 아니면 넘어감
                        if (_isEmailChecked == true &&
                            _isNickNameChecked == true) {
                          print("성공");
                          updateUser(
                              emailController.text, nicknameController.text);
                          Navigator.of(context).pushReplacementNamed(
                              '/MainPage?UID=$currentUserId');
                        } else {
                          // 일단 넘어가게해놈
                          print("실패");
                          Navigator.of(context).pushReplacementNamed(
                              '/MainPage?UID=$currentUserId');
                        }
                      },
                      child: Text("가입완료"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
