import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:onestep/cloth/imageFullViewerWIdget.dart';
import 'package:onestep/moor/moor_database.dart';
import 'package:onestep/notification/Controllers/notificationManager.dart';
import 'package:provider/provider.dart';
import 'package:onestep/api/firebase_api.dart';

class ClothDetailViewWidget extends StatefulWidget {
  final Product product;

  const ClothDetailViewWidget({Key key, this.product}) : super(key: key);

  @override
  _ClothDetailViewWidgetState createState() => _ClothDetailViewWidgetState();
}

class _ClothDetailViewWidgetState extends State<ClothDetailViewWidget> {
  List _imageItem = new List();

  @override
  void initState() {
    _imageItem.addAll(jsonDecode(widget.product.images));
    if (widget.product.hide == 1 || widget.product.deleted == 1) {}
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

  void showFavoriteDialog() {
    Future.delayed(Duration(milliseconds: 300), () {
      Navigator.pop(context);
    });
    showDialog(
      context: context,
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: Icon(Icons.favorite, color: Colors.pink, size: 200),
        // ),
      ),
    );
  }

  Widget setFavorite() {
    ProductsDao pd = Provider.of<AppDatabase>(context).productsDao;

    return StreamBuilder<List<Product>>(
      stream: pd.watchProducts(),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return new Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text("");
          default:
            return GestureDetector(
              onTap: () {
                if (snapshot.data.contains(this.widget.product) == false) {
                  pd.insertProduct(this.widget.product);
                  showFavoriteDialog();
                } else {
                  pd.deleteProduct(this.widget.product);
                }
              },
              child: Icon(
                snapshot.data.contains(this.widget.product) == false
                    ? Icons.favorite_border
                    : Icons.favorite,
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

  Widget renderBody() {
    return FutureBuilder(
      future: getProduct(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text("");
          default:
            incProductViews(snapshot.data.data()['views'] + 1);

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
                        return Image.network(
                          _imageItem[index],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "${snapshot.data.data()['price']}원",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
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
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.access_time,
                          color: Colors.grey,
                          size: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 2.0),
                        ),
                        Text(
                            "${getDiffTime(snapshot.data.data()['uploadtime'])}"),
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
                        Text("${snapshot.data.data()['favorites']}"),
                        // dtdtdtdtd
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("${snapshot.data.data()['explain']}"),
                  ),
                ],
              ),
            );
        }
      },
    );
  }

  void handleClick(String value) {
    switch (value) {
      case '새로고침':
        break;
      case '신고하기':
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

  @override
  Widget build(BuildContext context) {
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
          new IconButton(
            icon: new Icon(Icons.share),
            onPressed: () => {
              print("share"),
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
          ),
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              var menuItem = {'새로고침', '신고하기'};
              if (FirebaseApi.getId() == widget.product.uid)
                menuItem.addAll({"숨김", "삭제"});
              return menuItem.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: renderBody(),
      bottomNavigationBar: SizedBox(
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
              Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: SizedBox(
                  width: 150,
                  child: RaisedButton(
                    onPressed: () {
                      print(
                          "firestoreid = ${widget.product.firestoreid}, title = ${widget.product.title} uid = ${widget.product.uid}");
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
