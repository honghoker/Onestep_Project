import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep/api/firebase_api.dart';

class MyinfoWidget extends StatefulWidget {
  @override
  _MyinfoWidgetState createState() => _MyinfoWidgetState();
}

DocumentSnapshot ds;

class _MyinfoWidgetState extends State<MyinfoWidget> {
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 프사 변경도 에타처럼
                IconButton(
                  // icon: Image.network(
                  //     'https://firebasestorage.googleapis.com/v0/b/onestep-project.appspot.com/o/user%20images%2F949365341q95863?alt=media&token=f1c3069f-e80c-46cf-81fe-7379c9cb4453'),
                  icon: Icon(Icons.account_circle),
                  color: Colors.black,
                  iconSize: 100,
                  onPressed: () async {
                    // 프사 변경할때 image 가져오고 storage 저장 후 photoUrl 업데이트
                    // File image = await ImagePicker.pickImage(
                    //     source: ImageSource.gallery);
                    // StorageReference storageReference = FirebaseStorage.instance
                    //     .ref()
                    //     .child("user images/${randomAlphaNumeric(15)}");
                    // StorageUploadTask storageUploadTask =
                    //     storageReference.putFile(image);
                    // await storageUploadTask.onComplete;
                    // String downloadURL =
                    //     await storageReference.getDownloadURL();

                    // FirebaseFirestore.instance
                    //     .collection("users")
                    //     .doc("${FirebaseApi.getId()}")
                    //     .update({
                    //   "photoUrl": downloadURL,
                    // });

                    // // firebase photourl 이용해서 storage 삭제
                    // FirebaseStorage.instance
                    //     .getReferenceFromUrl(
                    //         'https://firebasestorage.googleapis.com/v0/b/onestep-project.appspot.com/o/user%20images%2F949365341q95863?alt=media&token=f1c3069f-e80c-46cf-81fe-7379c9cb4453')
                    //     .then((reference) => reference.delete())
                    //     .catchError((e) => print(e));
                    // // 그리고 photoUrl "" 리셋
                    // FirebaseFirestore.instance
                    //     .collection("users")
                    //     .doc("${FirebaseApi.getId()}")
                    //     .update({
                    //   "photoUrl": "",
                    // });
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
      ),
    );
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
