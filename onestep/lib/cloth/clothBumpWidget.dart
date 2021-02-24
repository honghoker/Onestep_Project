import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:onestep/cloth/models/product.dart';
import 'package:onestep/cloth/providers/productProvider.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:provider/provider.dart';

class ClothBumpWidget extends StatefulWidget {
  final Product product;
  ClothBumpWidget({Key key, this.product}) : super(key: key);

  @override
  _ClothBumpWidgetState createState() => _ClothBumpWidgetState();
}

class _ClothBumpWidgetState extends State<ClothBumpWidget> {
  TextEditingController priceEditingController;
  @override
  void initState() {
    priceEditingController =
        new TextEditingController(text: widget.product.price);

    super.initState();
  }

  void bumpProduct() {
    var time = DateTime.now();
    FirebaseFirestore.instance
        .collection("products")
        .doc(widget.product.firestoreid)
        .update({
      'bumptime': time,
      'price': priceEditingController.text
    }).whenComplete(() {
      try {
        Provider.of<ProuductProvider>(context, listen: false)
            .fetchProducts("전체");
        Navigator.of(context).pop("OK");
      } catch (e) {
        print(e);
      }

      // Navigator.of(context).pushReplacementNamed('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '끌어올리기',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.94,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              color: Colors.white70,
              elevation: 10,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.28,
                        maxHeight: MediaQuery.of(context).size.width * 0.28,
                      ),
                      child: ExtendedImage.network(
                        widget.product.images[0],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        cache: true,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Text(
                            'Texas Angus Burger',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                          child: Text(
                            '100% Australian Angus grain-fed beef with cheese and pickles.  Served with fries.',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 40, 0, 0),
                        child: Text(
                          '\$ 24.00',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 100,
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: ExtendedImage.network(
                  widget.product.images[0],
                  width: 60,
                  height: 100,
                  fit: BoxFit.cover,
                  cache: true,
                ),
              ),
              title: Text(widget.product.title),
              subtitle: Text(widget.product.price),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
              // dense: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: priceEditingController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    ThousandsFormatter(),
                  ],
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          FlatButton(
            onPressed: () {
              bumpProduct();
            },
            child: Text("끌어올리기"),
          ),
        ],
      ),
    );
  }
}
