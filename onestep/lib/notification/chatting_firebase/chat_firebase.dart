import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatFirebase {
  SharedPreferences preferences;
  void getUserChattingroom(String chattingroomid) {
    FirebaseFirestore.instance
        .collection("chattingroom")
        .doc(chattingroomid)
        .collection("message")
        .doc("EvfV0Op55BKgNb7Mx1IW")
        .get()
        .then((DocumentSnapshot qs) {
      print("###쿼리 2" + qs.data().toString());
    });
  }
}
