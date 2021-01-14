import 'package:flutter/cupertino.dart';

class CheckAuth with ChangeNotifier {
  bool isAuthTrue = false;
  String _result = "실패";

  void successAuth() {
    isAuthTrue = true;
    _result = "성공";
    notifyListeners();
  }

  String getResult() {
    return _result;
  }
}