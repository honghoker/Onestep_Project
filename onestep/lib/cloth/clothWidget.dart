import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep/favorite/favoriteWidget.dart';
import 'package:onestep/moor/moor_database.dart';
import 'package:provider/provider.dart';

import 'category.dart';
import 'clothitem.dart';

class ClothWidget extends StatefulWidget {
  ClothWidget({Key key}) : super(key: key);

  @override
  _ClothWidgetState createState() => _ClothWidgetState();
}

class _ClothWidgetState extends State<ClothWidget> {
  int _headerindex;
  Stream stream;
  @override
  void initState() {
    _headerindex = 0;

    stream = FirebaseFirestore.instance
        .collection('products')
        .orderBy("uploadtime", descending: true)
        .snapshots();

    super.initState();
  }

  Widget renderHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 5),
        SizedBox(
          height: 50.0,
          child: ListView.builder(
            padding: EdgeInsets.all(5.0),
            physics: ClampingScrollPhysics(),
            // shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: Provider.of<Category>(context).getCategoryItems().length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: _headerindex == index ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 5,
                      bottom: 5,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        Provider.of<Category>(context)
                            .getCategoryItems()[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: _headerindex == index
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _headerindex = index;
                      stream = _headerindex == 0
                          ? FirebaseFirestore.instance
                              .collection('products')
                              .orderBy("uploadtime", descending: true)
                              .snapshots()
                          : FirebaseFirestore.instance
                              .collection('products')
                              .where("category",
                                  isEqualTo: Provider.of<Category>(context)
                                      .getCategoryItems()[_headerindex])
                              .orderBy("uploadtime", descending: true)
                              .snapshots();
                    });
                  },
                ),
              );
            },
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }

  Widget renderBody(double itemWidth, double itemHeight) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text("");
          default:
            return GridView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.size,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 15),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: (itemWidth / itemHeight),
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                Timestamp time = snapshot.data.docs[index].data()['uploadtime'];

                return ClothItem(
                  product: Product(
                    firestoreid: snapshot.data.docs[index].id,
                    title: snapshot.data.docs[index].data()['title'],
                    category: snapshot.data.docs[index].data()['category'],
                    price: snapshot.data.docs[index].data()['price'],
                    images:
                        jsonEncode(snapshot.data.docs[index].data()['images']),
                    explain: snapshot.data.docs[index].data()['explain'],
                    views: snapshot.data.docs[index].data()['views'],
                    uploadtime: time.toDate(),
                  ),
                );
              },
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    final double _itemHeight = (_size.height - kToolbarHeight - 24) / 1.9;
    final double _itemWidth = _size.width / 2;

    //print("@@@@@@ ${category.length}");
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          '장터',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () => {
              // showDialog(
              //   context: context,
              //   builder: (BuildContext context) {
              //     return DialogTest();
              //   },
              // ),
            },
          ),
          new IconButton(
            icon: new Icon(
              Icons.favorite,
              color: Colors.pink,
            ),
            onPressed: () => {
              print("찜"),
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoriteWidget()),
              ).then((value) {
                //setState(() => {});
              }),
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              this.renderHeader(),
              this.renderBody(_itemWidth, _itemHeight),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print("물품 등록");
          // final result = await Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => ClothAdd()),
          // );

          // if (result == "OK") {
          //   Scaffold.of(context)
          //     ..removeCurrentSnackBar()
          //     ..showSnackBar(SnackBar(content: Text("물품 등록이 완료되었습니다.")));
          // }
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
