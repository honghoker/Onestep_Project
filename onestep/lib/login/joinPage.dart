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

  @override
  void initState() {
    _dropdownEmailList = buildDropdownMenuItems(_emailList);
    _selectedEmail = _dropdownEmailList[0].value;

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
    final emailController = TextEditingController();
    final nicknameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 0, 80, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Container(
                        //   child: Text("*"),
                        // ),
                        Container(
                          child: Text("이메일"),
                        ),
                        Container(
                          width: 200,
                          child: TextField(
                            controller: emailController,
                            // obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              // labelText: "email",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 10, 80, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(""),
                        ),
                        DropdownButton(
                          value: _selectedEmail,
                          items: _dropdownEmailList,
                          onChanged: onChangeDropdwonItem,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 10, 80, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text("별명"),
                        ),
                        Container(
                          width: 200,
                          child: TextField(
                            controller: nicknameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              // labelText: "email",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 10, 80, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(""),
                        ),
                        Container(
                            width: 100,
                            child: RaisedButton(
                                // 별명 추후에 중복확인 예외처리 추가
                                onPressed: () {}, child: Text("중복확인"))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 10, 80, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Container(
                  width: 200,
                  // 이메일, 별명 (중복확인까지) 적혀있어야 가입완료 o
                  child: RaisedButton(
                    onPressed: () {
                      // test : email text 공백 아니면 넘어감
                      if(emailController.text!=""){
                        print("성공");
                      }
                      else{
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
