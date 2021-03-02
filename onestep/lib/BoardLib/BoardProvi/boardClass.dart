import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:random_string/random_string.dart';

class BoardData {
  var createDate;
  var alterDate;
  String documentId;
  final int favoriteCount;
  final String title;
  final String contentCategory;
  final int reportCount;
  final String textContent;
  final String uid;
  final int scribeCount;
  final int watchCount;
  final int commentCount;
  final String boardCategory;
  final String boardName;
  final String boardId;
  final List favoriteUserList;
  final List scrabUserList;
  Function completeImageUploadCallback;
  List imgUriList;
  Map<String, dynamic> imageCommentList;

  Future convertImage(var _imageArr) async {
    List _imgUriarr = [];
    for (var imaged in _imageArr) {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child("boardimages/freeboard/${randomAlphaNumeric(15)}");
      StorageUploadTask storageUploadTask = storageReference
          .putData((await imaged.getByteData()).buffer.asUint8List());
      await storageUploadTask.onComplete;
      String downloadURL = await storageReference.getDownloadURL();
      _imgUriarr.add(downloadURL);
    }
    return _imgUriarr;
  }

  BoardData(
      {this.scrabUserList,
      this.favoriteUserList,
      this.contentCategory,
      this.boardName,
      this.createDate,
      this.favoriteCount,
      this.title,
      this.reportCount,
      this.textContent,
      this.uid,
      this.imageCommentList,
      this.scribeCount,
      this.watchCount,
      this.documentId,
      this.commentCount,
      this.imgUriList,
      this.boardCategory,
      this.boardId});
  Future toFireStore(BuildContext context) async {
    imgUriList = await convertImage(imageCommentList["IMAGE"]);
    imageCommentList.update("IMAGE", (value) => imgUriList);
    return await FirebaseFirestore.instance
        .collection("Board")
        .doc("Board_Free")
        .collection("Board_Free")
        .add({
          "uid": FirebaseApi.getId(),
          "createDate": Timestamp.fromDate(DateTime.now()),
          "alterDate": null,
          "scribeCount": scribeCount ?? 0,
          "favoriteCount": favoriteCount ?? 0,
          "title": title,
          "contentCategory": contentCategory.toString(),
          "reportCount": reportCount ?? 0,
          "textContent": textContent ?? "",
          "imageCommentList": imageCommentList ?? {},
          "watchCount": watchCount ?? 0,
          "commentCount": commentCount ?? 0,
          "boardCategory": boardCategory,
          "boardId": boardId,
          "scrabUserList": scrabUserList ?? [],
          "favoriteUserList": favoriteUserList ?? [],
          "commentUserUidList": []
        })
        .whenComplete(() => true)
        .then((value) => true)
        .timeout(
          Duration(seconds: 3),
          onTimeout: () {
            Navigator.pop(context);
          },
        );
  }

  factory BoardData.fromFireStore(DocumentSnapshot snapshot) {
    Map _boardData = snapshot.data();
    return BoardData(
        title: _boardData["title"],
        imageCommentList: _boardData["imageCommentList"],
        contentCategory: _boardData["contentCategory"],
        favoriteCount: _boardData["favoriteCount"],
        textContent: _boardData["textContent"],
        uid: _boardData["uid"],
        documentId: snapshot.id,
        commentCount: _boardData["commentCount"],
        createDate: _boardData["createDate"].toDate(),
        watchCount: _boardData["watchCount"],
        boardId: _boardData["boardId"],
        boardCategory: _boardData["boardCategory"]);
  }
}

class BoardCateogry {
  final String boardName;
  BoardCateogry({this.boardName});
  factory BoardCateogry.fromFireStore(DocumentSnapshot snapshot) {
    print("snapshot.id" + snapshot.id);
    print("Log 1");
    return BoardCateogry(boardName: snapshot.id);
  }
}

class Comment {
  String COMMENT_COLLECTION_NAME = "Comment";
  final String uid;
  final String text;
  final int reportCount;
  var createDate;
  var lastAlterDate;
  final int favoriteCount;
  final List favoriteUserList;
  final String name;
  final String boardId;
  final String boardDocumentId;
  Comment(
      {this.createDate,
      this.uid,
      this.favoriteCount,
      this.favoriteUserList,
      this.lastAlterDate,
      this.name,
      this.reportCount,
      this.text,
      this.boardDocumentId,
      this.boardId});
  Future toFireStore(BuildContext context,
      {bool isUnderCommentSave, String commentDocumentId}) async {
    isUnderCommentSave = isUnderCommentSave ?? false;
    var _db = FirebaseFirestore.instance
        .collection("Board")
        .doc(boardId)
        .collection(boardId)
        .doc(boardDocumentId)
        .collection(COMMENT_COLLECTION_NAME);
    Map<String, dynamic> _saveData = {
      "uid": FirebaseApi.getId(),
      "text": text ?? "",
      "createDate": Timestamp.fromDate(DateTime.now()),
      "lastAlterDate": null,
      "name": name ?? "익명",
      "boardId": boardId ?? "",
      "boardDocumentId": boardDocumentId ?? "",
      "favoriteCount": 0,
      "favoriteUserList": [],
      "reportCount": 0,
      "isDelete": false,
      "deleteDate": null,
    };
    return !isUnderCommentSave
        ? await _db.add(_saveData).then((value) {
            if (value.runtimeType == DocumentReference) {
              return true;
            }
          })
        : await _db
            .doc(commentDocumentId)
            .collection(COMMENT_COLLECTION_NAME)
            .add(_saveData)
            .then((value) {
            if (value.runtimeType == DocumentReference) {
              return true;
            }
          });
  }

  Future _saveUidInBoardField(
      DocumentSnapshot documentSnapshot, String currentUid) async {
    Map _data = documentSnapshot.data();
    List _commentList = documentSnapshot.data()["commentList"];

    if (!_commentList.contains(currentUid)) {
      return await FirebaseFirestore.instance
          .collection("Board")
          .doc(boardId)
          .collection(boardId)
          .doc(boardDocumentId)
          .update({"commentList": _data["commentList"].add(currentUid)})
          .catchError((onError) {
            print("catchError ");
          })
          .then((value) => print("Something error null pointer or.. "))
          .whenComplete(() => true);
    }
  }

  getUnderComment(
      String boardId, String currentBoardId, String commentId) async {
    var _result;
    await FirebaseFirestore.instance
        .collection("Board")
        .doc(boardId)
        .collection(boardId)
        .doc(currentBoardId)
        .collection(COMMENT_COLLECTION_NAME)
        .doc(commentId)
        .collection(COMMENT_COLLECTION_NAME)
        .get()
        .catchError((onError) {
      print(onError.toString() + "Under comment");
    }).then((value) {
      _result = value;
    });

    return _result;
  }
}

// class UnderComment extends Comment {
//   UnderComment(
//       {String createDate,
//       String uid,
//       var lastAlterDate,
//       String text,
//       int reportCount,
//       int favoriteCount,
//       List favoriteUserList,
//       String name,
//       String boardId,
//       String boardDocumentId})
//       : super(
//             createDate: createDate,
//             uid: uid,
//             favoriteCount: favoriteCount,
//             favoriteUserList: favoriteUserList,
//             lastAlterDate: lastAlterDate,
//             name: name,
//             reportCount: reportCount,
//             text: text,
//             boardDocumentId: boardDocumentId,
//             boardId: boardId);
//   getUnderComment(String boardDocumentId) {

//   }
// }
