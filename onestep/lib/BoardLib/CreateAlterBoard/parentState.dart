import 'package:flutter/material.dart';
import 'package:onestep/BoardLib/boardProvider/BoardClass.dart';
import 'package:flutter/services.dart';
import 'package:onestep/BoardLib/mySlideOverDialog/slide_dialog.dart';
import 'package:onestep/BoardLib/mySlideOverDialog/slide_popup_dialog.dart'
    as slideDialog;
import 'package:multi_image_picker/multi_image_picker.dart';

enum BoardCategory { SMALLTALK, QUESTION }
const int MAX_IMAGE_COUNT = 5;

class CreateBoard extends StatefulWidget {
  CreateBoard({Key key}) : super(key: key);

  @override
  _CreateBoardState createState() => _CreateBoardState();
}

class _CreateBoardState extends _CreatePageParent<CreateBoard> {
  @override
  void dispose() {
    super.dispose();
  }
}

abstract class _CreatePageParent<T extends StatefulWidget> extends State<T> {
  CustomSlideDialog customSlideDialog;
  BoardCategory _category;
  String _error = 'No Error Dectected';
  TextEditingController textEditingControllerContent;
  ScrollController _scrollController;
  BoardData boardData;
  String _title;

  List<Asset> images = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    textEditingControllerContent = new TextEditingController();
    _scrollController = new ScrollController();
    customSlideDialog = CustomSlideDialog();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // TextEditingController textEditingController;
  @override
  Widget build(BuildContext context) {
    // return Container(child: Text('HI'));
    return WillPopScope(
        onWillPop: () {
          _isDataContain()
              ? Navigator.pop(context)
              : _navigatorPopAlterDialog();
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            body: SafeArea(
              minimum: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: <Widget>[
                    firstContainer(),
                    secondContainer(),
                    thirdContainer(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  firstContainer() {
    TextStyle _textStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
    return Container(
      padding: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              _isDataContain()
                  ? Navigator.pop(context)
                  : _navigatorPopAlterDialog();
            },
            child: Container(
              child: Text(
                "취소",
                style: _textStyle,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              Map<String, dynamic> _result = await slideDialog.showSlideDialog(
                  context: context, customSlideDialog: customSlideDialog);
              setState(() {
                if (_result["title"] != '') {
                  _title = _result["title"];
                  _category = _result["category"];
                }
              });
              // print(a.keys);
            },
            child: Container(
              child: Text(
                _title ?? "제목을 입력하세요.",
                style: _textStyle,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              child: Text(
                "작성",
                style: _textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  secondContainer() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: textEditingControllerContent,
        minLines: 20,
        maxLines: null,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "",
          hintText: "내용을 입력하세요",
        ),
      ),
    );
  }

  bool _isDataContain() {
    String content = textEditingControllerContent.text.trim();
    if (_title == null || _title == '') {
      if (_category == null) {
        if (content == null || content == '') {
          return true;
        }
      }
    }
    return false;
  }

  _navigatorPopAlterDialog() async {
    String result = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('작성 중'),
          content: Text("변경된 내용은 저장이 되지 않습니다."),
          actions: <Widget>[
            FlatButton(
              child: Text('나가기'),
              onPressed: () {
                // Navigator.of(context)
                //     .popUntil(ModalRoute.withName('/MainPage'));
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
              },
            ),
            FlatButton(
              child: Text('유지'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  _imageContainer({Asset imageAsset}) {
    Container imageRendering = imageAsset != null
        ? Container(
            child: AssetThumb(
            asset: imageAsset,
            height: 200,
            width: 200,
          ))
        : Container(
            child: Icon(Icons.add),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
          );
    return Container(
      padding: EdgeInsets.all(5.0),
      child: SizedBox(
        height: 50,
        width: 50,
        child: GestureDetector(
            onTap: () {
              // print("hi");
              getImage();
            },
            child: imageRendering),
      ),
    );
  }

  getImage() async {
    List<Asset> resultList = [];
    resultList =
        await MultiImagePicker.pickImages(maxImages: 5, enableCamera: true);
    setState(() {
      images = resultList;
    });
  }

  thirdContainer() {
    List<Widget> _containerList = [];
    for (int i = 0; i < MAX_IMAGE_COUNT; i++) {
      if (images.isNotEmpty) {
        if (i < images.length) {
          _containerList.add(_imageContainer(imageAsset: images[i]));
          continue;
        }
      }
      _containerList.add(_imageContainer());
    }
    return Row(children: _containerList);
  }
}

class CustomSlideDialog extends StatefulWidget {
  CustomSlideDialog({Key key}) : super(key: key);
  @override
  _CustomSlideDialogState createState() => _CustomSlideDialogState();
}

class _CustomSlideDialogState extends SlideParentState<CustomSlideDialog> {
  TextEditingController _textEditingController = TextEditingController();

  BoardCategory _category;
  @override
  Widget setChildMethod() {
    List<Widget> _radioList = [
      RadioListTile(
          value: BoardCategory.SMALLTALK,
          groupValue: _category,
          onChanged: (value) {
            setState(() {
              _category = value;
            });
          }),
      RadioListTile(
          value: BoardCategory.QUESTION,
          groupValue: _category,
          onChanged: (value) {
            setState(() {
              _category = value;
            });
          }),
    ];

    return Container(
        child: Column(
      children: [
        Container(
            child: TextField(
          onSubmitted: (value) {
            Navigator.pop(context, {
              "title": _textEditingController.text.trim(),
              "category": _category
            });
          },
          controller: _textEditingController,
          decoration:
              InputDecoration(border: OutlineInputBorder(), labelText: "제목"),
        )),
        Text(
          "앤터를 누르면 글쓰기 화면으로 전환됩니다.",
          style: TextStyle(color: Colors.grey),
        ),
        Container(
            child: Column(
          children: _radioList,
        )),
      ],
    ));
  }

  @override
  passData() {
    Navigator.pop(context,
        {"title": _textEditingController.text.trim(), "category": _category});
  }
}
