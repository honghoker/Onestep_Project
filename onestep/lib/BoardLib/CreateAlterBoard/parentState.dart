import 'package:flutter/material.dart';
import 'package:onestep/BoardLib/boardProvider/BoardClass.dart';
import 'package:flutter/services.dart';

class CreateBoard extends StatefulWidget {
  CreateBoard({Key key}) : super(key: key);

  @override
  _CreateBoardState createState() => _CreateBoardState();
}

class _CreateBoardState extends _CreatePageParent<CreateBoard> {
  @override
  setBoardData() {}

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     child: Text("hi"),
  //   );
  // }
}

abstract class _CreatePageParent<T extends StatefulWidget> extends State<T> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    _scrollController = new ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  TextEditingController textEditingControllerTitle;
  TextEditingController textEditingControllerContent;
  ScrollController _scrollController;
  BoardData boardData;
  // TextEditingController textEditingController;
  setBoardData();
  @override
  Widget build(BuildContext context) {
    // return Container(child: Text('HI'));
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: <Widget>[
              firstContainer(),
            ],
          ),
        ),
      ),
    );
  }

  firstContainer() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              _dateInitCheck()
                  ? Navigator.pop(context)
                  : _navigatorPopAlterDialog();
            },
            child: Container(
              child: Text("취소"),
            ),
          ),
          GestureDetector(
            child: Container(
              child: Text("취소"),
            ),
          ),
          GestureDetector(
            child: Container(
              child: Text("취소"),
            ),
          ),
        ],
      ),
    );
  }

  secondContainer() {}
  _dateInitCheck() {
    return false;
  }

  _navigatorPopAlterDialog() async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('작성 중'),
          content: Text("변경된 내용은 저장이 되지 않습니다."),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context)
                    .popUntil(ModalRoute.withName('/BoardContent'));
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, "Cancel");
              },
            ),
          ],
        );
      },
    );
  }
}
