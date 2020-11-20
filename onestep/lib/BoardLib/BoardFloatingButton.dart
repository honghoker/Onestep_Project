import 'Boardmain.dart';
import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class BoardFloatingButton {
  final BuildContext context;
  final int index;
  BoardFloatingButton({@required this.index, this.context});

  Widget setFloatingButton(var key) {
    if (index == LISTBOARDIndex) {
      return _1stBoard(true);
    } else {
      // return _2ndBoard(key);
      return buildSpeedDial();
    }
  }

  Widget _1stBoard(bool visible) {
    return Visibility(
        visible: visible,
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.edit),
          backgroundColor: Colors.red,
        ));
  }

  Widget _2ndBoard(var key) {
    return FloatingActionButton(
        onPressed: () {
          // The menu can be handled programatically using a key
          if (key.currentState.isOpen) {
            key.currentState.close();
          } else {
            key.currentState.open();
          }
        },
        child: FabCircularMenu(
            alignment: Alignment.bottomRight,
            ringColor: Colors.white.withAlpha(25),
            ringDiameter: 500.0,
            ringWidth: 150.0,
            fabSize: 64.0,
            fabElevation: 8.0,
            fabIconBorder: CircleBorder(),
            key: key,
            // Also can use specific color based on wether
            // the menu is open or not:
            // fabOpenColor: Colors.white
            // fabCloseColor: Colors.white
            // These properties take precedence over fabColor
            fabColor: Colors.white,
            fabOpenIcon: Icon(Icons.menu, color: Colors.white),
            fabCloseIcon: Icon(Icons.close, color: Colors.white),
            fabMargin: const EdgeInsets.all(16.0),
            animationDuration: const Duration(milliseconds: 800),
            animationCurve: Curves.easeInOutCirc,
            children: <Widget>[
              RawMaterialButton(
                onPressed: () {
                  _showSnackBar(context, "You pressed 1");
                },
                shape: CircleBorder(),
                padding: const EdgeInsets.all(24.0),
                child: Icon(Icons.looks_one, color: Colors.white),
              ),
              RawMaterialButton(
                onPressed: () {
                  _showSnackBar(context, "You pressed 2");
                },
                shape: CircleBorder(),
                padding: const EdgeInsets.all(24.0),
                child: Icon(Icons.looks_two, color: Colors.white),
              ),
              RawMaterialButton(
                onPressed: () {
                  _showSnackBar(context, "You pressed 3");
                },
                shape: CircleBorder(),
                padding: const EdgeInsets.all(24.0),
                child: Icon(Icons.looks_3, color: Colors.white),
              ),
              RawMaterialButton(
                onPressed: () {
                  _showSnackBar(context,
                      "You pressed 4. This one closes the menu on tap");
                  key.currentState.close();
                },
                shape: CircleBorder(),
                padding: const EdgeInsets.all(24.0),
                child: Icon(Icons.looks_4, color: Colors.white),
              )
            ]));
  }

  Widget buildSpeedDial() {
    SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      // child: Icon(Icons.add),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: true,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.accessibility, color: Colors.white),
          backgroundColor: Colors.deepOrange,
          onTap: () => print('FIRST CHILD'),
          label: 'First Child',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.deepOrangeAccent,
        ),
        SpeedDialChild(
          child: Icon(Icons.brush, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () => print('SECOND CHILD'),
          label: 'Second Child',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.green,
        ),
        SpeedDialChild(
          child: Icon(Icons.keyboard_voice, color: Colors.white),
          backgroundColor: Colors.blue,
          onTap: () => print('THIRD CHILD'),
          labelWidget: Container(
            color: Colors.blue,
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(6),
            child: Text('Custom Label Widget'),
          ),
        ),
      ],
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1000),
    ));
  }
}
