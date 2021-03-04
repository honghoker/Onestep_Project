// import 'package:flutter/material.dart';

// class BoardList {
//   BoardList(BuildContext context);
//   ListView buildBoardListView(BuildContext context) {
//     return ListView.builder(
//         itemCount: 10,
//         itemBuilder: (BuildContext context, index) =>
//             _buildBoardListCard(context, index));
//   }

//   Widget _buildBoardListCard(BuildContext context, int index) {
//     return Card(
//       child: InkWell(
//         splashColor: Colors.grey,
//         onTap: () {
//           return Scaffold.of(context)
//               .showSnackBar(SnackBar(content: Text(index.toString())));
//         },
//         child: Column(
//           children: <Widget>[Container(child: Text('First Page'))],
//         ),
//       ),
//     );
//   }
// }
