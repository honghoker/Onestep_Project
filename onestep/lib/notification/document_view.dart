import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'inChattingRoom.dart';

class DocumentView extends StatelessWidget {
  final DocumentSnapshot documentData;
  SharedPreferences preferences;
  int count = 0;
  int ass = 4;

  Future<bool> lightbool(DocumentSnapshot documentData) async {
    String chatingroomid = documentData.id; //현재 채팅방 id 값 (모두 가져온다.)
    await FirebaseFirestore.instance
        .collection("user_chatlist") //유저 챗 리스트의
        .doc("EeSxjIzFDGWuxmEItV7JheMDZ6C2") //해당 유저 uid 값의 필드를 확인한다.
        .get()
        .then((DocumentSnapshot qs) {
      if (qs.data()[documentData.id.toString()].toString() == 'true') {
        print("@!@bOne : true  : " +
            chatingroomid.toString() +
            qs.data()[chatingroomid].toString());
        return true;
      } else {
        print("@!@bOne : false : " + chatingroomid.toString());
        return false;
      }
    });

    // if (documentData.id.toString() == "4NSDIwPokM8NbAZNidLi" ||
    //     documentData.id.toString() == "NZAqTcxODv0tPfW2oexw") return false;
    // print("@!@bbb" + documentData.id.toString());
    // return true;
  }

  String lightstr(DocumentSnapshot documentData) {
    print("@!@str : " + documentData.id.toString());
    return documentData.id.toString();
  }

  String lightstr2(DocumentSnapshot documentData) {
    print("@!@str222 : " + documentData.data()["board"].toString());
    return documentData.data()["board"].toString();
  }

  DocumentView(this.documentData);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: (lightbool(documentData)) != null
            ? ListTile(
                //여기서 채팅 여부 bool 값 받아서 판별해서 방 생성한다.@@@
                title: Row(
                  children: <Widget>[
                    //Text(documentData.id + ": 채팅방 id"),
                    Text(lightstr(documentData)),
                    Spacer(),
                    SizedBox(width: 150, height: 10),
                  ],
                ),
                subtitle: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '필드1 : ' + lightstr2(documentData),
                    ),
                    SizedBox(width: 10, height: 10),
                    Text('text : ' +
                        documentData.data()["recent_text"].toString()),
                    SizedBox(width: 10, height: 10),
                    Spacer(),
                  ],
                ),
                onTap: () {
                  print(' 받는유저' + documentData.data()["true"].toString());
                  print(' 보낸유저' + documentData.data()["채팅방이름"].toString());
                  print("중간");
                  print(documentData.id);
                  print(documentData.data().keys);
                  print(documentData.data().containsKey(1));
                  print(documentData.data().containsKey("채팅방이름"));
                  print(documentData.data().containsKey(0));
                  print(documentData.data().values);

                  print(documentData.reference.path);
                  print('끝');

                  getUserChatList(documentData.id.toString());

                  try1(documentData, "EeSxjIzFDGWuxmEItV7JheMDZ6C2");

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InChattingRoomPage(
                                //받은 유저와 내부 id 같으면 그값 보냄
                                myId: getChattingRoomMyId(documentData),
                                friendId: getChattingRoomFriendId(documentData),
                                chattingRoomId: getChattingRoomId(documentData),
                              )));
                },
              )
            : ListTile(
                title: Text("없습니다."),
              ),
      ),
    );
  }

  String getChattingRoomMyId(DocumentSnapshot documentData) {
    var myid = (documentData.data()["receive_user"].toString() ==
            preferences.getString("id"))
        ? documentData.data()["receive_user"].toString()
        : documentData.data()["send_user"].toString();
    return myid;
  }

  String getChattingRoomFriendId(DocumentSnapshot documentData) {
    var friendid = (documentData.data()["receive_user"].toString() !=
            preferences.getString("id"))
        ? documentData.data()["receive_user"].toString()
        : documentData.data()["send_user"].toString();
    return friendid;
  }

  String getChattingRoomId(DocumentSnapshot documentData) {
    var chattingroomid = documentData.id.toString();
    print("#### getChattingRoomId " + chattingroomid);
    return chattingroomid;
  }

  bool try1(DocumentSnapshot documentData, String uid) {
    print("####try1 실행");
    String chatingroomid = documentData.id; //현재 채팅방 id 값 (모두 가져온다.)
    FirebaseFirestore.instance
        .collection("user_chatlist") //유저 챗 리스트의
        .doc(uid) //해당 유저 uid 값의 필드를 확인한다.
        .get()
        .then((DocumentSnapshot qs) {
      if (qs.data()[chatingroomid].toString() == 'true') {
        print("####똑같네염 " + qs.data()[chatingroomid].toString());
        return true;
      }
    });
    return false;
  }

  bool try2() {
    count += 1;
    print("####try 몇번 실행?" + count.toString());

    if (count % 2 == 1)
      return true;
    else
      return false;
  }

  bool maketrue(DocumentSnapshot documentData) {
    print("####트루 몇회 생성?" + documentData.id.toString());

    String chatingroomid = documentData.id.toString(); //현재 채팅방 id 값 (모두 가져온다.)
    FirebaseFirestore.instance
        .collection("user_chatlist") //유저 챗 리스트의
        .doc("EeSxjIzFDGWuxmEItV7JheMDZ6C2") //해당 유저 uid 값의 필드를 확인한다.
        .get()
        .then((DocumentSnapshot qs) {
      print(qs.data()[chatingroomid].toString());
      // if (chatingroomid == qs.data()[chatingroomid].toString()) {
      //   print("####똑같네염" + chatingroomid);
      // }
    });

    return true;
  }

  bool getUserChatListbool() {
    String userchatlistbool;
    FirebaseFirestore.instance
        .collection("user_chatlist") //유저 챗 리스트의
        .doc("EeSxjIzFDGWuxmEItV7JheMDZ6C2") //해당 유저 uid 값의 필드를 확인한다.
        .get()
        .then((DocumentSnapshot qs) {
      userchatlistbool = qs.data()[getChattingRoomId(documentData)];
    });
    print("#### get 채팅 룸 아이디 " + userchatlistbool.toString());

    print("#### get user EeSx의 채팅 룸 아이디 " + userchatlistbool.toString());
    bool b = userchatlistbool == 'true';
    print("#### get user bool 채팅룸 있는지 " + b.toString());
    return b;
  }

  Future<bool> getUserChatList(String chattingroomid) async {
    print("겟유저");

    preferences = await SharedPreferences.getInstance();
    String uid = preferences.getString('id');

    print("%%프린트 유저 uid 외부 : " + uid);
    print("%%프린트 채팅룸 id 외부 : " + chattingroomid);
    //bool user1;
    FirebaseFirestore.instance
        .collection("user_chatlist")
        .doc("연습용")
        .get()
        .then((DocumentSnapshot ds1) {
      //print("%% 상단 활성화 여부 : " + ds1.data()["1"].toString());
      print("%% 상단 활성화 여부 : " + ds1.data()["4NSDIwPokM8NbAZNidLi"].toString());
      print("%% 상단 활성화 여부 : " + ds1.data()["테스트2"].toString());
      print("실행종료");
    });

    print("%%중간");

    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot ds) {
      print("%% 활성화 여부 : " + ds.data()["불리언"].toString());
      print("%% 활성화 여부 : " + ds.data()["nickname"].toString());
      print("%% 활성화 여부 : " + ds.data()["id"]);
      print("%% 활성화 여부 : " + ds.data()["aboutMe"]);
      print("%% 활성화 여부 : " + ds.data()["timestamp"]);
      print("%% 활성화 여부 : " + ds.data()["4NSDIwPokM8NbAZNidLi"].toString());
    });
    print("%%밑");

    var list = FirebaseFirestore.instance
        .collection("chattingroom")
        .doc(chattingroomid)
        .collection("message")
        .getDocuments();

    print("###쿼리 0 " + list.toString());

    Future getDocs() async {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("chattingroom")
          .doc(chattingroomid)
          .collection("message")
          .get();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        var a = querySnapshot.docs[i];
        print("###쿼리 1 : " + a.id);
      }
    }

    getDocs();

    Future getUserChatlistDocs() async {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("user_chatlist")
          .doc(chattingroomid)
          .collection("message")
          .get();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        var a = querySnapshot.docs[i];
        print("###쿼리 1 : " + a.id);
      }
    }

    FirebaseFirestore.instance
        .collection("user_chatlist")
        .doc("EeSxjIzFDGWuxmEItV7JheMDZ6C2")
        .get()
        .then((DocumentSnapshot qs) {
      print("###쿼리 2 " + qs.data().toString());
      print("####쿼리 2 2 " +
          qs.data()[getChattingRoomId(documentData)].toString());
    });

    //getKeyNames();
  }

  List<String> productName = [];

  void getKeyNames() {
    print("###키 네임 가져오기");
    Stream<QuerySnapshot> productRef =
        FirebaseFirestore.instance.collection("user_chatlist").snapshots();
    productRef.forEach((field) {
      field.docs.asMap().forEach((index, data) {
        productName.add(field.docs[index]["name"]);
        print("###" + field.docs[index]["name"]);
      });
    });
  }
}
