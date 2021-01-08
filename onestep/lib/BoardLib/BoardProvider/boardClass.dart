import 'package:flutter/material.dart';

class BoardData {
  final String userId;
  var createDate;
  var alterDate;
  final int favoriteCount;
  final String title;
  final String subTitle;
  final int reportCount;
  String documentId;
  final String textContent;
  BoardData(
      {this.createDate,
      this.favoriteCount,
      this.subTitle,
      this.title,
      this.userId,
      this.reportCount,
      this.textContent});
}

class BoardLatest extends BoardData {}
