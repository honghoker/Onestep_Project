import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep/cloth/clothAddWidget.dart';
import 'package:onestep/cloth/providers/productProvider.dart';
import 'package:onestep/favorite/favoriteWidget.dart';
import 'package:onestep/moor/moor_database.dart';
import 'package:provider/provider.dart';

import 'clothitem.dart';
import 'models/category.dart';

class ClothWidget extends StatefulWidget {
  final ProuductProvider productProvider;
  ClothWidget({Key key, this.productProvider}) : super(key: key);

  @override
  _ClothWidgetState createState() => _ClothWidgetState();
}

class _ClothWidgetState extends State<ClothWidget> {
  int _headerindex;
  final ScrollController _scrollController = ScrollController();

  Future _productfuture;

  @override
  void initState() {
    _scrollController.addListener(scrollListener);
    widget.productProvider.fetchNextProducts();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      widget.productProvider.fetchNextProducts();
    }

    // if (_scrollController.offset >=
    //         _scrollController.position.maxScrollExtent / 2 &&
    //     !_scrollController.position.outOfRange) {
    //   if (widget.productProvider.hasNext) {
    //     print("@@@@@@dtdtdtd");
    //     widget.productProvider.fetchNextProducts();
    //   }
    // }
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
            itemCount: Provider.of<Category>(context, listen: false)
                .getCategoryItems()
                .length,
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
                        Provider.of<Category>(context, listen: false)
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
                      _productfuture = _headerindex == 0
                          ? FirebaseFirestore.instance
                              .collection('products')
                              .orderBy("uploadtime", descending: true)
                              .get()
                          : FirebaseFirestore.instance
                              .collection('products')
                              .where("category",
                                  isEqualTo: Provider.of<Category>(context,
                                          listen: false)
                                      .getCategoryItems()[_headerindex])
                              .orderBy("uploadtime", descending: true)
                              .get();
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
    return GridView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: (itemWidth / itemHeight),
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      children: [
        ...widget.productProvider.products
            .map(
              (product) => ClothItem(
                product: product,
              ),
            )
            .toList(),
      ],
    );
  }

  Future<void> _refreshPage() async {
    // setState(() {
    widget.productProvider.fetchProducts();
    // });
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
              // a(),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoriteWidget()),
              ),
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: SingleChildScrollView(
          controller: _scrollController,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ClothAddWidget()),
          ).then((value) {
            widget.productProvider.fetchProducts();
            // Provider.of<ProuductProvider>(context).reset();
            // setState(() {
            //   _productfuture = FirebaseFirestore.instance
            //       .collection('products')
            //       .orderBy("uploadtime", descending: true)
            //       .limit(_limit)
            //       .get();
            // });
          });
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
