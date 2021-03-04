import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep/moor/moor_database.dart';
import 'package:onestep/myinfo/myinfoNickNameChangePage.dart';
import 'package:provider/provider.dart';

class MyinfoSettingsPage extends StatefulWidget {
  @override
  _MyinfoSettingsPageState createState() => _MyinfoSettingsPageState();
}

class _MyinfoSettingsPageState extends State<MyinfoSettingsPage> {
  // 지금은 false로 해놨는데 나중에 내부 db에 푸쉬 알림 들어가야할듯
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    PushNoticeChksDao p = Provider.of<AppDatabase>(context).pushNoticeChksDao;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '설정',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: p.getAllPushNoticeChks(),
        builder: (BuildContext context,
            AsyncSnapshot<List<PushNoticeChk>> snapshot) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Container(
                    child: Text(
                      "알림 설정",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "푸쉬 알림 설정",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            // 내부 db 작업 해야함 
                            print("db value = ${snapshot.data}");
                            // p.insertPushNotice(PushNoticeChk(
                            //   pushChecked: "true",
                            // ));
                            setState(() {
                              isSwitched = value;
                              print(isSwitched);
                            });
                          },
                          activeTrackColor: Colors.lightGreenAccent,
                          activeColor: Colors.green,
                        ),
                        // IconButton(
                        //   icon: Icon(Icons.keyboard_arrow_right),
                        //   onPressed: () {},
                        // )
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Container(
                    child: Text(
                      "사용자 설정",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyinfoNickNameChangePage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "닉네임 변경",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.keyboard_arrow_right),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    MyinfoNickNameChangePage()));
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Container(
                    child: Text(
                      "기타",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "언어설정",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.keyboard_arrow_right),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "로그아웃",
                            style:
                                TextStyle(fontSize: 15, color: Colors.red[200]),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.keyboard_arrow_right),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
