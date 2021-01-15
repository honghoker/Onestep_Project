import 'dart:convert';
import 'package:extended_image/extended_image.dart';
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
      stream: p.watchsingleProduct(this.widget.product.firestoreid),
      builder: (BuildContext context, AsyncSnapshot<mf.QueryRow> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return new Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Positioned(
              right: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(
                      !snapshot.hasData
                          ? Icons.favorite_border
                          : Icons.favorite,
                      color: Colors.pink,
                    ),
                  ],
                ),
              ),
            );
          default:
            if (snapshot.hasData) {
              if (snapshot.data.data.toString() !=
                  widget.product.toJson().toString()) {
                p.updateProduct(widget.product);
              }
            }
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
                        !snapshot.hasData
                            ? p.insertProduct(this.widget.product)
                            : p.deleteProduct(this.widget.product);
                      },
                      child: Icon(
                        !snapshot.hasData
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
    var img = jsonDecode(widget.product.images);

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
                    ExtendedImage.network(
                      img[0],
                      // width: ScreenUtil.instance.setWidth(400),
                      // height: ScreenUtil.instance.setWidth(400),
                      fit: BoxFit.cover,
                      cache: true,
                      border: Border.all(color: Colors.red, width: 1.0),
                      // shape: boxShape,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      //cancelToken: cancellationToken,
                    ),
                    // FadeInImage(
                    //   placeholder: MemoryImage(
                    //     kTransparentImage,
                    //   ), // 이미지 로드 시 빈 이미지 표시

                    //   image: NetworkImage(img == null
                    //       ? 'https://grlib.sen.go.kr/resources/common/img/noimg-apply.png'
                    //       : img[0]),
                    //   fit: BoxFit.cover,
                    // ),
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
