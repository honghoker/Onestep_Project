import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:onestep/cloth/models/product.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:onestep/PermissionLib/customPermisson.dart';
import 'models/category.dart';

class ClothModifyWidget extends StatefulWidget {
  final Product product;
  ClothModifyWidget({Key key, this.product}) : super(key: key);

  @override
  _ClothModifyWidgetState createState() => _ClothModifyWidgetState();
}

class _ClothModifyWidgetState extends State<ClothModifyWidget>
    with OneStepPermission {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _titleTextEditingController;
  TextEditingController _priceTextEditingController;
  TextEditingController _explainTextEditingController;
  int _imageCount = 0;
  List<Asset> _imageList = List<Asset>();
  List<dynamic> _initImageList = [];
  String _selectedCategoryItem;
  List<String> _dropdownCategoryItems;

  @override
  void initState() {
    _dropdownCategoryItems =
        Provider.of<Category>(context, listen: false).getCategoryItems();

    _titleTextEditingController =
        TextEditingController(text: widget.product.title);
    _priceTextEditingController =
        TextEditingController(text: widget.product.price);
    _selectedCategoryItem = widget.product.category;
    _explainTextEditingController =
        TextEditingController(text: widget.product.explain);
    initImageList();
    super.initState();
  }

  void initImageList() {
    _initImageList = this.widget.product.images;
    _imageCount = _initImageList.length;
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(width: 3.0),
      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
    );
  }

  List<Widget> imageMerge() {
    List<Widget> result1 = _initImageList
        .map<Widget>(
          (data) => Padding(
            padding: const EdgeInsets.all(4.0),
            child: Stack(
              children: [
                Card(
                  child: ExtendedImage.network(
                    data,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    cache: true,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: ClipOval(
                    child: Material(
                      color: Colors.grey, // button color
                      child: InkWell(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _imageCount = --_imageCount;
                            _initImageList.remove(data);
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();

    List<Widget> result2 = _imageList
        .map<Widget>(
          (data) => Padding(
            padding: const EdgeInsets.all(4.0),
            child: Stack(
              children: [
                Card(
                  child: AssetThumb(
                    asset: data,
                    width: 60,
                    height: 60,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: ClipOval(
                    child: Material(
                      color: Colors.grey, // button color
                      child: InkWell(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _imageCount = --_imageCount;
                            _imageList.remove(data);
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();

    result1.addAll(result2);

    return result1;
  }

  Widget setImageList() {
    return _initImageList.isEmpty && _imageList.isEmpty
        ? Container()
        : Container(
            height: 80,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: imageMerge(),
            ),
          );
  }

  void getImage() async {
    List<Asset> _resultList = List<Asset>();

    _resultList = await MultiImagePicker.pickImages(
      maxImages: 5 - _initImageList.length,
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
      _imageCount = _resultList.length + _initImageList.length;
      _imageList.clear();
      _imageList = _resultList;
    });
  }

  Widget imageAddWidget() {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            checkCamStorePermission(getImage);
          },
          child: Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(5.0),
            decoration: myBoxDecoration(),
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
    } else if (_initImageList.length + _imageList.length < 1) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("물품을 등록하려면 한장 이상의 사진이 필요합니다.")));
    } else {
      var yyDialog = progressDialogBody();
      yyDialog.show();
      List _imgUriarr = [];

      _imgUriarr.addAll(_initImageList);
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

      FirebaseFirestore.instance
          .collection('products')
          .doc(this.widget.product.firestoreid)
          .update({
        'price': _priceTextEditingController.text,
        'title': _titleTextEditingController.text,
        'category': _selectedCategoryItem,
        'explain': _explainTextEditingController.text,
        'images': _imgUriarr,
        'updatetime': DateTime.now(),
      }).whenComplete(() {
        if (Navigator.canPop(context)) {
          yyDialog.dismiss();
          Navigator.pop(context, "OK");
        } else {
          SystemNavigator.pop();
        }
      }).catchError((value) {
        print(value);
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text("Error")));
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
