import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onestep/BoardLib/CreateAlterBoard/parentState.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:random_string/random_string.dart';

class BoardData {
  final String userId;
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
      {this.contentCategory,
      this.boardName,
      this.createDate,
      this.favoriteCount,
      this.title,
      this.userId,
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
    await FirebaseFirestore.instance
        .collection("Board")
        .doc("Board_Free")
        .collection("Board_Free")
        .add({
          "uid": await FirebaseApi.getId(),
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
          "boardId": boardId
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
      Map<String, dynamic> imageCommentList})
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
            imageCommentList: imageCommentList);

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
        watchCount: _boardData["watchCount"]);
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
