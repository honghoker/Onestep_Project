import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart' as mf;
import 'package:onestep/cloth/clothDetailViewWidget.dart';
import 'package:onestep/moor/moor_database.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ClothItem extends StatefulWidget {
  final Product product;
  ClothItem({Key key, this.product}) : super(key: key);

  @override
  _ClothItemState createState() => _ClothItemState();
}

class _ClothItemState extends State<ClothItem> {
  @override
  void initState() {
    super.initState();
  }

  Widget setFavorite() {
    ProductsDao p = Provider.of<AppDatabase>(context).productsDao;

    return StreamBuilder<mf.QueryRow>(
      stream: p.customwatch(this.widget.product),
      builder: (BuildContext context, AsyncSnapshot<mf.QueryRow> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return new Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text("");
          default:
            return Positioned(
              right: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        snapshot.data.data['count'] == 0
                            ? p.insertProduct(this.widget.product)
                            : p.deleteProduct(this.widget.product);
                      },
                      child: Icon(
                        snapshot.data.data['count'] == 0
                            ? Icons.favorite_border
                            : Icons.favorite,
                        color: Colors.pink,
                      ),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double coverSize = 110;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ClothDetailViewWidget(product: widget.product),
            ));
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  fit: StackFit.passthrough,
                  children: <Widget>[
                    Center(child: CircularProgressIndicator()),
                    FadeInImage(
                      placeholder: MemoryImage(
                        kTransparentImage,
                      ), // 이미지 로드 시 빈 이미지 표시
                      image: NetworkImage(widget.product.images.isEmpty == false
                          ? 'https://grlib.sen.go.kr/resources/common/img/noimg-apply.png'
                          : jsonDecode(widget.product.images)[0]),
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: coverSize / 2,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Color.fromARGB(100, 0, 0, 0)
                            ],
                          ),
                        ),
                      ),
                    ),
                    setFavorite(),
                  ].where((item) => item != null).toList(),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 5)),
            SizedBox(
              height: 15,
              child: Align(
                child: Text(
                  "${widget.product.price.toString()}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
            SizedBox(
              height: 14,
              child: Align(
                child: Text(
                  "${widget.product.title}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                    color: Color(0xFF333333),
                  ),
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
            SizedBox(
              height: 14,
              child: Align(
                child: Text(
                  "${widget.product.category}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                    color: Color(0xFF333333),
                  ),
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
