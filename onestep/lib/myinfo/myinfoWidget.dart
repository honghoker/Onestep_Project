import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onestep/api/firebase_api.dart';
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
    // test();
  }

  Future<DocumentSnapshot> getUrl() async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseApi.getId())
        .get();
  }

  // void test() async {
  //   print("downloadURL1 $downloadURL");

  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseApi.getId())
  //       .get()
  //       .then((DocumentSnapshot url) {
  //     downloadURL = url.data()['photoUrl'].toString();
  //     print("downloadURL2 = $downloadURL");
  //   });
  //   print("downloadURL3 $downloadURL");
  // }

  void checkUserLevel() async {
    ds = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseApi.getId())
        .get();
  }

  @override
  Widget build(BuildContext context) {
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
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // 프사 변경도 에타처럼
                            IconButton(
                              icon: snapshot.data.data()['photoUrl'] != ""
                                  // downloadURL != ""
                                  ? ClipOval(
                                      child: Image.network(
                                      snapshot.data.data()['photoUrl'],
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ))
                                  : Icon(Icons.account_circle),
                              color: Colors.black,
                              iconSize: 100,
                              onPressed: () async {
                                // 프사 변경할때 image 가져오고 storage 저장 후 photoUrl 업데이트
                                File image = await ImagePicker.pickImage(
                                    source: ImageSource.gallery);
                                StorageReference storageReference =
                                    FirebaseStorage.instance.ref().child(
                                        "user images/${randomAlphaNumeric(15)}");
                                StorageUploadTask storageUploadTask =
                                    storageReference.putFile(image);
                                if (await storageUploadTask.onComplete !=
                                    null) {
                                  if (downloadURL != "") {
                                    // firebase photourl 이용해서 storage 삭제
                                    // 사진 데이터없애는거  이야기해서 생각 (ex) 이상한 사진 같은거 올리면 모름
                                    FirebaseStorage.instance
                                        .getReferenceFromUrl(downloadURL)
                                        .then((reference) => reference.delete())
                                        .catchError((e) => print(e));
                                    // 그리고 photoUrl "" 리셋
                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc("${FirebaseApi.getId()}")
                                        .update({
                                      "photoUrl": "",
                                    });
                                    downloadURL =
                                        await storageReference.getDownloadURL();
                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc("${FirebaseApi.getId()}")
                                        .update({
                                      "photoUrl": downloadURL,
                                    });
                                  } else {
                                    downloadURL =
                                        await storageReference.getDownloadURL();
                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc("${FirebaseApi.getId()}")
                                        .update({
                                      "photoUrl": downloadURL,
                                    });
                                  }
                                  setState(() {});
                                }
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
                              padding: const EdgeInsets.fromLTRB(170, 0, 0, 0),
                              child: IconButton(
                                icon: Icon(Icons.settings),
                                color: Colors.black,
                                iconSize: 30,
                                onPressed: () {},
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            child: Text("프로필 보기"),
                            onPressed: () {},
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                          child: Container(
                            child: Text(
                              "Category1",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            testShowBottom();
                            // print("click");
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    "내정보수정",
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  "로그아웃",
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
                          padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                          child: Container(
                            child: Text(
                              "Category2",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print("click");
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    "공지사항",
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                          child: Container(
                            child: Text(
                              "Category3",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print("click");
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.only(top: 40),
                        //   child: Center(
                        //     child: IconButton(
                        //       icon: Icon(Icons.account_circle),
                        // color: Colors.black,
                        // iconSize: 100,
                        // onPressed: () {},
                        //     ),
                        //   ),
                        // ),
                        // Center(
                        //   child: Container(
                        //     child: Text(
                        //       "김성훈",
                        //       style: TextStyle(fontSize: 30),
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 10),
                        //   child: Center(
                        //     child: Container(
                        //       child: Text(
                        //         "계명대학교",
                        //         style: TextStyle(fontSize: 15),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 30.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //     children: [
                        //       Column(
                        //         children: [
                        //           IconButton(
                        //             icon: Icon(Icons.notifications_none),
                        //             onPressed: () {},
                        //           ),
                        //           Text("공지사항"),
                        //         ],
                        //       ),
                        //       Column(
                        //         children: [
                        //           IconButton(
                        //             icon: Icon(Icons.check_circle),
                        //             onPressed: () {
                        //               checkUserLevel();
                        //               ds.data()['authUniversity'] == 1
                        //                   ? print("학교인증을 이미 함")
                        //                   : print("학교인증페이지로");
                        //             },
                        //           ),
                        //           Text("인증"),
                        //         ],
                        //       ),
                        //       Column(
                        //         children: [
                        //           IconButton(
                        //             icon: Icon(Icons.settings),
                        //             onPressed: () {},
                        //           ),
                        //           Text("App 설정"),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 30.0),
                        //   child: Padding(
                        //     padding: const EdgeInsets.fromLTRB(60, 10, 10, 0),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Text("내가 쓴 글"),
                        //         Padding(
                        //           padding: const EdgeInsets.only(right: 35.0),
                        //           child: IconButton(
                        //             icon: Icon(Icons.keyboard_arrow_right),
                        //             onPressed: () {
                        //               Navigator.of(context).push(MaterialPageRoute(
                        //                   builder: (context) => MyinfoMyWrite()));
                        //             },
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 0.0),
                        //   child: Padding(
                        //     padding: const EdgeInsets.fromLTRB(60, 10, 10, 0),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Text("고객센터"),
                        //         Padding(
                        //           padding: const EdgeInsets.only(right: 35.0),
                        //           child: IconButton(
                        //             icon: Icon(Icons.keyboard_arrow_right),
                        //             onPressed: () {},
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 0.0),
                        //   child: Padding(
                        //     padding: const EdgeInsets.fromLTRB(60, 10, 10, 0),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Text("신고하기 test"),
                        //         Padding(
                        //           padding: const EdgeInsets.only(right: 35.0),
                        //           child: IconButton(
                        //             icon: Icon(Icons.keyboard_arrow_right),
                        //             onPressed: () {
                        //               testShowBottom();
                        //             },
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  );
              }
            }));
  }

  void testShowBottom() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: [
              ListTile(
                title: Text("text1"),
                onTap: () => print("text1 click"),
              )
            ],
          );
        });
  }
}
