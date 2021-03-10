import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier{

  // join
  bool _isEmailChecked = false;
  bool _isEmailUnderLine = true;
  bool _isNickNameChecked = false;
  bool _isNickNameUnderLine = true;

  setEmailChecked(bool value) => _isEmailChecked = value;
  bool get hasEmailChecked => _isEmailChecked;
  setEmailUnderLine(bool value) => _isEmailUnderLine = value;
  bool get hasEmailUnderLine => _isEmailUnderLine;

  setNickNameChecked(bool value) => _isNickNameChecked = value;
  bool get hasNickNameChecked => _isNickNameChecked;
  setNickNameUnderLine(bool value) => _isNickNameUnderLine = value;
  bool get hasNickNameUnderLine => _isNickNameUnderLine;

  Future changedEmailChecked(bool value) async {
    _isEmailChecked = value;
    notifyListeners();
  }
  Future changedEmailUnderLine(bool value) async {
    _isEmailUnderLine = value;
    notifyListeners();
  }
  Future changedNickNameChecked(bool value) async {
    _isNickNameChecked = value;
    notifyListeners();
  }
  Future changedNickNameUnderLine(bool value) async {
    _isNickNameUnderLine = value;
    notifyListeners();
  }
  
  // auth
  bool _isAuthEmailChecked = false;
  bool _isAuthEmailErrorUnderLine = true;
  bool _isAuthEmailDupliCheckUnderLine =true;
  bool _isAuthSendUnderLine = true;
  bool _isAuthTimerChecked = false;
  bool _isAuthSendClick = false;
  bool _isAuthNumber = true;
  bool _isAuthTimeOverChecked = true;
  // AnimationController _controller;

  setAuthEmailChecked(bool value) => _isAuthEmailChecked = value;
  bool get hasAuthEmailChecked => _isAuthEmailChecked;
  setAuthEmailErrorUnderLine(bool value) => _isAuthEmailErrorUnderLine = value;
  bool get hasAuthEmailErrorUnderLine => _isAuthEmailErrorUnderLine;
  setAuthEmailDupliCheckUnderLine(bool value) => _isAuthEmailDupliCheckUnderLine = value;
  bool get hasAuthEmailDupliCheckUnderLine => _isAuthEmailDupliCheckUnderLine;
  setAuthSendUnderLine(bool value) => _isAuthSendUnderLine = value;
  bool get hasAuthSendUnderLine => _isAuthSendUnderLine;
  setAuthTimerChecked(bool value) => _isAuthTimerChecked = value;
  bool get hasAuthTimerChecked => _isAuthTimerChecked;
  setAuthSendClick(bool value) => _isAuthSendClick = value;
  bool get hasAuthSendClick => _isAuthSendClick;
  setAuthNumber(bool value) => _isAuthNumber = value;
  bool get hasAuthNumber => _isAuthNumber;
  setAuthTimeOverChecked(bool value) => _isAuthTimeOverChecked = value;
  bool get hasAuthTimeOverChecked => _isAuthTimeOverChecked;

    Future changedAuthEmailChecked(bool value) async {
    _isAuthEmailChecked = value;
    notifyListeners();
  }
    Future changedAuthEmailErrorUnderLine(bool value) async {
    _isAuthEmailErrorUnderLine = value;
    notifyListeners();
  }
    Future changedAuthEmailDupliCheckUnderLine(bool value) async {
    _isAuthEmailDupliCheckUnderLine = value;
    notifyListeners();
  }
    Future changedAuthSendUnderLine(bool value) async {
    _isAuthSendUnderLine = value;
    notifyListeners();
  }
    Future changedAuthTimerChecked(bool value) async {
    _isAuthTimerChecked = value;
    notifyListeners();
  }
    Future changedAuthSendClick(bool value) async {
    _isAuthSendClick = value;
    notifyListeners();
  }
    Future changedAuthNumber(bool value) async {
    _isAuthNumber = value;
    notifyListeners();
  }
    Future changedAuthTimeOverChecked(bool value) async {
    _isAuthTimeOverChecked = value;
    notifyListeners();
  }

}