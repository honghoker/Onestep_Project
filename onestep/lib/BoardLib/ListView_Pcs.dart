import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Boardmain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'BoardContent.dart';

final List<tempTitleData> tempData = [
  tempTitleData('이게', '멋진 서브타이틀', 5000, 5, '2019.2.4'),
  tempTitleData('바로', '영롱 하지 않은가', 10, 100, '2019.7.4'),
  tempTitleData('멋진', '아름답지 않은가', 90, 1500, '2019.9.4'),
  tempTitleData('리스트', '깔끔하지 않은가', 50, 20, '2019.10.4'),
  tempTitleData('라는', '촤밍하지 않는가', 99, 2000, '2019.4.4'),
  tempTitleData('것이다', '페이보릿카운트가 555555이다', 30, 55555555, '2019.2.4'),
  tempTitleData('이게', '멋진 서브타이틀', 5000, 5, '2019.2.4'),
  tempTitleData('바로', '영롱 하지 않은가', 10, 100, '2019.7.4'),
  tempTitleData('멋진', '아름답지 않은가', 90, 1500, '2019.9.4'),
  tempTitleData('리스트', '깔끔하지 않은가', 50, 20, '2019.10.4'),
  tempTitleData('라는', '촤밍하지 않는가', 99, 2000, '2019.4.4'),
  tempTitleData('것이다', '페이보릿카운트가 555555이다', 30, 55555555, '2019.2.4'),
  tempTitleData('이게', '멋진 서브타이틀', 5000, 5, '2019.2.4'),
  tempTitleData('바로', '영롱 하지 않은가', 10, 100, '2019.7.4'),
  tempTitleData('멋진', '아름답지 않은가', 90, 1500, '2019.9.4'),
  tempTitleData('리스트', '깔끔하지 않은가', 50, 20, '2019.10.4'),
  tempTitleData('라는', '촤밍하지 않는가', 99, 2000, '2019.4.4'),
  tempTitleData('것이다', '페이보릿카운트가 555555이다', 30, 55555555, '2019.2.4'),
  tempTitleData('이게', '멋진 서브타이틀', 5000, 5, '2019.2.4'),
  tempTitleData('바로', '영롱 하지 않은가', 10, 100, '2019.7.4'),
  tempTitleData('멋진', '아름답지 않은가', 90, 1500, '2019.9.4'),
  tempTitleData('리스트', '깔끔하지 않은가', 50, 20, '2019.10.4'),
  tempTitleData('라는', '촤밍하지 않는가', 99, 2000, '2019.4.4'),
  tempTitleData('것이다', '페이보릿카운트가 555555이다', 30, 55555555, '2019.2.4'),
  tempTitleData('이게', '멋진 서브타이틀', 5000, 5, '2019.2.4'),
  tempTitleData('바로', '영롱 하지 않은가', 10, 100, '2019.7.4'),
  tempTitleData('멋진', '아름답지 않은가', 90, 1500, '2019.9.4'),
  tempTitleData('리스트', '깔끔하지 않은가', 50, 20, '2019.10.4'),
  tempTitleData('라는', '촤밍하지 않는가', 99, 2000, '2019.4.4'),
  tempTitleData('것이다', '페이보릿카운트가 555555이다', 30, 55555555, '2019.2.4'),
  tempTitleData('이게', '멋진 서브타이틀', 5000, 5, '2019.2.4'),
  tempTitleData('바로', '영롱 하지 않은가', 10, 100, '2019.7.4'),
  tempTitleData('멋진', '아름답지 않은가', 90, 1500, '2019.9.4'),
  tempTitleData('리스트', '깔끔하지 않은가', 50, 20, '2019.10.4'),
  tempTitleData('라는', '촤밍하지 않는가', 99, 2000, '2019.4.4'),
  tempTitleData('것이다', '페이보릿카운트가 555555이다', 30, 55555555, '2019.2.4'),
];

class FirstPageView extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPageView> {
  // BuildContext context;
  // GeneralBoard(BuildContext context);
  // GeneralBoard({@required this.context}) : assert(context != null);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
//   }
//    Widget _buildList() {
//     return StreamBuilder(
//       stream:
//           _firestore.collection('chattingroom').where('send_user').snapshots(),
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (!snapshot.hasData) {
//           return Text('Loading from chat_main..2.');
//         }
// // ignore: deprecated_member_use
//         List<DocumentSnapshot> documents = snapshot.data.documents;
//         return ListView(
//           padding: EdgeInsets.only(top: 0.0),
//           children: documents
//               .map((eachDocument) => DocumentView(eachDocument, '김명수'))
//               .toList(),
//         );
//       },
//     );
//   }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Board')
            .doc('Board_Free')
            .collection('Board_Free_BoardId')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            final boardIdList = snapshot.data.documents;
            return Container(
                child: ListView.builder(
                    //PageStorageKey is Keepping ListView scroll position when switching pageview
                    key: PageStorageKey<String>("value"),
                    //Bottom Padding
                    padding: const EdgeInsets.only(
                        bottom: kFloatingActionButtonMargin + 60),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) =>
                        _buildListCard(context, index, boardIdList[index])));
          }
        });
  }
}

Widget _buildListCard(BuildContext context, int index, DocumentSnapshot temp) {
  print(temp
      .id); //SOMETING//SOMETING//SOMETING//SOMETING//SOMETING//SOMETING//SOMETING//SOMETING
  return Card(
      child: Padding(
          padding: const EdgeInsets.all(1.0),
          //Click Animation
          child: InkWell(
            // Set Click Color
            splashColor: Colors.grey,
            //Click Event
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    fullscreenDialog: false,
                    builder: (context) => BoardStateful(
                      index: index,
                      boardName: 'Current Test Board',
                    ),
                  ));
            },
            child: Column(
              children: <Widget>[
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //Title Container
                    titleContainerMethod(title: ''),
                    _commentCountMethod(index)
                  ],
                )),
                Container(
                  height: 20,
                  alignment: Alignment.centerLeft,
                  child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      width: 300,
                      child: Text(
                          'this is subtitle...abc dabc dab cdabcdabcdabcdabcd abcdabcdabcd',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black, fontSize: 13))),
                ),
                // Container:() => show_icon_favorite(a);
                Container(
                    child: Row(
                  children: <Widget>[
                    Container(
                        child: Row(
                      children: <Widget>[
                        IconTheme(
                            child: Icon(Icons.favorite, size: 14),
                            data: new IconThemeData(color: Colors.red)),
                        // Icon(Icons.favorite),
                        Text(
                          'favorite Count',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' | ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                      // Icon(Icons.favorite), child: Text('Date')
                    )),
                    Flexible(
                      child: Text('date'),
                    )
                    // Expanded(child: Text('dd')),
                    // Expanded(
                    //   child: Text('data'),
                    // )
                  ],
                ))
              ],
            ),
          )));
}

Widget titleContainerMethod({@required String title}) {
  return Container(
      margin: const EdgeInsets.only(left: 5),
      width: 300,
      child: Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
      ));
}

Widget _commentCountMethod(int index) {
  int _commentCount = tempData[index].commentCount;
  Widget _commentCountText;
  BoxDecoration _commentBoxDecoration;
  //Under 30
  if (tempData[index].commentCount < 30) {
    _commentBoxDecoration =
        new BoxDecoration(shape: BoxShape.circle, color: Colors.yellow);
    _commentCountText = new Text('$_commentCount',
        maxLines: 1,
        style: TextStyle(
            color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold));
    //Up 30 Under 50
  } else if (_commentCount >= 30 && _commentCount < 50) {
    _commentBoxDecoration =
        new BoxDecoration(shape: BoxShape.circle, color: Colors.orange);
    _commentCountText = new Text('$_commentCount',
        maxLines: 1,
        style: TextStyle(
            color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold));
    //Over 50
  } else {
    _commentBoxDecoration =
        new BoxDecoration(shape: BoxShape.circle, color: Colors.red);
    if (_commentCount <= 100) {
      _commentCountText = new Text('$_commentCount',
          maxLines: 1,
          style: TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold));
    } else {
      _commentCountText = new Text('100+',
          maxLines: 1,
          style: TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold));
    }
  }

  return Container(
      //CommentCount Container
      height: 30,
      width: 30,
      decoration: _commentBoxDecoration,
      child: Center(child: _commentCountText));
}
