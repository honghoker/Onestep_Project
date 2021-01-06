import 'package:flutter/material.dart';

class MultiQuery extends StatefulWidget {
  @override
  _MultiQueryState createState() => _MultiQueryState();
}

class _MultiQueryState extends State<MultiQuery> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void test() {
    final f1 = getValue(delay: 1, value: 1);
    final f2 = getValue(delay: 5, value: 2);
    final f3 = getValue(delay: 2, value: 3);
    final f4 = getValue(delay: 3, value: 4);

    Future.wait([f1, f2, f3, f4]).then((value) => print(value));
  }

  Future<int> getValue({int delay, int value}) =>
      Future.delayed(Duration(seconds: delay), () => Future.value(value));
}
