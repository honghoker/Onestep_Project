import 'package:flutter/material.dart';

class ReadCounter with ChangeNotifier {
  int _readCounter = 1;

  ReadCounter(this._readCounter);
  int getCounter() {
    return _readCounter;
  }

  getCounterText() => _readCounter.toString();
  prints() => print("#####호출");

  void setCounter(int counter) {
    _readCounter = counter;
    print("Counter : $_readCounter");
  }

  void increment() {
    _readCounter++;
    notifyListeners();
  }

  void decrement() {
    _readCounter--;
    notifyListeners();
  }
}
