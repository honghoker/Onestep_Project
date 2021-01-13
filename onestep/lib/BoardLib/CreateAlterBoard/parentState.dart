import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onestep/BoardLib/mySlideOverDialog/slide_dialog.dart';
import 'package:onestep/BoardLib/mySlideOverDialog/slide_popup_dialog.dart'
    as slideDialog;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:onestep/PermissionLib/customPermisson.dart';
import 'package:onestep/BoardLib/BoardProvi/boardClass.dart';
import 'package:tip_dialog/tip_dialog.dart';
import 'package:onestep/BoardLib/CustomException/customThrow.dart';

enum ContentCategory { SMALLTALK, QUESTION }

extension ContentCategoryExtension on ContentCategory {
  String get category {
    switch (this) {
      case ContentCategory.QUESTION:
        return "질문";
      case ContentCategory.SMALLTALK:
        return "일상";
      default:
        return throw ContentCategoryException(
            "Enum Category Error, Please Update Enum ContentCategory in parentState.dart");
    }
  }
}

const int MAX_IMAGE_COUNT = 5;

class CreateBoard extends StatefulWidget {
  final String currentBoard;
  CreateBoard({Key key, this.currentBoard}) : super(key: key);

  @override
  _CreateBoardState createState() => _CreateBoardState();
}

class _CreateBoardState extends _CreatePageParent<CreateBoard> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  setBoardData() {
    currentBoard = widget.currentBoard;
  }
}

abstract class _CreatePageParent<T extends StatefulWidget> extends State<T>
    with OneStepPermission {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // CustomSlideDialog customSlideDialog;
  ContentCategory _category;
  TextEditingController textEditingControllerContent;
  ScrollController _scrollController;
  BoardData boardData;
  String currentBoard;
  String _title;
  setBoardData();
  List<Asset> images = [];

  @override
  void initState() {
    super.initState();
    setBoardData();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    textEditingControllerContent = new TextEditingController();
    _scrollController = new ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: WillPopScope(
              onWillPop: () {
                _isDataContain()
                    ? Navigator.pop(context)
                    : _navigatorPopAlertDialog();
              },
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Scaffold(
                  key: _scaffoldKey,
                  body: SafeArea(
                    minimum: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: <Widget>[
                          firstContainer(),
                          displayCurrentBoard(boardName: currentBoard),
                          secondContainer(),
                          thirdContainer(),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ),
        TipDialogContainer(duration: const Duration(seconds: 2))
      ],
    );
  }

  displayCurrentBoard({String boardName}) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text("게시되는 곳 : "),
            Text(
              "${boardName ?? ''}",
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
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
          Flexible(
            child: GestureDetector(
              onTap: () {
                _isDataContain()
                    ? Navigator.pop(context)
                    : _navigatorPopAlertDialog();
              },
              child: Container(
                child: Text(
                  "취소",
                  style: _textStyle,
                ),
              ),
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () async {
                Map<String, dynamic> _result =
                    await slideDialog.showSlideDialog(
                        context: context,
                        customSlideDialog: new CustomSlideDialog(
                            category: _category, title: _title));
                setState(() {
                  if (_result["title"] != '') {
                    _title = _result["title"];
                    _category = _result["category"];
                  }
                });
              },
              child: Container(
                child: Text(
                  _title ?? "제목을 입력하세요.",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _textStyle,
                ),
              ),
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () async {
                var _result = _checkDataContain();
                if (_result.runtimeType == bool) {
                  if (_result) {
                    _saveDataInFirestore();
                  }
                } else if (_result.runtimeType == String) {
                  print(_result);
                  switch (_result.toString()) {
                    case "CONTENT":
                      _scaffoldKey.currentState.showSnackBar(
                          showSnackBar(textMessage: Text("내용을 입력하세요.")));
                      break;
                    case "CATEGORY":
                      _scaffoldKey.currentState.showSnackBar(
                          showSnackBar(textMessage: Text("카테고리 분류를 입력하세요.")));
                      break;
                    case "TITLE":
                      _scaffoldKey.currentState.showSnackBar(
                          showSnackBar(textMessage: Text("제목을 입력하세요.")));
                      break;
                  }
                }
              },
              child: Container(
                child: Text(
                  "작성",
                  style: _textStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _saveDataInFirestore() async {
    TipDialogHelper.loading("저장 중입니다. 잠시만 기다려주세요.");
    await saveData();
    TipDialogHelper.dismiss();
    TipDialogHelper.success("저장 완료!");
  }

  Future saveData() async {
    BoardData _boardData = BoardData(
        title: _title,
        imageList: images,
        textContent: textEditingControllerContent.text,
        contentCategory: _category.toString());
    return await _boardData.toFireStore(context);
    // return Future.delayed(new Duration(seconds: 5));
  }

  showSnackBar(
      {@required Text textMessage,
      SnackBarAction snackBarAction,
      Duration duration}) {
    return SnackBar(
      duration: duration ?? Duration(milliseconds: 500),
      action: snackBarAction ?? null,
      content: textMessage,
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

  _checkDataContain() {
    String content = textEditingControllerContent.text.trim();
    if (_title != null && _title != '') {
      if (_category != null) {
        if (content != null && content != '') {
          return true;
        } else {
          return "CONTENT";
        }
      } else {
        return "CATEGORY";
      }
    } else {
      return "TITLE";
    }
  }

  _isDataContain() {
    String content = textEditingControllerContent.text.trim();
    if (_title == null || _title == '') {
      if (_category == null) {
        if (content == null || content == '') {
          if (images.isEmpty) return true;
        }
      }
    }
    return false;
  }

  _navigatorPopAlertDialog() async {
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

  _imageContainer({Asset imageAsset, int index}) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: SizedBox(
        height: 50,
        width: 50,
        child: GestureDetector(
            onTap: () {
              if (imageAsset == null) checkCamStorePermission(getImage);
            },
            child: imageAsset != null
                ? Container(
                    child: PopupMenuButton<int>(
                        onSelected: (value) {
                          Asset _undoImage = images[index];
                          if (value == 0) {
                            setState(() {
                              images.removeAt(index);
                            });
                            _scaffoldKey.currentState.showSnackBar(showSnackBar(
                                textMessage:
                                    Text("${index + 1}번째 이미지가 삭제되었습니다."),
                                duration: Duration(milliseconds: 1500),
                                snackBarAction: SnackBarAction(
                                    label: "되돌리기",
                                    onPressed: () {
                                      setState(() {
                                        images.insert(index, _undoImage);
                                      });
                                    })));
                          }
                        },
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 0,
                                child: Text(
                                  "삭제",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                        child: Container(
                            child: AssetThumb(
                          asset: imageAsset,
                          height: 200,
                          width: 200,
                        ))))
                : Container(
                    child: Icon(Icons.add),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  )),
      ),
    );
  }

  getImage() async {
    List<Asset> resultList = [];
    resultList = await MultiImagePicker.pickImages(
        maxImages: 5, enableCamera: true, selectedAssets: images);
    setState(() {
      images = resultList;
    });
  }

  thirdContainer({Widget popUpMenu}) {
    List<Widget> _containerList = [];
    for (int i = 0; i < MAX_IMAGE_COUNT; i++) {
      if (images.isNotEmpty) {
        if (i < images.length) {
          _containerList.add(_imageContainer(imageAsset: images[i], index: i));
          continue;
        }
      }
      _containerList.add(_imageContainer(index: i));
    }
    return Row(children: _containerList);
  }
}

class CustomSlideDialog extends StatefulWidget {
  final String title;
  final ContentCategory category;
  CustomSlideDialog({Key key, this.title, this.category}) : super(key: key);
  @override
  _CustomSlideDialogState createState() => _CustomSlideDialogState();
}

class _CustomSlideDialogState extends SlideParentState<CustomSlideDialog> {
  TextEditingController _textEditingController = TextEditingController();

  ContentCategory _category;
  @override
  void initState() {
    super.initState();
    _category = widget.category ?? null;
    _textEditingController..text = widget.title ?? '';
  }

  @override
  Widget setChildMethod() {
    List<Widget> _radioList = [
      RadioListTile(
          title: Text("일상"),
          value: ContentCategory.SMALLTALK,
          groupValue: _category,
          onChanged: (value) {
            setState(() {
              _category = value;
            });
          }),
      RadioListTile(
          title: Text("질문"),
          value: ContentCategory.QUESTION,
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
