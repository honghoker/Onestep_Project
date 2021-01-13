import 'package:flutter/material.dart';

class Count extends StatelessWidget {
  final int count;
  final Function(int) onCountChange;
  const Count({Key key, @required this.count, this.onCountChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}
