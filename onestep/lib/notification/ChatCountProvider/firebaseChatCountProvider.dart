import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onestep/api/firebase_api.dart';
import 'ChatCount.dart';

class FirebaseChatCountProvider {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // User 1명의 데이터 읽기
  Stream<ChatCount> getUser() {
    var snap =
        _db.collection('users').doc(FirebaseApi.getId()).get().then((value) {
      return value.id.toString();
    });
  }

  // // User 1명의 데이터 읽기
  // Future<ChatCount> getUser() async {
  //   var snap = await _db.collection('users').doc(FirebaseApi.getId()).get();
  //   return ChatCount.fromMap(snap.data());
  // }

  // User 여러명의 데이터 읽기
  Stream<List<ChatCount>> getUsers() {
    // DocumentSnapshot 으로 되어 있기에 이를 리스트 형식으로 바꿔줌.
    // return _db.collection('users').snapshots().map((list) =>
    //     list.docs.map((doc) => ChatCount.fromFireStore(doc)).toList());
  }
}
