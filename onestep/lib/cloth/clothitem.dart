import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep/cloth/product.dart';
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

  @override
  Widget build(BuildContext context) {
    double coverSize = 110;

    return GestureDetector(
      onTap: () {
        try {
          FirebaseFirestore.instance
              .collection("products")
              .doc(widget.product.firestoreid)
              .update(
            {
              'views': widget.product.views + 1,
            },
          );
        } catch (e) {}
        print("상세보기");
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => ClothDetailView(product: widget.product),
        //     )).then((value) {
        //   setState(() => {});
        // });
      },
      child: new Container(
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
                    //setFavorite(),
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
