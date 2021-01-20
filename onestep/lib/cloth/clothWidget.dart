import 'package:flutter/material.dart';
import 'package:onestep/cloth/clothAddWidget.dart';
import 'package:onestep/cloth/clothSearchResultPage.dart';
import 'package:onestep/cloth/providers/productProvider.dart';
import 'package:onestep/favorite/favoriteWidget.dart';
import 'package:provider/provider.dart';
import 'package:unicorndial/unicorndial.dart';

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
  final _category = Category();

  @override
  void initState() {
    _headerindex = 0;
    _scrollController.addListener(scrollListener);
    widget.productProvider
        .fetchNextProducts(_category.getCategoryItems()[_headerindex]);
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
      widget.productProvider
          .fetchNextProducts(_category.getCategoryItems()[_headerindex]);
    }
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
            itemCount: _category.getCategoryItems().length,
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
                      widget.productProvider.fetchProducts(
                          _category.getCategoryItems()[_headerindex]);
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
        childAspectRatio: itemWidth > itemHeight
            ? (itemHeight / itemWidth)
            : (itemWidth / itemHeight),
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
    widget.productProvider
        .fetchProducts(_category.getCategoryItems()[_headerindex]);
    // });
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    final double _itemHeight = (_size.height - kToolbarHeight - 24) / 2.0;
    final double _itemWidth = _size.width / 2;

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
                widget.productProvider
                    .fetchProducts(_category.getCategoryItems()[_headerindex]);
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
        backgroundColor: Colors.white,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: () => {
              setState(() {
                widget.productProvider
                    .fetchProducts(_category.getCategoryItems()[_headerindex]);
              })
            },
          ),
          new IconButton(
            icon: new Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () => {
              print("검색"),
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ClothSearchResultPage(
                  productProvider: widget.productProvider,
                ),
              ))
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
