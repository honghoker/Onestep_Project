import 'package:flutter/material.dart';
import 'package:onestep/cloth/clothItem.dart';
import 'package:onestep/favorite/providers/favoriteProvider.dart';

class FavoriteWidget extends StatefulWidget {
  final FavoriteProvider favoriteProvider;
  const FavoriteWidget({Key key, this.favoriteProvider}) : super(key: key);

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    widget.favoriteProvider.fetchProducts();
    _scrollController.addListener(scrollListener);
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
      widget.favoriteProvider.fetchNextProducts();
    }
  }

  Widget renderHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '찜한 아이템',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          Row(
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
        ],
      ),
    );
  }

  Widget renderBody() {
    var _size = MediaQuery.of(context).size;
    final double _itemHeight = (_size.height - kToolbarHeight - 24) / 2.0;
    final double _itemWidth = _size.width / 2;

    if (widget.favoriteProvider.isFetching == true) {
      return CircularProgressIndicator();
    } else {
      if (widget.favoriteProvider.products.length == 0) {
        return Container(child: Text("찜한 상품이 없어요."));
      } else {
        return GridView(
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
            ...widget.favoriteProvider.products
                .map(
                  (product) => ClothItem(
                    product: product,
                  ),
                )
                .toList(),
          ],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text(
          '찜',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: () => {
              setState(() {
                widget.favoriteProvider.fetchProducts();
              })
            },
          ),
          new IconButton(
            icon: new Icon(
              Icons.delete,
              color: Colors.black,
            ),
            onPressed: () => {
              print("delete all product"),
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                renderHeader(),
                renderBody(),
              ],
            )),
      ),
    );
  }
}
