import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onestep/BoardLib/BoardComment/CommentInBoardContent.dart';
import 'package:onestep/BoardLib/CreateAlterBoard/parentState.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
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
          "commentList": []
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

class FreeBoardList extends BoardData {
  FreeBoardList(
      {String title,
      int watchCount,
      int favoriteCount,
      String uid,
      String contentCategory,
      int scribeCount,
      var createDate,
      String documentId,
      String textContent,
      int commentCount,
      Map<String, dynamic> imageCommentList,
      String boardId})
      : super(
            title: title,
            contentCategory: contentCategory,
            uid: uid,
            createDate: createDate,
            documentId: documentId,
            favoriteCount: favoriteCount,
            textContent: textContent,
            watchCount: watchCount,
            commentCount: commentCount,
            imageCommentList: imageCommentList,
            boardId: boardId);

  factory FreeBoardList.fromFireStore(DocumentSnapshot snapshot) {
    Map _boardData = snapshot.data();

    return FreeBoardList(
        title: _boardData["title"],
        // imageCommentList: _boardData["imageCommentList"],
        contentCategory: _boardData["contentCategory"],
        favoriteCount: _boardData["favoriteCount"],
        textContent: _boardData["textContent"],
        uid: _boardData["uid"],
        documentId: snapshot.id,
        commentCount: _boardData["commentCount"],
        createDate: _boardData["createDate"].toDate(),
        watchCount: _boardData["watchCount"],
        boardId: _boardData["boardId"]);
  }
}

class ImageContentComment extends BoardData {
  ImageContentComment({Map<String, dynamic> imageCommentList})
      : super(imageCommentList: imageCommentList);
  factory ImageContentComment.fromFireStore(DocumentSnapshot snapshot) {
    Map _contentData = snapshot.data();
    return ImageContentComment(
        imageCommentList: _contentData["imageCommentList"]);
  }
}

class Comment {
  String COMMENT_COLLECTION_NAME = "Comment";
  final String uid;
  final String text;
  final String reportCount;
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
  Future toFireStore(BuildContext context) async {
    return await FirebaseFirestore.instance
        .collection("Board")
        .doc(boardId)
        .collection(boardId)
        .doc(boardDocumentId)
        .collection(COMMENT_COLLECTION_NAME)
        .add({
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
    }).then((value) {
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
}
