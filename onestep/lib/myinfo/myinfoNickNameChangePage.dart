import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep/api/firebase_api.dart';

class MyinfoNickNameChangePage extends StatefulWidget {
  @override
  _MyinfoNickNameChangePageState createState() =>
      _MyinfoNickNameChangePageState();
}

class _MyinfoNickNameChangePageState extends State<MyinfoNickNameChangePage> {
  TextEditingController nicknameController;
  bool _isNickNameUnderLine = true;
  bool _isNickNameChecked = false;
  String tempNickName = "";
  String resultNickName = "";

  @override
  void initState() {
    _isNickNameChecked = false;
    _isNickNameUnderLine = true;

    nicknameController = TextEditingController(text: tempNickName);
    nicknameController.selection = TextSelection.fromPosition(
        TextPosition(offset: nicknameController.text.length));
    super.initState();
  }

  authEmailNickNameCheck(String text) async {
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
      resultNickName = tempNickName;
      print("docRef.isEmpty 2 = ${docRef.isNotEmpty}");
    });
  }

  void flutterDialog() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                Text(""),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    "닉네임 중복확인을 해주세요",
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '닉네임 변경',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Center(
                child: Container(
                  child: Text(
                    "새로운 닉네임을 입력해주세요.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                child: TextField(
                  maxLength: 8,
                  controller: nicknameController,
                  onChanged: (text) {
                    tempNickName = text;
                  },
                  decoration: InputDecoration(
                    counterText: "",
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
                              authEmailNickNameCheck(nicknameController.text);
                            },
                          )
                        : GestureDetector(
                            child: Text("중복확인"),
                            onTap: () {
                              authEmailNickNameCheck(nicknameController.text);
                            },
                          ),
                  ),
                ),
              ),
            ),
            Offstage(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 200, 0),
                child: Text(
                  "닉네임이 중복입니다.",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              offstage: _isNickNameUnderLine == true ? true : false,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                child: RaisedButton(
                  color: Colors.white70,
                  child: Text("변경하기"),
                  onPressed: () {
                    _isNickNameChecked == false
                        ? flutterDialog()
                        :
                        // FirebaseFirestore.instance
                        //     .collection("users")
                        //     .doc(FirebaseApi.getId())
                        //     .update({"nickName": resultNickName});
                        Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
