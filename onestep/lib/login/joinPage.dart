import 'package:flutter/material.dart';

class JoinScreen extends StatefulWidget {
  final String currentUserId;

  const JoinScreen({Key key, this.currentUserId}) : super(key: key);
  @override
  _JoinScreenState createState() =>
      _JoinScreenState(currentUserId: currentUserId);
}

class Email {
  int id;
  String email;

  Email(this.id, this.email);

  static List<Email> getEmailList() {
    return <Email>[
      Email(1, '@naver.com'),
      Email(2, '@hanmail.net'),
      Email(3, '@gmail.com'),
      Email(4, '@abcd.com'),
      Email(5, '@korea.com')
    ];
  }
}

class _JoinScreenState extends State<JoinScreen> {
  final String currentUserId;
  _JoinScreenState({Key key, @required this.currentUserId});

  List<Email> _emailList = Email.getEmailList();
  List<DropdownMenuItem<Email>> _dropdownEmailList;
  Email _selectedEmail;
  bool _isNickNameChecked = false;
  bool _isEmailChecked = false;
  String tempNickName = "";
  String tempEmail = "";

  @override
  void initState() {
    _dropdownEmailList = buildDropdownMenuItems(_emailList);
    _selectedEmail = _dropdownEmailList[0].value;
    _isNickNameChecked = false;
    _isEmailChecked = false;

    super.initState();
  }

  List<DropdownMenuItem<Email>> buildDropdownMenuItems(List emails) {
    List<DropdownMenuItem<Email>> items = List();
    for (Email email in emails) {
      items.add(DropdownMenuItem(
        value: email,
        child: Text(email.email),
      ));
    }
    return items;
  }

  onChangeDropdwonItem(Email selectedEmail) {
    setState(() {
      _selectedEmail = selectedEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController;
    TextEditingController nicknameController;

    @override
    void initState() {
      _isNickNameChecked = false;
      _isEmailChecked = false;

      // 중복확인하고 editText 부분에 적었던거 기억하기 위함
      nicknameController = TextEditingController(text: tempNickName);
      emailController = TextEditingController(text: tempEmail);
      super.initState();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 300,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "이메일",
                      suffix: _isEmailChecked
                          ? Text("확인완료")
                          : GestureDetector(
                              child: Text("중복확인"),
                              onTap: () {
                                print("click");
                                setState(() {
                                  _isEmailChecked = !_isEmailChecked;
                                });
                              },
                            ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Container(
                  width: 300,
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: nicknameController,
                          onChanged: (text) {
                            tempNickName = text;
                          },
                          decoration: InputDecoration(
                            hintText: "닉네임",
                            suffix: _isNickNameChecked
                                ? Text("확인완료")
                                : GestureDetector(
                                    child: Text("중복확인"),
                                    onTap: () {
                                      print("click");
                                      setState(() {
                                        _isNickNameChecked =
                                            !_isNickNameChecked;
                                      });
                                    },
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Text("학교인증"),
                    ),
                    Container(
                        width: 100,
                        child: RaisedButton(
                            onPressed: () {}, child: Text("하러가기"))),
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
                      if (emailController.text != "") {
                        print("성공");
                        Navigator.of(context).pushReplacementNamed(
                            '/MainPage?UID=$currentUserId');
                      } else {
                        print("실패");
                      }
                    },
                    child: Text("가입완료"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
