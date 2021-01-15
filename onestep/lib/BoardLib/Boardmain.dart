import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:onestep/BoardLib/secondPageView.dart';
import 'package:onestep/BoardLib/BoardList/boardListView.dart';
import 'package:path/path.dart' as p;
import 'package:onestep/BoardLib/CustomException/customThrow.dart';

enum BoardCategory { Free }

extension BoardCategoryExtension on BoardCategory {
  String get categoryEN {
    switch (this) {
      case BoardCategory.Free:
        return "Free";

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

class Boardmain extends StatefulWidget {
  final BoardCategory boardCategory;
  Boardmain({key, this.boardCategory}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Boardmain> {
  // String currentBoard = "자유게시판";
  bool _hideFAB = false;
  double bottomBarHeight = 75;
  BoardCategory _boardCategory;
  @override
  void initState() {
    _boardCategory = widget.boardCategory ?? BoardCategory.Free;
    print(p.split(''));
    super.initState();
  }

  listViewFABCallback(bool isScrlDirectUp) {
    setState(() {
      _hideFAB = isScrlDirectUp;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FreeBoard(
        callback: listViewFABCallback,
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Colors.white,

          //  UnderlineTabIndicator(
          //     borderSide:
          //         BorderSide(width: 2.0, color: Colors.redAccent),
          //     insets: EdgeInsets.symmetric(horizontal: 16.0)),
        ),
      ),
      floatingActionButton: _hideFAB
          ? Container()
          : FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {
                print(_boardCategory.toString());
                Navigator.of(context).pushNamed('/CreateBoard',
                    arguments: {"CURRENTBOARD": _boardCategory});
              },
              child: Icon(Icons.add)),
    );
  }
}

// List<Widget> _boardPageTabBarDesign(BuildContext context) {
//   return [
//     _tabBarTextDesign(text: "최신순"),
//     _tabBarTextDesign(text: "추천순"),
//     _tabBarTextDesign(text: "오늘의"),
//   ];
// }

// _boardPageTabBarView() {
//   return TabBarView(
//     children: <Widget>[
//       FreeBoard(
//         callback: listViewFABCallback,
//       ),
//       FreeBoard(
//         callback: listViewFABCallback,
//       ),
//       Practice(),
//     ],
//   );
// }

// _tabBarTextDesign({@required String text, var textStyle}) {
//   return Tab(
//     child: Align(
//         alignment: Alignment.center,
//         child: Text(text,
//             style: textStyle ??
//                 TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black))),
//   );
// }

class Red extends StatefulWidget {
  @override
  _RedState createState() => _RedState();
}

class _RedState extends State<Red> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}

class Blue extends StatefulWidget {
  @override
  _BlueState createState() => _BlueState();
}

class _BlueState extends State<Blue> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
    );
  }
}

class Yellow extends StatefulWidget {
  @override
  _YellowState createState() => _YellowState();
}

class _YellowState extends State<Yellow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellowAccent,
    );
  }
}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size.width / 2, cfg.size.height - radius);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
