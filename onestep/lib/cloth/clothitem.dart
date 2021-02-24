import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:onestep/api/favorite_api.dart';
import 'package:onestep/api/firebase_api.dart';
import 'package:onestep/cloth/models/product.dart';
import 'package:onestep/favorite/animations/favoriteanimation.dart';

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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseApi.getId())
          .collection("favorites")
          .where("productid", isEqualTo: this.widget.product.firestoreid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      Icons.favorite_border,
                      color: Colors.pink,
                    ),
                  ],
                ),
              ),
            );
          default:
            bool chk = snapshot.data.docs.length == 0 ? false : true;
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
                        if (!chk) {
                          FavoriteApi.insertFavorite(
                              this.widget.product.firestoreid);
                          FavoriteAnimation().showFavoriteDialog(context);
                        } else {
                          FavoriteApi.deleteFavorite(snapshot.data.docs[0].id,
                              this.widget.product.firestoreid);
                        }
                      },
                      child: Icon(
                        !chk ? Icons.favorite_border : Icons.favorite,
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

  Widget getImage() {
    var img = widget.product.images;

    return ExtendedImage.network(
      img[0],
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      fit: BoxFit.cover,
      cache: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    double coverSize = 110;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/DetailProduct',
          arguments: {"PRODUCTID": widget.product.firestoreid},
        ).then((value) {
          print("clothitem");
        });
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
                    getImage(),
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
                child: Row(
                  children: <Widget>[
                    Text(
                      "${widget.product.price.toString()}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Text(
                      "원",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
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
                    fontWeight: FontWeight.w400,
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
