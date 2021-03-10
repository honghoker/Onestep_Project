import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class MyinfoProvider with ChangeNotifier {
  bool _isPushSwitched = false;
  bool _isMarketingSwitched = false;

  setPushSwitchedValue(bool value) => _isPushSwitched = value;
  bool get hasPushSwitched => _isPushSwitched;

  setMarketingSwitchedValue(bool value) => _isMarketingSwitched = value;
  bool get hasMarketingSwitched => _isMarketingSwitched;

  Future changedPushSwitchValue(bool currentSwitched) async {
    _isPushSwitched = currentSwitched;
    notifyListeners();
  }
  Future changedMarketingSwitchValue(bool currentSwitched) async {
    _isMarketingSwitched = currentSwitched;
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
