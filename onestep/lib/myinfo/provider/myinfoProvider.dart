import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class MyinfoProvider with ChangeNotifier {
  bool _isSwitched = false;

  setSwitchedValue(bool value) => _isSwitched = value;
  bool get hasSwitched => _isSwitched;

  Future changedSwitchValue(bool currentSwitched) async {
    _isSwitched = currentSwitched;
    notifyListeners();
  }

  bool _isNickNameChecked = false;
  bool _isNickNameUnderLine = true;
  String _resultNickName = '';

  setNickNameChecked(bool value) => _isNickNameChecked = value;
  setNickNameUnderLine(bool value) => _isNickNameUnderLine = value;
  setResultNickName(String value) => _resultNickName = value;
  bool get hasNickNameChecked => _isNickNameChecked;
  bool get hasNickNameUnderLine => _isNickNameUnderLine;
  String get hasResultNickName => _resultNickName;

  Future authEmailNickNameCheck(bool value, String tempNickName) async {
    _isNickNameChecked = value;
    _isNickNameUnderLine = value;
    _resultNickName = tempNickName;
    notifyListeners();
  }
}
