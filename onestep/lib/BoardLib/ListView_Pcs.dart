// import 'Boardmain.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'BoardContent.dart';

// final List<tempTitleData> tempData = [
//   tempTitleData('이게', '멋진 서브타이틀', 5000, 5, '2019.2.4'),
//   tempTitleData('바로', '영롱 하지 않은가', 10, 100, '2019.7.4'),
//   tempTitleData('멋진', '아름답지 않은가', 90, 1500, '2019.9.4'),
//   tempTitleData('리스트', '깔끔하지 않은가', 50, 20, '2019.10.4'),
//   tempTitleData('라는', '촤밍하지 않는가', 99, 2000, '2019.4.4'),
//   tempTitleData('것이다', '페이보릿카운트가 555555이다', 30, 55555555, '2019.2.4'),
//   tempTitleData('이게', '멋진 서브타이틀', 5000, 5, '2019.2.4'),
//   tempTitleData('바로', '영롱 하지 않은가', 10, 100, '2019.7.4'),
//   tempTitleData('멋진', '아름답지 않은가', 90, 1500, '2019.9.4'),
//   tempTitleData('리스트', '깔끔하지 않은가', 50, 20, '2019.10.4'),
//   tempTitleData('라는', '촤밍하지 않는가', 99, 2000, '2019.4.4'),
//   tempTitleData('것이다', '페이보릿카운트가 555555이다', 30, 55555555, '2019.2.4'),
//   tempTitleData('이게', '멋진 서브타이틀', 5000, 5, '2019.2.4'),
//   tempTitleData('바로', '영롱 하지 않은가', 10, 100, '2019.7.4'),
//   tempTitleData('멋진', '아름답지 않은가', 90, 1500, '2019.9.4'),
//   tempTitleData('리스트', '깔끔하지 않은가', 50, 20, '2019.10.4'),
//   tempTitleData('라는', '촤밍하지 않는가', 99, 2000, '2019.4.4'),
//   tempTitleData('것이다', '페이보릿카운트가 555555이다', 30, 55555555, '2019.2.4'),
//   tempTitleData('이게', '멋진 서브타이틀', 5000, 5, '2019.2.4'),
//   tempTitleData('바로', '영롱 하지 않은가', 10, 100, '2019.7.4'),
//   tempTitleData('멋진', '아름답지 않은가', 90, 1500, '2019.9.4'),
//   tempTitleData('리스트', '깔끔하지 않은가', 50, 20, '2019.10.4'),
//   tempTitleData('라는', '촤밍하지 않는가', 99, 2000, '2019.4.4'),
//   tempTitleData('것이다', '페이보릿카운트가 555555이다', 30, 55555555, '2019.2.4'),
//   tempTitleData('이게', '멋진 서브타이틀', 5000, 5, '2019.2.4'),
//   tempTitleData('바로', '영롱 하지 않은가', 10, 100, '2019.7.4'),
//   tempTitleData('멋진', '아름답지 않은가', 90, 1500, '2019.9.4'),
//   tempTitleData('리스트', '깔끔하지 않은가', 50, 20, '2019.10.4'),
//   tempTitleData('라는', '촤밍하지 않는가', 99, 2000, '2019.4.4'),
//   tempTitleData('것이다', '페이보릿카운트가 555555이다', 30, 55555555, '2019.2.4'),
//   tempTitleData('이게', '멋진 서브타이틀', 5000, 5, '2019.2.4'),
//   tempTitleData('바로', '영롱 하지 않은가', 10, 100, '2019.7.4'),
//   tempTitleData('멋진', '아름답지 않은가', 90, 1500, '2019.9.4'),
//   tempTitleData('리스트', '깔끔하지 않은가', 50, 20, '2019.10.4'),
//   tempTitleData('라는', '촤밍하지 않는가', 99, 2000, '2019.4.4'),
//   tempTitleData('것이다', '페이보릿카운트가 555555이다', 30, 55555555, '2019.2.4'),
// ];

// class FirstPageView extends StatelessWidget {
//   // BuildContext context;
//   // GeneralBoard(BuildContext context);
//   // GeneralBoard({@required this.context}) : assert(context != null);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: ListView.builder(

//             //PageStorageKey is Keepping ListView scroll position when switching pageview
//             key: PageStorageKey<String>("value"),
//             //Bottom Padding
//             padding:
//                 const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 60),
//             itemCount: tempData.length,
//             itemBuilder: (context, index) => _buildListCard(context, index)));
//   }
// }

// Widget _buildListCard(BuildContext context, int index) {
//   return Card(
//       child: Padding(
//           padding: const EdgeInsets.all(1.0),
//           //Click Animation
//           child: InkWell(
//             // Set Click Color
//             splashColor: Colors.grey,
//             //Click Event
//             onTap: () {
//               Navigator.push(
//                   context,
//                   CupertinoPageRoute(
//                     fullscreenDialog: false,
//                     builder: (context) => BoardStateful(
//                       index: index,
//                       boardName: 'Current Test Board',
//                     ),
//                   ));
//             },
//             child: Column(
//               children: <Widget>[
//                 Container(
//                     child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     //Title Container
//                     titleContainerMethod(index),
//                     _commentCountMethod(index)
//                   ],
//                 )),
//                 Container(
//                   height: 20,
//                   alignment: Alignment.centerLeft,
//                   child: Container(
//                       margin: const EdgeInsets.only(left: 10),
//                       width: 300,
//                       child: Text(
//                           'this is subtitle...abc dabc dab cdabcdabcdabcdabcd abcdabcdabcd',
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(color: Colors.black, fontSize: 13))),
//                 ),
//                 // Container:() => show_icon_favorite(a);
//                 Container(
//                     child: Row(
//                   children: <Widget>[
//                     Container(
//                         child: Row(
//                       children: <Widget>[
//                         IconTheme(
//                             child: Icon(Icons.favorite, size: 14),
//                             data: new IconThemeData(color: Colors.red)),
//                         // Icon(Icons.favorite),
//                         Text(
//                           'favorite Count',
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           ' | ',
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold),
//                         )
//                       ],
//                       // Icon(Icons.favorite), child: Text('Date')
//                     )),
//                     Flexible(
//                       child: Text('date'),
//                     )
//                     // Expanded(child: Text('dd')),
//                     // Expanded(
//                     //   child: Text('data'),
//                     // )
//                   ],
//                 ))
//               ],
//             ),
//           )));
// }

// Widget titleContainerMethod(int index) {
//   return Container(
//       margin: const EdgeInsets.only(left: 5),
//       width: 300,
//       child: Text(
//         tempData[index].title,
//         overflow: TextOverflow.ellipsis,
//         style: TextStyle(
//             color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
//       ));
// }

// Widget _commentCountMethod(int index) {
//   int _commentCount = tempData[index].commentCount;
//   Widget _commentCountText;
//   BoxDecoration _commentBoxDecoration;
//   //Under 30
//   if (tempData[index].commentCount < 30) {
//     _commentBoxDecoration =
//         new BoxDecoration(shape: BoxShape.circle, color: Colors.yellow);
//     _commentCountText = new Text('$_commentCount',
//         maxLines: 1,
//         style: TextStyle(
//             color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold));
//     //Up 30 Under 50
//   } else if (_commentCount >= 30 && _commentCount < 50) {
//     _commentBoxDecoration =
//         new BoxDecoration(shape: BoxShape.circle, color: Colors.orange);
//     _commentCountText = new Text('$_commentCount',
//         maxLines: 1,
//         style: TextStyle(
//             color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold));
//     //Over 50
//   } else {
//     _commentBoxDecoration =
//         new BoxDecoration(shape: BoxShape.circle, color: Colors.red);
//     if (_commentCount <= 100) {
//       _commentCountText = new Text('$_commentCount',
//           maxLines: 1,
//           style: TextStyle(
//               color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold));
//     } else {
//       _commentCountText = new Text('100+',
//           maxLines: 1,
//           style: TextStyle(
//               color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold));
//     }
//   }

//   return Container(
//       //CommentCount Container
//       height: 30,
//       width: 30,
//       decoration: _commentBoxDecoration,
//       child: Center(child: _commentCountText));
// }
