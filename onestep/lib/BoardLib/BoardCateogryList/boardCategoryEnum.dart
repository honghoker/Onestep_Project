import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:onestep/BoardLib/BoardProvi/boardProvider.dart';
import 'package:path/path.dart' as p;
import 'package:onestep/BoardLib/CustomException/customThrow.dart';

enum BoardCategory { Free }

extension BoardCategoryExtension on BoardCategory {
  String get categoryEN {
    switch (this) {
      case BoardCategory.Free:
        return "Board_Free";

      default:
        return throw CategoryException(
            "Enum Board Category Error, Please Update Enum BoardCategory in Boardmain.dart");
    }
  }

  String get categoryKR {
    switch (this) {
      case BoardCategory.Free:
        return "자유게시판";

      default:
        return throw CategoryException(
            "Enum Board Category Error, Please Update Enum BoardCategory in Boardmain.dart");
    }
  }
}

// class Boardmain extends StatefulWidget {
//   final Function boardSelectedCallback;
//   final BoardCategory boardCategory;
//   final BoardProvider boardProvider;
//   Boardmain(
//       {key, this.boardCategory, this.boardProvider, this.boardSelectedCallback})
//       : super(key: key);
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<Boardmain> {
//   // String currentBoard = "자유게시판";
//   bool _hideFAB = false;
//   double bottomBarHeight = 75;
//   BoardCategory _boardCategory;
//   @override
//   void initState() {
//     _boardCategory = widget.boardCategory ?? BoardCategory.Free;
//     print(p.split(''));
//     super.initState();
//   }

//   listViewFABCallback(bool isScrlDirectUp) {
//     _hideFAB = isScrlDirectUp;
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BoardList(
//         callback: listViewFABCallback,
//         boardProvider: widget.boardProvider,
//       ),
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(50.0),
//         child: AppBar(
//           backgroundColor: Colors.white,
//         ),
//       ),
//       floatingActionButton: _hideFAB
//           ? Container()
//           : FloatingActionButton(
//               backgroundColor: Colors.black,
//               onPressed: () {
//                 print(_boardCategory.categoryEN);
//                 Navigator.of(context).pushNamed('/CreateBoard',
//                     arguments: {"CURRENTBOARD": BoardCategory.Free});
//               },
//               child: Icon(Icons.add)),
//     );
//   }
// }
