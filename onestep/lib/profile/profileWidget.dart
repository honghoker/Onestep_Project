import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep/profile/provider/userProductProvider.dart';
import 'package:onestep/profile/userProductWidget.dart';
import 'package:provider/provider.dart';

class ProfileWidget extends StatelessWidget {
  final String uid;
  const ProfileWidget({Key key, this.uid}) : super(key: key);

  Widget getUserName() {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("users").doc(uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text("");
          default:
            return Text(
              snapshot.data['nickname'],
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
        }
      },
    );
  }

  Widget getUserImage() {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("users").doc(uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text("");
          default:
            return snapshot.data.data()['photoUrl'] != ""
                ? ClipOval(
                    child: Image.network(
                      snapshot.data.data()['photoUrl'],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(Icons.account_circle);
        }
      },
    );
  }

  String getBackgroundImg() {
    var backgroundImages = [
      "images/profile_back1.png",
      "images/profile_back2.png",
      "images/profile_back3.png",
      "images/profile_back4.png",
    ];
    int randomIndex = Random().nextInt(backgroundImages.length);

    return backgroundImages[randomIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.8), BlendMode.dstATop),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 4,
                  child: Image(
                    image: AssetImage(
                      getBackgroundImg(),
                    ),
                    fit: BoxFit.fitWidth,
                  ),
                  // fit: BoxFit.fitWidth,
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Row(
                  children: <Widget>[
                    getUserImage(),
                    // Container(
                    //   width: 60,
                    //   height: 60,
                    //   decoration: BoxDecoration(
                    //     image: DecorationImage(
                    //       image: AssetImage('images/profile.png'),
                    //       fit: BoxFit.cover,
                    //     ),
                    //     shape: BoxShape.circle,
                    //   ),
                    // ),
                    SizedBox(width: 10),
                    getUserName(),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(color: Colors.red),
          ),
          Expanded(
            // Padding(padding: EdgeInsets.all(5.00)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: ListTile.divideTiles(tiles: [
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text("판매 상품"),
                          onTap: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    Consumer<UserProductProvider>(
                                  builder: (context, userProductProvider, _) =>
                                      UserProductWidget(
                                    userProductProvider: userProductProvider,
                                    uid: uid,
                                  ),
                                ),
                              ),
                            ),
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_right),
                        onPressed: () {},
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text("구매 상품"),
                          onTap: () => {
                            print("구매상품"),
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_right),
                        onPressed: () {},
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text("후기"),
                          onTap: () => {print("후기")},
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_right),
                        onPressed: () {},
                      )
                    ],
                  ),
                ], context: context)
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
