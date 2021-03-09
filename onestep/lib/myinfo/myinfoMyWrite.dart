import 'package:flutter/material.dart';
import 'package:onestep/cloth/clothitem.dart';
import 'package:onestep/cloth/models/category.dart';
import 'package:onestep/cloth/providers/myProductProvider.dart';
import 'package:provider/provider.dart';

class MyinfoMyWrite extends StatefulWidget {
  final MyProductProvider myProductProvider;

  const MyinfoMyWrite({
    Key key,
    this.myProductProvider,
  }) : super(key: key);
  @override
  _MyinfoMyWriteState createState() => _MyinfoMyWriteState();
}

class _MyinfoMyWriteState extends State<MyinfoMyWrite> {
  int _headerindex;
  final ScrollController _scrollController = ScrollController();
  final _category = Category();

  @override
  void initState() {
    _headerindex = 0;
    _scrollController.addListener(scrollListener);
    // widget.myProductProvider
    //     .fetchNextProducts(_category.getCategoryItems()[_headerindex]);
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
      // widget.myProductProvider
      //     .fetchNextProducts(_category.getCategoryItems()[_headerindex]);
    }
  }

  // Widget renderHeader() {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: <Widget>[
  //       SizedBox(height: 5),
  //       SizedBox(
  //         height: 50.0,
  //         child: ListView.builder(
  //           padding: EdgeInsets.all(5.0),
  //           physics: ClampingScrollPhysics(),
  //           // shrinkWrap: true,
  //           scrollDirection: Axis.horizontal,
  //           itemCount: _category.getCategoryItems().length,
  //           itemBuilder: (BuildContext context, int index) {
  //             return Card(
  //               color: _headerindex == index ? Colors.black : Colors.white,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(15.0),
  //               ),
  //               child: InkWell(
  //                 child: Padding(
  //                   padding: EdgeInsets.only(
  //                     left: 10,
  //                     right: 10,
  //                     top: 5,
  //                     bottom: 5,
  //                   ),
  //                   child: Align(
  //                     alignment: Alignment.center,
  //                     child: Text(
  //                       Provider.of<Category>(context, listen: false)
  //                           .getCategoryItems()[index],
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(
  //                         fontSize: 12,
  //                         color: _headerindex == index
  //                             ? Colors.white
  //                             : Colors.black,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 onTap: () {
  //                   setState(() {
  //                     _headerindex = index;
  //                     widget.myProductProvider.fetchProducts(
  //                         _category.getCategoryItems()[_headerindex]);
  //                   });
  //                 },
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //       SizedBox(height: 5),
  //     ],
  //   );
  // }

  Widget renderBody() {
    var _size = MediaQuery.of(context).size;
    final double _itemHeight = (_size.height - kToolbarHeight - 24) / 2.0;
    final double _itemWidth = _size.width / 2;

    return GridView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: _itemWidth > _itemHeight
            ? (_itemHeight / _itemWidth)
            : (_itemWidth / _itemHeight),
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      children: [
        ...widget.myProductProvider.products
            .map(
              (product) => ClothItem(
                product: product,
              ),
            )
            .toList(),
      ],
    );
  }

  Widget myProduct() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            this.renderBody(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("내가 쓴 글"),
          backgroundColor: Colors.white,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  "장터",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  "게시판",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: TabBarView(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // renderHeader(),
                  myProduct(),
                ],
              ),
              Center(
                  child: Text(
                "게시판",
                style: TextStyle(color: Colors.black),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
