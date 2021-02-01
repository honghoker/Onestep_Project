import 'package:flutter/material.dart';
import 'package:moor/moor.dart' as mf;
import 'package:onestep/cloth/clothItem.dart';
import 'package:onestep/moor/moor_database.dart';
import 'package:provider/provider.dart';

class FavoriteWidget extends StatefulWidget {
  final Product product;
  const FavoriteWidget({Key key, this.product}) : super(key: key);

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
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

  Widget renderBody(double itemWidth, double itemHeight) {
    ProductsDao p = Provider.of<AppDatabase>(context).productsDao;

    return StreamBuilder<List<mf.QueryRow>>(
      stream: p.watchProducts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<mf.QueryRow>> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return GridView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 15),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: (itemWidth / itemHeight),
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                print(
                    "favoritetime = ${snapshot.data[index].data["favoritetime"]}");
                Product p = Product.fromJson(snapshot.data[index].data,
                    snapshot.data[index].data["firestoreid"]);
                return ClothItem(product: p);
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
              Icons.delete,
              color: Colors.black,
            ),
            onPressed: () => {
              print("delete all product"),
              Provider.of<AppDatabase>(context, listen: false)
                  .productsDao
                  .deleteAllProduct(),
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
                renderHeader(),
                renderBody(_itemWidth, _itemHeight),
              ],
            )),
      ),
    );
  }
}
