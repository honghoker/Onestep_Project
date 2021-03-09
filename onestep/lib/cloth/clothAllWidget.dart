import 'package:flutter/material.dart';
import 'package:onestep/cloth/clothAddWidget.dart';
import 'package:onestep/cloth/clothWidgetHeader.dart';
import 'package:onestep/cloth/providers/allProductProvider.dart';

import 'package:onestep/favorite/favoriteWidget.dart';
import 'package:onestep/favorite/providers/favoriteProvider.dart';
import 'package:onestep/search/provider/searchProvider.dart';
import 'package:onestep/search/widget/searchProductBoardWidget.dart';
import 'package:provider/provider.dart';
import 'package:unicorndial/unicorndial.dart';

import 'clothitem.dart';
import 'models/category.dart';

class ClothAllWidget extends StatefulWidget {
  final AllProuductProvider allProductProvider;
  ClothAllWidget({Key key, this.allProductProvider}) : super(key: key);

  @override
  _ClothAllWidgetState createState() => _ClothAllWidgetState();
}

class _ClothAllWidgetState extends State<ClothAllWidget> {
  int _headerindex;
  final ScrollController _scrollController = ScrollController();
  final _category = Category();

  @override
  void initState() {
    _headerindex = 0;
    _scrollController.addListener(scrollListener);
    widget.allProductProvider.fetchProducts();
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
      widget.allProductProvider.fetchNextProducts();
    }
  }

  Widget renderBody() {
    var _size = MediaQuery.of(context).size;
    final double _itemHeight = (_size.height - kToolbarHeight - 24) / 2.2;
    final double _itemWidth = _size.width / 2;
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: GridView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 15),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: _itemWidth > _itemHeight
              ? (_itemHeight / _itemWidth)
              : (_itemWidth / _itemHeight),
          crossAxisCount: 3,
          mainAxisSpacing: 15,
          crossAxisSpacing: 7,
        ),
        children: [
          ...widget.allProductProvider.products
              .map(
                (product) => ClothItem(
                  product: product,
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Future<void> _refreshPage() async {
    setState(() {
      widget.allProductProvider.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final floatingButtons = List<UnicornButton>();

    floatingButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "위로",
        currentButton: FloatingActionButton(
          onPressed: () {
            _scrollController.position
                .moveTo(0.5, duration: Duration(milliseconds: 500));
          },
          heroTag: "ScrollTop",
          backgroundColor: Colors.white,
          mini: true,
          child: Icon(Icons.keyboard_arrow_up),
        ),
      ),
    );
    floatingButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "물품 등록",
        currentButton: FloatingActionButton(
          heroTag: "clothAdd",
          backgroundColor: Colors.white,
          mini: true,
          child: Icon(Icons.shopping_bag),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ClothAddWidget()),
            ).then((value) {
              setState(() {
                _headerindex = 0;
                widget.allProductProvider.fetchProducts();
              });
            });
          },
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '장터',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: () => {
              setState(() {
                widget.allProductProvider.fetchProducts();
              })
            },
          ),
          new IconButton(
            icon: new Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Consumer<SearchProvider>(
                    builder: (context, searchProvider, _) =>
                        SearchProductBoardWidget(
                      searchProvider: searchProvider,
                      type: 'product',
                    ),
                  ),
                ),
              ),
            },
          ),
          new IconButton(
            icon: new Icon(
              Icons.favorite,
              color: Colors.pink,
            ),
            onPressed: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Consumer<FavoriteProvider>(
                    builder: (context, favoriteProvider, _) => FavoriteWidget(
                      favoriteProvider: favoriteProvider,
                    ),
                  ),
                ),
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
                Consumer<Category>(
                  builder: (context, category, _) =>
                      ClothWidgetHeader(category: category),
                ),
                SizedBox(
                    height: 10,
                    child: Container(color: Color.fromRGBO(240, 240, 240, 1))),
                // this.renderHeader(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 15),
                      child: Text("오늘의 상품",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600))),
                ),
                this.renderBody(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: UnicornDialer(
        backgroundColor: Colors.black38,
        parentButtonBackground: Colors.white,
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(
          Icons.add,
          color: Colors.black,
        ),
        childButtons: floatingButtons,
      ),
    );
  }
}
