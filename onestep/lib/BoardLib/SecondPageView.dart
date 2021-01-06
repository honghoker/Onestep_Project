import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'boardList.dart';
import 'boardListView.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:swipedetector/swipedetector.dart';
import 'boardContent.dart';
import 'boardPersonal.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Practice extends StatefulWidget {
  _Temp createState() => _Temp();
}

class _Temp extends State<Practice> {
  // BuildContext context;
  // GeneralBoard(BuildContext context);
  // GeneralBoard({@required this.context}) : assert(context != null);
  final db = FirebaseFirestore.instance
      .collection('Board')
      .doc('Board_Free')
      .collection('Board_Free_BoardId')
      .doc;

  @override
  Widget build(BuildContext context) {
    print(db);
    return Center(child: Container(child: Text('')));
  }
}
