import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onestep/api/firebase_api.dart';

import '../../main.dart';

class FirebaseChatController {
  Future<void> normalForm(String userUid, String chatId) async {
    // userImageFile,
    try {
      FirebaseFirestore.instance.collection("").doc(userUid).update({
        //"id": userUid,
        chatId: true,
      });
    } catch (e) {
      print(e.message);
    }
  }

  Future<void> updateReadMessage(
      AsyncSnapshot<dynamic> snapshot, String myId) async {
    // userImageFile,
    try {
      if (snapshot.hasData) {
        for (var data in snapshot.data.documents) {
          if (data['idTo'] == myId && data['isRead'] == false) {
            if (data.reference != null) {
              FirebaseFirestore.instance
                  .runTransaction((Transaction myTransaction) async {
                myTransaction.update(data.reference, {'isRead': true});
              });
            }
          }
        }
      }
    } catch (e) {
      print(e.message);
    }
  }

  StreamBuilder getChatBottomBar() {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseApi.getId())
            .collection("chatcount")
            .doc(FirebaseApi.getId())
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data.toString());
          } else
            return Text("error");

          if (snapshot.data.data()['productchatcount'] == 0 &&
              snapshot.data.data()['boardchatcount'] == 0) {
            return Stack(
              children: [
                new Icon(
                  Icons.notifications_none,
                  size: 25,
                  color: Colors.black,
                ),
                Positioned(
                  top: 1,
                  right: 1,
                  child: Stack(
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(),
                        child: Center(
                          child: Text(""),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.data.data()['productchatcount'] > 0 ||
              snapshot.data.data()['boardchatcount'] > 0) {
            return Stack(
              children: [
                new Icon(
                  Icons.notifications_none,
                  size: 25,
                  color: Colors.black,
                ),
                Positioned(
                  top: 1,
                  right: 1,
                  child: Stack(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        child: Center(
                          child: Text(""),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Container();
        });
  }

  //Chat Main ChatCount
  StreamBuilder getAllChatCount() {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseApi.getId())
            .collection("chatcount")
            .doc(FirebaseApi.getId())
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data.toString());
          } else
            return Text("error");
          //둘 다 0 일 경우
          if (snapshot.data.data()['productchatcount'] == 0 &&
              snapshot.data.data()['boardchatcount'] == 0) {
            return Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(),
              child: Center(
                child: Text(""),
              ),
            );
          } else if (snapshot.data.data()['productchatcount'] > 0 ||
              snapshot.data.data()['boardchatcount'] > 0) {
            return Container(
              width: 10,
              height: 10,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.red),
              child: Center(
                child: Text(""),
              ),
            );
          } else
            return Container();
        });
  }

  Future<Null> logoutUser(var context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    print('##로그아웃 버튼 누름');
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
        (Route<dynamic> route) => false);
  }
}
