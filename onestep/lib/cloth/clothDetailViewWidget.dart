import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestep/moor/moor_database.dart';
import 'package:provider/provider.dart';

class ClothDetailViewWidget extends StatefulWidget {
  final Product product;

  const ClothDetailViewWidget({Key key, this.product}) : super(key: key);

  @override
  _ClothDetailViewWidgetState createState() => _ClothDetailViewWidgetState();
}

class _ClothDetailViewWidgetState extends State<ClothDetailViewWidget> {
  @override
  void initState() {
    super.initState();
    
  }

  String getDiffTime() {
    final _now = DateTime.now();
    String _differenceTime;

    int _diffresult =
        (_now.difference(widget.product.uploadtime).inSeconds / 60).floor();
    print(_diffresult);
    if (_diffresult > 10080) {
      _differenceTime = DateFormat('MM-dd').format(widget.product.uploadtime);
    } else if (_diffresult < 4320 && _diffresult > 2880) {
      _differenceTime = '그저께';
    } else if (_diffresult > 1440) {
      _differenceTime =
          (_now.difference(widget.product.uploadtime).inDays).toString() + '일전';
    } else if (_diffresult > 60) {
      _differenceTime =
          (_now.difference(widget.product.uploadtime).inHours).toString() +
              '시간전';
    } else if (_diffresult > 1) {
      _differenceTime =
          (_now.difference(widget.product.uploadtime).inMinutes).toString() +
              '분전';
    } else {
      _differenceTime =
          (_now.difference(widget.product.uploadtime).inSeconds).toString() +
              '초전';
    }

    return _differenceTime;
  }

  Widget setFavorite() {
    ProductsDao p = Provider.of<AppDatabase>(context).productsDao;

    return StreamBuilder<List<Product>>(
      stream: p.watchProducts(),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return new Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text("");
          default:
            return GestureDetector(
              onTap: () {
                //setState(() {
                snapshot.data.contains(this.widget.product) == false
                    ? p.insertProduct(this.widget.product)
                    : p.deleteProduct(this.widget.product);
                // });
              },
              child: Icon(
                snapshot.data.contains(this.widget.product) == false
                    ? Icons.favorite_border
                    : Icons.favorite,
                color: Colors.pink,
              ),
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          '상세보기',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          setFavorite(),
          new IconButton(
            icon: new Icon(Icons.share),
            onPressed: () => {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Color(0xFFDF0F4),
                height: 430,
                // child: Swiper(
                //   onTap: (index) {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => ImageFullViewer(
                //             galleryItems: _imageItem,
                //             index: index,
                //           ),
                //         ));
                //   },
                //   // autoplay: true,
                //   // scale: 0.9,
                //   // viewportFraction: 0.8,
                //   pagination: SwiperPagination(
                //     alignment: Alignment.bottomCenter,
                //     builder: DotSwiperPaginationBuilder(
                //       activeColor: Colors.pink,
                //       color: Colors.grey,
                //     ),
                //   ),
                //   itemCount: _imageItem.length,
                //   itemBuilder: (BuildContext context, int index) {
                //     return Image.network(
                //       _imageItem[index],
                //       fit: BoxFit.cover,
                //     );
                //   },
                // ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "${widget.product.price}원",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "${widget.product.title}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.local_offer,
                      color: Colors.grey,
                      size: 17,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                    ),
                    Text("${widget.product.category}"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.access_time,
                      color: Colors.grey,
                      size: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                    ),
                    Text("${getDiffTime()}"),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                    ),
                    Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                      size: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                    ),
                    Text("${widget.product.views}"),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                    ),
                    Icon(
                      Icons.favorite,
                      color: Colors.grey,
                      size: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                    ),
                    Text("22"),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text("${widget.product.explain}"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
