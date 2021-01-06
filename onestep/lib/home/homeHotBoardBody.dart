import 'package:flutter/material.dart';

import 'homeHotBoardPage.dart';

class HomeHotBoardBody extends StatefulWidget {
  @override
  _HomeHotBoardBodyState createState() => _HomeHotBoardBodyState();
}

class _HomeHotBoardBodyState extends State<HomeHotBoardBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.only(top: 10),
      width: 350,

      height: 250,

      decoration: BoxDecoration(
      child: Padding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: new EdgeInsets.only(bottom: 15),
                  child: new Text(
                    "Hot 게시물",
                    style: new TextStyle(fontSize: 20),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomeHotBoardPage()));
                  },
                  child: Container(
                    child: new Text(
                      "더 보기 >",
                      style: new TextStyle(fontSize: 13),
                    ),
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Container(
                    child: Text("111"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom:5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text("time"),
                        // margin: new EdgeInsets.only(bottom: 10),
                      ),
                      Container(
                        child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.grey,
                                  size: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                ),
                                Text("89"),
                                Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                ),
                                Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.grey,
                                  size: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                ),
                                Text("89"),
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
               Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Container(
                    child: Text("111"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom:5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text("time"),
                        // margin: new EdgeInsets.only(bottom: 10),
                      ),
                      Container(
                        child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.grey,
                                  size: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                ),
                                Text("89"),
                                Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                ),
                                Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.grey,
                                  size: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                ),
                                Text("89"),
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),   Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Container(
                    child: Text("111"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom:5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text("time"),
                        // margin: new EdgeInsets.only(bottom: 10),
                      ),
                      Container(
                        child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.grey,
                                  size: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                ),
                                Text("89"),
                                Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                ),
                                Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.grey,
                                  size: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                ),
                                Text("89"),
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),   Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Container(
                    child: Text("111"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom:5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text("time"),
                        // margin: new EdgeInsets.only(bottom: 10),
                      ),
                      Container(
                        child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.grey,
                                  size: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                ),
                                Text("89"),
                                Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                ),
                                Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.grey,
                                  size: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                ),
                                Text("89"),
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
