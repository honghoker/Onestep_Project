import 'package:flutter/material.dart';
import './pill_gesture.dart';
import 'package:flutter/services.dart';

class SlideDialog extends StatefulWidget {
  final Widget child;
  final Color backgroundColor;
  final Color pillColor;
  final double size;
  SlideDialog(
      {
      // @required this.child,
      // @required this.pillColor,
      // @required this.backgroundColor,
      this.child,
      this.pillColor,
      this.backgroundColor,
      this.size});

  @override
  _SlideDialogState createState() => _SlideDialogState();
}

class _SlideDialogState extends SlideParentState<SlideDialog> {
  @override
  passData() {
    // TODO: implement passData
    throw UnimplementedError();
  }
}

abstract class SlideParentState<T extends StatefulWidget> extends State<T> {
  SlideParentState(
      {this.setBackgroundColor,
      this.setChild,
      this.setpillColor,
      this.dialogSize});
  var _initialPosition = 0.0;
  var _currentPosition = 0.0;
  var setBackgroundColor;
  var setpillColor;
  double dialogSize;
  Widget setChild;
  var _dialogPadding;
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    dialogSize = dialogSize ?? 1.5;
    _dialogPadding = MediaQuery.of(context).viewInsets +
        EdgeInsets.only(top: deviceHeight / 3.0 + _currentPosition);
    return AnimatedPadding(
      // padding: MediaQuery.of(context).viewInsets,
      padding: _dialogPadding,
      duration: Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: GestureDetector(
          onTapDown: (details) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Center(
            child: Container(
              width: deviceWidth,
              height: deviceHeight / 1.5,
              child: Material(
                color: setBackgroundColor ??
                    Theme.of(context).dialogBackgroundColor,
                elevation: 24.0,
                type: MaterialType.card,
                child: Column(
                  children: <Widget>[
                    PillGesture(
                      pillColor: setpillColor,
                      onVerticalDragStart: _onVerticalDragStart,
                      onVerticalDragEnd: _onVerticalDragEnd,
                      onVerticalDragUpdate: _onVerticalDragUpdate,
                    ),
                    setChild ?? setChildMethod(),
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  setChildMethod() {
    return Text("No Widget");
  }

  void _onVerticalDragStart(DragStartDetails drag) {
    setState(() {
      _initialPosition = drag.globalPosition.dy;
    });
  }

  void _onVerticalDragUpdate(DragUpdateDetails drag) {
    setState(() {
      final temp = _currentPosition;
      _currentPosition = drag.globalPosition.dy - _initialPosition;
      if (_currentPosition < 0) {
        _currentPosition = temp;
      }
    });
  }

  void _onVerticalDragEnd(DragEndDetails drag) {
    if (_currentPosition > 100.0) {
      passData();
      return;
    }
    setState(() {
      _currentPosition = 0.0;
    });
  }

  passData();
}
