import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:onestep/PermissionLib/customPermisson.dart';
import 'models/category.dart';

class ClothAddWidget extends StatefulWidget {
  ClothAddWidget({Key key}) : super(key: key);

  @override
  _ClothAddWidgetState createState() => _ClothAddWidgetState();
}

class _ClothAddWidgetState extends State<ClothAddWidget>
    with OneStepPermission {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _titleTextEditingController = TextEditingController();
  final _priceTextEditingController = TextEditingController();
  final _explainTextEditingController = TextEditingController();
  int _imageCount = 0;
  List<Asset> _imageList = List<Asset>();

  String _selectedCategoryItem;
  List<String> _dropdownCategoryItems;
  @override
  void initState() {
    _dropdownCategoryItems =
        Provider.of<Category>(context, listen: false).getCategoryItems();
    super.initState();
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(width: 3.0),
      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
    );
  }

  Widget setImageList() {
    return _imageList.isEmpty
        ? Container()
        : Container(
            height: 80,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imageList.length,
              itemBuilder: (BuildContext context, int index) {
                return new Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    child: AssetThumb(
                      asset: _imageList[index],
                      width: 60,
                      height: 60,
                    ),
                  ),
                );
              },
            ),
          );
  }

  void getImage() async {
    List<Asset> _resultList = List<Asset>();

    _resultList = await MultiImagePicker.pickImages(
      maxImages: 5,
      enableCamera: true,
      selectedAssets: _imageList,
      cupertinoOptions: CupertinoOptions(
        takePhotoIcon: "chat",
      ),
      materialOptions: MaterialOptions(
        // actionBarTitle: "앨범",
        actionBarColor: "#abcdef",
        actionBarTitleColor: "#000000",
        statusBarColor: "#000000",
        // allViewTitle: "전체사진",
        useDetailsView: true,
        selectCircleStrokeColor: "#000000",
      ),
    );

    if (_resultList.isEmpty) return;
    setState(() {
      _imageCount = _resultList.length;
      _imageList.clear();
      _imageList = _resultList;
    });
  }
  // void getImage() async {
  //   try {
  //     Map<Permission, PermissionStatus> _statuses = await permissionRequest();
  //     if (!(_statuses.containsValue("PermissionStatus.granted") ||
  //         _statuses.containsValue("PermissionStatus.restricted") ||
  //         _statuses.containsValue("PermissionStatus.permanentlyDenied"))) {
  //       List<Asset> _resultList = List<Asset>();

  //       _resultList = await MultiImagePicker.pickImages(
  //         maxImages: 5,
  //         enableCamera: true,
  //         selectedAssets: _imageList,
  //         cupertinoOptions: CupertinoOptions(
  //           takePhotoIcon: "chat",
  //         ),
  //         materialOptions: MaterialOptions(
  //           // actionBarTitle: "앨범",
  //           actionBarColor: "#abcdef",
  //           actionBarTitleColor: "#000000",
  //           statusBarColor: "#000000",
  //           // allViewTitle: "전체사진",
  //           useDetailsView: true,
  //           selectCircleStrokeColor: "#000000",
  //         ),
  //       );

  //       if (_resultList.isEmpty) return;
  //       setState(() {
  //         _imageCount = _resultList.length;
  //         _imageList.clear();
  //         _imageList = _resultList;
  //       });
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  Widget imageAddWidget() {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            // getImage();
            checkCamStorePermission(getImage);
            print("getImage()");
          },
          child: Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(5.0),
            decoration: myBoxDecoration(), //       <--- BoxDecoration here
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.photo_camera,
                  color: Colors.black,
                  size: 15,
                ),
                Text("$_imageCount/5"),
              ],
            ),
          ),
        ),
        Expanded(
          child: setImageList(),
        ),
      ],
    );
  }

  Future<void> uploadProduct() async {
    if (_titleTextEditingController.text.trim() == "") {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("제목을 입력해주세요.")));
    } else if (_priceTextEditingController.text.trim() == "") {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("가격을 입력해주세요.")));
    } else if (_selectedCategoryItem == null) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("카테고리를 선택해주세요.")));
    } else if (_explainTextEditingController.text.trim() == "") {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("설명을 입력해주세요.")));
    } else if (_imageList.length < 1) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("물품을 등록하려면 한장 이상의 사진이 필요합니다.")));
    } else {
      var yyDialog = progressDialogBody();
      yyDialog.show();
      List _imgUriarr = [];

      for (var imaged in _imageList) {
        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child("productimage/${randomAlphaNumeric(15)}");
        StorageUploadTask storageUploadTask = storageReference
            .putData((await imaged.getByteData()).buffer.asUint8List());
        await storageUploadTask.onComplete;
        String downloadURL = await storageReference.getDownloadURL();
        _imgUriarr.add(downloadURL);
      }

      FirebaseFirestore.instance.collection('products').add({
        'uid': FirebaseApi.getId(),
        'price': _priceTextEditingController.text,
        'title': _titleTextEditingController.text,
        'category': _selectedCategoryItem,
        'explain': _explainTextEditingController.text,
        'images': _imgUriarr,
        'favorites': 0,
        'hide': false,
        'deleted': false,
        'views': 0,
        'uploadtime': DateTime.now(),
        'updatetime': DateTime.now(),
        'bumptime': DateTime.now(),
      }).whenComplete(() {
        if (Navigator.canPop(context)) {
          yyDialog.dismiss();
          Navigator.pop(context, "OK");
        } else {
          SystemNavigator.pop();
        }
      }).catchError((value) {
        print(value);
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text("물품을 등록하려면 두장 이상의 사진이 필요합니다.")));
      });
    }
  }

  YYDialog progressDialogBody() {
    return YYDialog().build(context)
      ..width = 200
      ..borderRadius = 4.0
      ..barrierDismissible = false
      ..circularProgress(
        padding: EdgeInsets.all(24.0),
        valueColor: Colors.orange[500],
      )
      ..text(
        padding: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 12.0),
        text: "저장 중",
        alignment: Alignment.center,
        color: Colors.orange[500],
        fontSize: 14.0,
      );
  }

  void uploadProductDialog() async {
    showDialog(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          // insetPadding: EdgeInsets.symmetric(horizontal: 90, vertical: 100),
          title: Text(
            '물품을 등록할까요?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(
                '확인',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            CupertinoDialogAction(
              child: Text(
                '취소',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    ).then((value) {
      if (value == true) {
        uploadProduct();
      }
    });
    // await YYDialog().build(context)
    //   ..width = 220
    //   ..borderRadius = 4.0
    //   ..text(
    //     padding: EdgeInsets.all(25.0),
    //     alignment: Alignment.center,
    //     text: "물품을 등록할까요?",
    //     color: Colors.black,
    //     fontSize: 14.0,
    //     fontWeight: FontWeight.w500,
    //   )
    //   ..divider()
    //   ..doubleButton(
    //     padding: EdgeInsets.only(top: 10.0),
    //     gravity: Gravity.center,
    //     withDivider: true,
    //     text1: "확인",
    //     color1: Colors.redAccent,
    //     fontSize1: 14.0,
    //     fontWeight1: FontWeight.bold,
    //     onTap1: () {
    //       return false;
    //     },
    //     text2: "취소",
    //     color2: Colors.redAccent,
    //     fontSize2: 14.0,
    //     fontWeight2: FontWeight.bold,
    //     onTap2: () {
    //       return true;
    //     },
    //   )
    //   ..show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "물품 등록",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.check),
              onPressed: () => {
                    uploadProductDialog(),
                  }),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              imageAddWidget(),
              Container(
                margin: EdgeInsets.all(10),
                child: TextField(
                  controller: _titleTextEditingController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '제목',
                    counterText: "",
                  ),
                  maxLength: 20,
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: TextField(
                  controller: _priceTextEditingController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    ThousandsFormatter(),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '가격',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: '카테고리',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: new Text("카테고리를 선택해주세요"),
                      value: _selectedCategoryItem,
                      isDense: true,
                      onChanged: (String newValue) {
                        setState(() {
                          _selectedCategoryItem = newValue;
                          // state.didChange(newValue);
                        });
                      },
                      items: _dropdownCategoryItems.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: TextField(
                  controller: _explainTextEditingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '설명',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
