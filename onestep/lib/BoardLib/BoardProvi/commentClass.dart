import 'dart:html';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onestep/api/firebase_api.dart';

class CommentClass {
  var createDate;
  var lastAlterDate;

  final String uid;
  final String textContent;
  final int reportCount;
  final int favoriteCount;
  final List favoriteUserList;
  final String userNickName;
  final String boardId;
  CommentClass(
      {this.uid,
      this.textContent,
      this.createDate,
      this.favoriteCount,
      this.favoriteUserList,
      this.lastAlterDate,
      this.reportCount,
      this.boardId,
      this.userNickName});
  toFireStore(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection("Board")
        .doc("Board_Free")
        .collection("Board_Free")
        .add({
      "uid": FirebaseApi.getId(),
      "createDate": Timestamp.fromDate(DateTime.now()),
      "alterDate": null,
      "favoriteCount": favoriteCount ?? 0,
      "reportCount": reportCount ?? 0,
      "textContent": textContent ?? "",
      // "imageCommentList": imageCommentList ?? {},
      "boardId": boardId,
      "favoriteUserList": favoriteUserList ?? [],
    }).then((value) => true);
  }

  factory CommentClass.fromFireStore(DocumentSnapshot documentSnapshot) {
    Map _commentData = documentSnapshot.data();
    return CommentClass(
        uid: _commentData["uid"],
        boardId: _commentData["boardId"],
        textContent: _commentData["textContent"],
        createDate: _commentData["createDate"],
        lastAlterDate: _commentData["lastAlterDate"],
        favoriteCount: _commentData["favoriteCount"],
        favoriteUserList: _commentData["favoriteUserList"],
        reportCount: _commentData["reportCount"],
        userNickName: _commentData["userNickName"]);
  }
}
