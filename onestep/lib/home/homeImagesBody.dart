// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:onestep/cloth/clothitem.dart';
// import 'package:onestep/moor/moor_database.dart';

// class HomeImagesBody extends StatefulWidget {
//   double itemWidth, itemHeight;
//   HomeImagesBody(double itemWidth, double itemHeight) {
//     this.itemWidth = itemWidth;
//     this.itemHeight = itemHeight;
//   }

//   @override
//   _HomeImagesBodyState createState() =>
//       _HomeImagesBodyState(this.itemWidth, this.itemHeight);
// }

// class _HomeImagesBodyState extends State<HomeImagesBody> {
//   double itemWidth, itemHeight;
//   _HomeImagesBodyState(itemWidth, itemHeight) {
//     this.itemWidth = itemWidth;
//     this.itemHeight = itemHeight;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         margin: EdgeInsets.only(top: 10),
//         child: StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection('products')
//                 .orderBy("uploadtime", descending: true)
//                 .limit(6)
//                 .snapshots(),
//             builder:
//                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (snapshot.hasError) return Text('Error: ${snapshot.error}');
//               switch (snapshot.connectionState) {
//                 case ConnectionState.waiting:
//                   return Text("");
//                 default:
//                   return GridView.builder(
//                     shrinkWrap: true,
//                     // physics: ScrollPhysics(),
//                     physics: NeverScrollableScrollPhysics(),
//                     padding: EdgeInsets.symmetric(horizontal: 15),
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3,
//                       // mainAxisSpacing: 1.0,
//                       // crossAxisSpacing: 1.0,
//                       childAspectRatio: (itemWidth / itemHeight),
//                       mainAxisSpacing: 10,
//                       crossAxisSpacing: 10,
//                     ),
//                     itemCount: snapshot.data.docs.length,
//                     itemBuilder: (context, index) {
//                       Timestamp time =
//                           snapshot.data.docs[index].data()['uploadtime'];

//                       return ClothItem(
//                         product: Product(
//                           firestoreid: snapshot.data.docs[index].id,
//                           title: snapshot.data.docs[index].data()['title'],
//                           category:
//                               snapshot.data.docs[index].data()['category'],
//                           price: snapshot.data.docs[index].data()['price'],
//                           images: jsonEncode(
//                               snapshot.data.docs[index].data()['images']),
//                           explain: snapshot.data.docs[index].data()['explain'],
//                           views: snapshot.data.docs[index].data()['views'],
//                           uploadtime: time.toDate(),
//                         ),
//                       );
//                     },
//                   );
//               }
//             }),
//       ),
//     );
//   }
// }
