import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:onestep/cloth/imageFullViewerWIdget.dart';
import 'package:onestep/moor/moor_database.dart';
import 'package:onestep/notification/Controllers/notificationManager.dart';
import 'package:moor_flutter/moor_flutter.dart' as mf;
import 'package:onestep/profile/profileWidget.dart';
import 'package:onestep/profile/provider/userProductProvider.dart';
import 'package:onestep/profile/userProductWidget.dart';

import 'animations/favoriteanimation.dart';
import 'package:provider/provider.dart';
import 'package:onestep/api/firebase_api.dart';

import 'clothitem.dart';

class ClothDetailViewWidgetcopy extends StatefulWidget {
  final Product product;

  const ClothDetailViewWidgetcopy({Key key, this.product}) : super(key: key);

  @override
  _ClothDetailViewWidgetcopyState createState() =>
      _ClothDetailViewWidgetcopyState();
}

class _ClothDetailViewWidgetcopyState extends State<ClothDetailViewWidgetcopy> {
  List _imageItem = new List();
  TextEditingController _textcontroller;
  TextEditingController priceEditingController;
  Product _product;
  @override
  void initState() {
    _imageItem.addAll(jsonDecode(widget.product.images));

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
        // do something
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
      // do something
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
    ProductsDao p = Provider.of<AppDatabase>(context).productsDao;

    return StreamBuilder<mf.QueryRow>(
      stream: p.watchsingleProduct(this.widget.product.firestoreid),
      builder: (BuildContext context, AsyncSnapshot<mf.QueryRow> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text("");
          default:
            return GestureDetector(
              onTap: () {
                int favorites = int.tryParse(_textcontroller.text);
                bool chk = !snapshot.hasData;

                if (chk) {
                  // Product pro = this
                  //     .widget
                  //     .product
                  //     .copyWith(favoritetime: DateTime.now());

                  this.widget.product.favoritetime = DateTime.now();
                  p.insertProduct(this.widget.product);
                  favorites++;
                } else {
                  p.deleteProduct(this.widget.product);
                  favorites--;
                }
                FavoriteAnimation().incdecProductFavorites(
                    chk, context, this.widget.product.firestoreid);
                _textcontroller.text = (favorites).toString();
              },
              child: Icon(
                !snapshot.hasData ? Icons.favorite_border : Icons.favorite,
                color: Colors.pink,
              ),
            );
        }
      },
    );
  }

  Future<DocumentSnapshot> getProduct() async {
    return FirebaseFirestore.instance
        .collection("products")
        .doc(widget.product.firestoreid)
        .get();
  }

  void incProductViews(int views) {
    // 조회수 증가
    try {
      FirebaseFirestore.instance
          .collection("products")
          .doc(widget.product.firestoreid)
          .update(
        {
          'views': views,
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
    final double _itemHeight = (_size.height - kToolbarHeight - 24) / 2.0;
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
                        hide: snapshot.data.docs[index].data()['hide'] ? 1 : 0,
                        deleted:
                            snapshot.data.docs[index].data()['deleted'] ? 1 : 0,
                        images: jsonEncode(
                            snapshot.data.docs[index].data()['images']),
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
                  controller: priceEditingController,
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
                      fontWeight: FontWeight.w500,
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
                        controller: _textcontroller,
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
        break;
      case '끌올하기':
        if (DateTime.now().difference(_product.bumptime).inHours >= 1) {
          Navigator.of(context).pushNamed(
            '/BumpProduct',
            arguments: {"PRODUCT": widget.product},
          ).then(
            (value) {
              print("detail");
              if (value == "OK") Navigator.pop(context);
            },
          );
        } else {
          print("끌올 불가 메세지 출력");
        }

        break;
      case '숨김':
        FirebaseFirestore.instance
            .collection("products")
            .doc(widget.product.firestoreid)
            .update({'hide': true});
        break;
      case '삭제':
        FirebaseFirestore.instance
            .collection("products")
            .doc(widget.product.firestoreid)
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
              widget.product.uid,
              widget.product.firestoreid,
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
                "${widget.product.price}원",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: Container()),
            if (widget.product.uid != FirebaseApi.getId()) bottomChatWidget(),
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
        if (FirebaseApi.getId() == widget.product.uid)
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

  void _testModalBottomSheet(context) {
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
                              print("kakao");
                              // KakaoShareManager().shareMyCode("code");
                              // kakato test
                              // 일단 주석처리 detail 잡아야함
                              // KakaoShareManager().isKakaotalkInstalled().then((installed) {
                              //   if (installed) {
                              //     print("kakao success");
                              //     KakaoShareManager().shareMyCode("abcd");
                              //   } else {
                              //     print("kakao error");
                              //     // show alert
                              //   }
                              // }),
                            },
                            constraints:
                                BoxConstraints(minHeight: 80, minWidth: 80),
                            fillColor: Colors.white,
                            child: IconButton(
                              icon: Image.asset(
                                  'assets/images/free-icon-kakao-talk-2111466.png'),
                              onPressed: () {},
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
                              // KakaoShareManager().getDynamicLink("abcd");
                            },
                            constraints:
                                BoxConstraints(minHeight: 80, minWidth: 80),
                            fillColor: Colors.white,
                            child: IconButton(
                              icon: Image.asset(
                                  'assets/images/iconfinder_link_hyperlink_5402394.png'),
                              onPressed: () {},
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

  Widget shareButton() {
    return new IconButton(
      icon: new Icon(Icons.share),
      onPressed: () => {
        print("share"),
        _testModalBottomSheet(context),
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
                priceEditingController =
                    TextEditingController(text: widget.product.price + "원");
                _textcontroller = TextEditingController(
                    text: snapshot.data.data()['favorites'].toString());
                incProductViews(snapshot.data.data()['views'] + 1);
                return Scaffold(
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
                      shareButton(),
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
