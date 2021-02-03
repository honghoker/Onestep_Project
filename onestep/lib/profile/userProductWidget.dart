import 'package:flutter/material.dart';
import 'package:onestep/cloth/clothitem.dart';
import 'package:onestep/profile/provider/userProductProvider.dart';

class UserProductWidget extends StatefulWidget {
  final UserProductProvider userProductProvider;
  final String uid;
  UserProductWidget({Key key, this.userProductProvider, this.uid})
      : super(key: key);

  @override
  _UserProductWidgetState createState() => _UserProductWidgetState();
}

class _UserProductWidgetState extends State<UserProductWidget> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    _scrollController.addListener(scrollListener);
    widget.userProductProvider.fetchProducts(this.widget.uid);
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
      widget.userProductProvider.fetchNextProducts(this.widget.uid);
    }
  }

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
        ...widget.userProductProvider.products
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
    widget.userProductProvider.fetchProducts(this.widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '판매 상품 보기',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
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
                this.renderBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
