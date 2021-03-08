import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:onestep/cloth/providers/myProductProvider.dart';
import 'package:onestep/favorite/favoriteWidget.dart';
import 'package:onestep/favorite/providers/favoriteProvider.dart';
import 'package:onestep/home/notificationPage.dart';
import 'package:onestep/moor/moor_database.dart';
import 'package:onestep/myinfo/myinfoMyWrite.dart';
import 'package:onestep/myinfo/myinfoSettingsPage.dart';
import 'package:onestep/myinfo/provider/myinfoProvider.dart';
import 'package:onestep/profile/profileWidget.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

class MyinfoWidget extends StatefulWidget {
  @override
  _MyinfoWidgetState createState() => _MyinfoWidgetState();
}

DocumentSnapshot ds;
String downloadURL;

class _MyinfoWidgetState extends State<MyinfoWidget> {
  @override
  void initState() {
    super.initState();
  }

  Future<DocumentSnapshot> getUrl() async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseApi.getId())
        .get();
  }

  void checkUserLevel() async {
    ds = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseApi.getId())
        .get();
  }

  @override
  Widget build(BuildContext context) {
    PushNoticeChksDao p = Provider.of<AppDatabase>(context).pushNoticeChksDao;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            '내정보',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder(
            future: getUrl(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              // streambuilder, futurebuilder 모두 써야함 switch
              switch (snapshot.connectionState) {
                // ConnectionState.waiting -> 연결상태가 데이터를 가져오고 있는 중인가?
                case ConnectionState.waiting:
                  return Container();
                default:
                  return StreamBuilder(
                    stream: p.watchAllPushNoticeChks(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<PushNoticeChk>> snapshot1) {
                      switch (snapshot1.connectionState) {
                        case ConnectionState.waiting:
                          return Container();
                        default:
                          // print("########### data = ${snapshot1.data}");
                          // print(
                          //     "########### data length = ${snapshot1.data.length}");
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    // 프사 변경도 에타처럼
                                    IconButton(
                                      icon:
                                          // snapshot.data.data()['photoUrl'] != ""
                                          //     // downloadURL != ""
                                          //     ? ClipOval(
                                          //         child: Image.network(
                                          //         snapshot.data.data()['photoUrl'],
                                          //         height: 100,
                                          //         width: 100,
                                          //         fit: BoxFit.cover,
                                          //       ))
                                          //     :
                                          Icon(Icons.account_circle),
                                      color: Colors.black,
                                      iconSize: 100,
                                      onPressed: () async {
                                        // // 프사 변경할때 image 가져오고 storage 저장 후 photoUrl 업데이트
                                        // File image = await ImagePicker.pickImage(
                                        //     source: ImageSource.gallery);
                                        // StorageReference storageReference =
                                        //     FirebaseStorage.instance.ref().child(
                                        //         "user images/${randomAlphaNumeric(15)}");
                                        // StorageUploadTask storageUploadTask =
                                        //     storageReference.putFile(image);
                                        // if (await storageUploadTask.onComplete !=
                                        //     null) {
                                        //   if (downloadURL != "") {
                                        //     // firebase photourl 이용해서 storage 삭제
                                        //     // 사진 데이터없애는거  이야기해서 생각 (ex) 이상한 사진 같은거 올리면 모름
                                        //     FirebaseStorage.instance
                                        //         .getReferenceFromUrl(downloadURL)
                                        //         .then((reference) => reference.delete())
                                        //         .catchError((e) => print(e));
                                        //     // 그리고 photoUrl "" 리셋
                                        //     FirebaseFirestore.instance
                                        //         .collection("users")
                                        //         .doc("${FirebaseApi.getId()}")
                                        //         .update({
                                        //       "photoUrl": "",
                                        //     });
                                        //     downloadURL =
                                        //         await storageReference.getDownloadURL();
                                        //     FirebaseFirestore.instance
                                        //         .collection("users")
                                        //         .doc("${FirebaseApi.getId()}")
                                        //         .update({
                                        //       "photoUrl": downloadURL,
                                        //     });
                                        //   } else {
                                        //     downloadURL =
                                        //         await storageReference.getDownloadURL();
                                        //     FirebaseFirestore.instance
                                        //         .collection("users")
                                        //         .doc("${FirebaseApi.getId()}")
                                        //         .update({
                                        //       "photoUrl": downloadURL,
                                        //     });
                                        //   }
                                        //   setState(() {});
                                        // }
                                      },
                                    ),

                                    Column(
                                      children: [
                                        Container(
                                          child: Text(
                                            "김성훈",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            "계명대학교",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          170, 0, 0, 0),
                                      child: IconButton(
                                        icon: Icon(Icons.settings),
                                        color: Colors.black,
                                        iconSize: 30,
                                        onPressed: () {
                                          // test 초기화 나중에 회원가입 폼에서 푸시알림이나 이벤트알림 등 푸시알림 받을건지 물어보는 창 만들어서 거기서
                                          // 수락하거나 거절하는 결과에 따라서 insert 하고 메인으로 넘어오게 만들어야함
                                          // p.insertPushNotice(PushNoticeChk(firestoreid: FirebaseApi.getId(), pushChecked: 'true'));

                                          // provider 쓰려면 이렇게 consumer로 넘겨줘야함
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Consumer<MyinfoProvider>(
                                                        builder: (context,
                                                                myinfoProvider,
                                                                _) =>
                                                            MyinfoSettingsPage(
                                                          myinfoProvider:
                                                              myinfoProvider,
                                                          initSwitchedValue:
                                                              snapshot1
                                                                  .data
                                                                  .first
                                                                  .pushChecked,
                                                        ),
                                                      )));
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 25, 0, 25),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProfileWidget(
                                                          uid: FirebaseApi
                                                              .getId(),
                                                        )),
                                              );
                                            },
                                            icon: Icon(Icons.error_outline),
                                          ),
                                          Text("프로필보기"),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    Consumer<MyProductProvider>(
                                                  builder: (context,
                                                          myProductProvider,
                                                          _) =>
                                                      MyinfoMyWrite(
                                                    myProductProvider:
                                                        myProductProvider,
                                                  ),
                                                ),
                                              ));
                                            },
                                            icon: Icon(Icons.error_outline),
                                          ),
                                          Text("내가쓴글"),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Consumer<
                                                          FavoriteProvider>(
                                                    builder: (context,
                                                            favoriteProvider,
                                                            _) =>
                                                        FavoriteWidget(
                                                      favoriteProvider:
                                                          favoriteProvider,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: Icon(Icons.error_outline),
                                          ),
                                          Text("찜목록"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 0, 0),
                                  child: Container(
                                    child: Text(
                                      "인증",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 10, 0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            "학교 인증",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        IconButton(
                                          icon:
                                              Icon(Icons.keyboard_arrow_right),
                                          onPressed: () {},
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 0, 0),
                                  child: Container(
                                    child: Text(
                                      "정보",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    print("click");
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NotificationPage()));
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 10, 0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            "공지사항",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        IconButton(
                                          icon:
                                              Icon(Icons.keyboard_arrow_right),
                                          onPressed: () {},
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Text(
                                          "문의사항",
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
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Text(
                                          "고객센터",
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
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Text(
                                          "개인정보 처리방침",
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
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Text(
                                          "서비스 이용약관",
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
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Text(
                                          "버전정보",
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
                              ],
                            ),
                          );
                      }
                    },
                  );
              }
            }));
  }
}
