import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:onestep/api/favorite_api.dart';
import 'package:onestep/cloth/clothModifyWidget.dart';
import 'package:onestep/cloth/imageFullViewerWIdget.dart';
import 'package:onestep/favorite/animations/favoriteanimation.dart';
import 'package:onestep/notification/Controllers/notificationManager.dart';
import 'package:onestep/profile/profileWidget.dart';
import 'package:onestep/profile/provider/userProductProvider.dart';
import 'package:onestep/profile/userProductWidget.dart';

import 'package:provider/provider.dart';
import 'package:onestep/api/firebase_api.dart';

import 'clothitem.dart';
import 'models/product.dart';

class ClothDetailViewWidgetcopy extends StatefulWidget {
  final String docId;

  const ClothDetailViewWidgetcopy({Key key, this.docId}) : super(key: key);

  @override
  _ClothDetailViewWidgetcopyState createState() =>
      _ClothDetailViewWidgetcopyState();
}

class _ClothDetailViewWidgetcopyState extends State<ClothDetailViewWidgetcopy> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List _imageItem = new List();
  TextEditingController _favoriteTextController;
  TextEditingController _priceEditingController;
  Product _product;
  @override
  void initState() {
    // dynamic link
    initDynamicLinks();
    super.initState();
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      print(deepLink);
      print(deepLink.path);

      if (deepLink != null) {
        _handleDynamicLink(deepLink);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    print(deepLink);

    if (deepLink != null) {
      _handleDynamicLink(deepLink);
    }
  }

  void _handleDynamicLink(Uri deepLink) {
    switch (deepLink.path) {
      case "/join_family":
        // 여기 부분이 자세히 보기 클릭하면 그 상품으로 가는 Navigator 가 들어가야 하는데 test 한번 해보고
        // 안되면 어케 그 상품 상세보기로 넘어가는지 생각해보기
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ClothDetailViewWidgetcopy(),
        ));
    }
  }

  String getDiffTime(Timestamp uploadtime) {
    final _now = DateTime.now();
    DateTime time = uploadtime.toDate();
    String _differenceTime;

    int _diffresult = (_now.difference(time).inSeconds / 60).floor();

    if (_diffresult > 10080) {
      _differenceTime = DateFormat('MM-dd').format(time);
    } else if (_diffresult < 4320 && _diffresult > 2880) {
      _differenceTime = '그저께';
    } else if (_diffresult > 1440) {
      _differenceTime = (_now.difference(time).inDays).toString() + '일전';
    } else if (_diffresult > 60) {
      _differenceTime = (_now.difference(time).inHours).toString() + '시간전';
    } else if (_diffresult > 1) {
      _differenceTime = (_now.difference(time).inMinutes).toString() + '분전';
    } else {
      _differenceTime = (_now.difference(time).inSeconds).toString() + '초전';
    }

    return _differenceTime;
  }

  Widget setFavorite() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseApi.getId())
            .collection("favorites")
            .where("productid", isEqualTo: this.widget.docId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container();
            default:
              bool chk = snapshot.data.docs.length == 0 ? false : true;
              return GestureDetector(
                onTap: () {
                  int favorites = int.tryParse(_favoriteTextController.text);

                  if (!chk) {
                    FavoriteApi.insertFavorite(this.widget.docId);
                    FavoriteAnimation().showFavoriteDialog(context);
                    favorites++;
                  } else {
                    FavoriteApi.deleteFavorite(
                        snapshot.data.docs[0].id, this.widget.docId);
                    favorites--;
                  }
                  _favoriteTextController.text = (favorites).toString();
                },
                child: Icon(
                  !chk ? Icons.favorite_border : Icons.favorite,
                  color: Colors.pink,
                ),
              );
          }
        });
  }

  Future<DocumentSnapshot> getProduct() async {
    return FirebaseFirestore.instance
        .collection("products")
        .doc(widget.docId)
        .get();
  }

  void incProductViews() {
    // 조회수 증가
    try {
      FirebaseFirestore.instance
          .collection("products")
          .doc(widget.docId)
          .update(
        {
          'views': FieldValue.increment(1),
        },
      );
    } catch (e) {}
  }

  Widget getUserName() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("users")
          .doc(this._product.uid)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text("");
          default:
            return Text(
              snapshot.data['nickname'],
              style: TextStyle(fontWeight: FontWeight.w500),
            );
        }
      },
    );
  }

  Widget getUserProducts() {
    var _size = MediaQuery.of(context).size;
    final double _itemHeight = (_size.height - kToolbarHeight - 24) / 3.0;
    final double _itemWidth = _size.width / 2;

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('products')
          .where('uid', isEqualTo: this._product.uid)
          .where('bumptime', isNotEqualTo: this._product.bumptime)
          .where('deleted', isEqualTo: false)
          .where('hide', isEqualTo: false)
          .orderBy('bumptime', descending: true)
          .limit(4)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text("");
          default:
            if (snapshot.data.docs.isEmpty) {
              return Text("");
            }
            return Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '판매 상품',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Consumer<UserProductProvider>(
                              builder: (context, userProductProvider, _) =>
                                  UserProductWidget(
                                userProductProvider: userProductProvider,
                                uid: _product.uid,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Text(
                            '더보기',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF666666),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
                            size: 20,
                            color: Color(0xFF999999),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.size,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: _itemWidth > _itemHeight
                        ? (_itemHeight / _itemWidth)
                        : (_itemWidth / _itemHeight),
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return ClothItem(
                      product: Product(
                        firestoreid: snapshot.data.docs[index].id,
                        uid: snapshot.data.docs[index].data()['uid'],
                        title: snapshot.data.docs[index].data()['title'],
                        category: snapshot.data.docs[index].data()['category'],
                        price: snapshot.data.docs[index].data()['price'],
                        images: snapshot.data.docs[index].data()['images'],
                      ),
                    );
                  },
                ),
              ],
            );
        }
      },
    );
  }

  Widget renderBody(AsyncSnapshot<DocumentSnapshot> snapshot) {
    return SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Color(0xFFDF0F4),
            height: 430,
            child: Swiper(
              onTap: (index) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageFullViewerWidget(
                        galleryItems: _imageItem,
                        index: index,
                      ),
                    ));
              },
              pagination: SwiperPagination(
                alignment: Alignment.bottomCenter,
                builder: DotSwiperPaginationBuilder(
                  activeColor: Colors.pink,
                  color: Colors.grey,
                ),
              ),
              itemCount: _imageItem.length,
              itemBuilder: (BuildContext context, int index) {
                return ExtendedImage.network(
                  _imageItem[index],
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                  cache: true,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _priceEditingController,
                  enableInteractiveSelection: false,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${snapshot.data.data()['title']}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.local_offer,
                      color: Colors.grey,
                      size: 17,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                    ),
                    Text("${snapshot.data.data()['category']}"),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.access_time,
                      color: Colors.grey,
                      size: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                    ),
                    Text("${getDiffTime(snapshot.data.data()['uploadtime'])}"),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                    ),
                    Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                      size: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                    ),
                    Text("${snapshot.data.data()['views']}"),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                    ),
                    Icon(
                      Icons.favorite,
                      color: Colors.grey,
                      size: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                    ),
                    Container(
                      width: 30,
                      child: TextField(
                        controller: _favoriteTextController,
                        enableInteractiveSelection: false,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${snapshot.data.data()['explain']}",
                  ),
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(
                  height: 80,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileWidget(
                                  uid: _product.uid,
                                )),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('images/profile.png'),
                                fit: BoxFit.cover),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        getUserName(),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                getUserProducts(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case '새로고침':
        break;
      case '신고하기':
        break;
      case '수정하기':
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) => ClothModifyWidget(product: this._product),
          ),
        )
            .then((value) {
          if (value == "OK") {
            setState(() {});
          }
        });
        break;
      case '끌올하기':
        if (DateTime.now().difference(_product.bumptime).inHours >= 1) {
          Navigator.of(context).pushNamed('/BumpProduct', arguments: {
            "PRODUCT": Product(
              firestoreid: widget.docId,
              title: this._product.title,
              price: this._product.price,
              images: this._product.images,
            )
          }).then(
            (value) {
              print("detail");
              if (value == "OK") Navigator.pop(context);
            },
          );
        } else {
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text("끌올은 글 등록,수정 후 1시간뒤에 가능합니다.")));
          print("끌올 불가 메세지 출력");
        }

        break;
      case '숨김':
        // 확인 취소 다이얼로그 띄우기
        FirebaseFirestore.instance
            .collection("products")
            .doc(widget.docId)
            .update({'hide': true});
        break;
      case '삭제':
        // 확인 취소 다이얼로그 띄우기
        FirebaseFirestore.instance
            .collection("products")
            .doc(widget.docId)
            .update({'deleted': true});
        break;
    }
  }

  Widget bottomChatWidget() {
    return Padding(
      padding: EdgeInsets.only(right: 10.0),
      child: SizedBox(
        width: 150,
        child: RaisedButton(
          onPressed: () {
            // FirebaseChatController()
            //     .createChatingRoomToFirebaseStorage(
            //   false,
            //   widget.product.firestoreid,
            //   widget.product.title,
            //   FirebaseApi.getId(),
            //   widget.product.uid,
            // );

            NotificationManager.navigateToChattingRoom(
              context,
              FirebaseApi.getId(),
              this._product.uid,
              this._product.firestoreid,
            );
            //Navigator.of(context).pop();
          },
          color: Colors.pink,
          textColor: Colors.white,
          child: Text('채팅'),
        ),
      ),
    );
  }

  Widget bottomNavigator() {
    return SizedBox(
      height: 70,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black87,
              width: 0.1,
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 60,
              height: 60,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Colors.black87,
                      width: 0.1,
                    ),
                  ),
                ),
                child: setFavorite(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10.0),
            ),
            SizedBox(
              width: 100,
              child: Text(
                "${this._product.price}원",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: Container()),
            if (this._product.uid != FirebaseApi.getId()) bottomChatWidget(),
          ],
        ),
      ),
    );
  }

  Widget popupMenuButton() {
    return PopupMenuButton<String>(
      onSelected: handleClick,
      itemBuilder: (BuildContext context) {
        var menuItem = List<String>();
        if (FirebaseApi.getId() == this._product.uid)
          menuItem.addAll({'끌올하기', '수정하기', '새로고침', '숨김', '삭제'});
        else {
          menuItem.addAll({'새로고침', '신고하기'});
        }

        return menuItem.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  void _testModalBottomSheet(
      context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * .30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(125, 0, 0, 0),
                        child: Center(
                            child: Container(
                                child: Text(
                          "공유하기",
                          style: TextStyle(fontSize: 15),
                        ))),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Column(
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              print("kakao 1");
                              // kakato test
                              // 일단 주석처리 detail 잡아야함
                              // KakaoShareManager()
                              //     .isKakaotalkInstalled()
                              //     .then((installed) {
                              //   if (installed) {
                              //     print("kakao success");
                              //     KakaoShareManager().shareMyCode("abcd",snapshot,_imageItem[0]);
                              //   } else {
                              //     print("kakao error");
                              //     // show alert
                              //   }
                              // });
                            },
                            constraints:
                                BoxConstraints(minHeight: 80, minWidth: 80),
                            fillColor: Colors.white,
                            child: IconButton(
                              icon: Image.asset(
                                  'assets/images/free-icon-kakao-talk-2111466.png'),
                              onPressed: () {
                                print("kakao 2");
                                // KakaoShareManager()
                                //     .isKakaotalkInstalled()
                                //     .then((installed) {
                                //   if (installed) {
                                //     print("kakao success");
                                //     KakaoShareManager().shareMyCode(
                                //         "abcd", snapshot, _imageItem[0]);
                                //   } else {
                                //     print("kakao error");
                                //     // show alert
                                //   }
                                // });
                              },
                            ),
                            shape: CircleBorder(),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child:
                                Center(child: Container(child: Text("카카오톡"))),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Column(
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              print("URL");
                              // URL
                              // KakaoShareManager().getDynamicLink("abcd",snapshot,_imageItem[0]);
                            },
                            constraints:
                                BoxConstraints(minHeight: 80, minWidth: 80),
                            fillColor: Colors.white,
                            child: IconButton(
                              icon: Image.asset(
                                  'assets/images/iconfinder_link_hyperlink_5402394.png'),
                              onPressed: () {
                                // KakaoShareManager().getDynamicLink("abcd",snapshot,_imageItem[0]);
                              },
                            ),
                            shape: CircleBorder(),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Center(child: Container(child: Text("URL"))),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget shareButton(AsyncSnapshot<DocumentSnapshot> snapshot) {
    return new IconButton(
      icon: new Icon(Icons.share),
      onPressed: () => {
        print("share"),
        _testModalBottomSheet(context, snapshot),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getProduct(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text("");
            default:
              if (snapshot.data.data()['deleted'] ||
                  snapshot.data.data()['hide']) {
                return Container(
                  child: Center(
                    child: Text("없는 상품이에요."),
                  ),
                );
              } else {
                _product =
                    Product.fromJson(snapshot.data.data(), snapshot.data.id);
                _imageItem = snapshot.data.data()['images'];
                _priceEditingController =
                    TextEditingController(text: this._product.price + "원");

                List<dynamic> favorite =
                    snapshot.data.data()['favoriteUserList'];
                int favoritecount = favorite == null ? 0 : favorite.length;
                _favoriteTextController =
                    TextEditingController(text: favoritecount.toString());

                incProductViews(); // 조회수 증가
                return Scaffold(
                  key: _scaffoldKey,
                  appBar: AppBar(
                    iconTheme: IconThemeData(
                      color: Colors.black,
                    ),
                    title: Text(
                      '상세보기',
                      style: TextStyle(color: Colors.black),
                    ),
                    backgroundColor: Colors.white,
                    actions: <Widget>[
                      shareButton(snapshot),
                      popupMenuButton(),
                    ],
                  ),
                  body: renderBody(snapshot),
                  bottomNavigationBar: bottomNavigator(),
                );
              }
          }
        });
  }
}
