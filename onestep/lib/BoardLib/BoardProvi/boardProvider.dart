import 'package:cloud_firestore/cloud_firestore.dart';
import 'boardClass.dart';

class BoardProvider {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<FreeBoardList>> getFreeBoard() {
    return _db
        .collection("Board")
        .doc("Board_Free")
        .collection("Board_Free_BoardId")
        .orderBy("createDate", descending: true)
        .snapshots()
        .map((list) =>
            list.docs.map((doc) => FreeBoardList.fromFireStore(doc)).toList());
  }
}
