import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:onestep/BoardLib/secondPageView.dart';
import 'package:onestep/BoardLib/boardListView.dart';
import 'package:path/path.dart' as p;

// const String page1 = 'Page 1';
// const String page2 = 'Page 2';
// const int PERSONALIMPOBOARDIndex = 3;
// const int TODAYFAVORITEBOARDIndex = 1;
// const int BOARDPERSONALIMPOIndex = 2;
// const int LISTBOARDIndex = 0;

class tempTitleData {
  var title;
  var subtitle;
  int commentCount;
  int favoriteCount;
  var date;
  tempTitleData(this.title, this.subtitle, this.commentCount,
      this.favoriteCount, this.date);
}

class BoardMain extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<BoardMain> {
  bool _hideFAB = false;
  double bottomBarHeight = 75;

  @override
  void initState() {
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
    return DefaultTabController(
        length: 3,
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
            body: _boardPageTabBarView(),
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(50.0),
                child: AppBar(
                  backgroundColor: Colors.white,
                  bottom: TabBar(
                    indicator: CircleTabIndicator(
                        color: Colors.greenAccent, radius: 5),
                    //  UnderlineTabIndicator(
                    //     borderSide:
                    //         BorderSide(width: 2.0, color: Colors.redAccent),
                    //     insets: EdgeInsets.symmetric(horizontal: 16.0)),

                    tabs: _boardPageTabBarDesign(context),
                  ),
                )),
            floatingActionButton: _hideFAB
                ? Container()
                : FloatingActionButton(
                    backgroundColor: Colors.black,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/CreateBoard');
                    },
                    child: Icon(Icons.add)),
          );
        }));
  }

  List<Widget> _boardPageTabBarDesign(BuildContext context) {
    return [
      _tabBarTextDesign(text: "최신순"),
      _tabBarTextDesign(text: "추천순"),
      _tabBarTextDesign(text: "오늘의"),
    ];
  }

  _boardPageTabBarView() {
    return TabBarView(
      children: <Widget>[
        FirstPageView(
          callback: listViewFABCallback,
        ),
        FirstPageView(
          callback: listViewFABCallback,
        ),
        Practice(),
      ],
    );
  }

  _tabBarTextDesign({@required String text, var textStyle}) {
    return Tab(
      child: Align(
          alignment: Alignment.center,
          child: Text(text,
              style: textStyle ??
                  TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black))),
    );
  }
}

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
