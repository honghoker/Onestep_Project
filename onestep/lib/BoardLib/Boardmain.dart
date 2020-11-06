import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'WasFirstPageView.dart';
import 'package:onestep/BoardLib/ListView_Pcs.dart';

const String page1 = 'Page 1';
const String page2 = 'Page 2';
const int PERSONALIMPOBOARDIndex = 3;
const int TODAYFAVORITEBOARDIndex = 1;
const int BOARDPERSONALIMPOIndex = 2;
const int LISTBOARDIndex = 0;

class tempTitleData {
  var title;
  var subtitle;
  int commentCount;
  int favoriteCount;
  var date;
  tempTitleData(this.title, this.subtitle, this.commentCount,
      this.favoriteCount, this.date);
}

class BoardState extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<BoardState> {
  bool isScrollingDown = false;
  double bottomBarHeight = 75;
  ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  bool get _hideFAB {
    return _scrollController.hasClients &&
        _scrollController.offset > (100 - kToolbarHeight);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget containterContent() {
    return Container(
      height: 50.0,
      color: Colors.cyanAccent,
      margin: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width - 100,
      child: Center(
          child: Text(
        'Item 1',
        style: TextStyle(
          fontSize: 14.0,
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
            body: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) =>
                      _boardPageTabBarDesign(context, innerBoxIsScrolled),
              body: _boardPageTabBarView(),
            ),
            floatingActionButton: _hideFAB
                ? Container()
                : FloatingActionButton(
                    onPressed: () {
                      print(
                          'Current Index : ${DefaultTabController.of(context).index}');
                    },
                    child: DefaultTabController.of(context).index != 0
                        ? Icon(Icons.add)
                        : Icon(Icons.access_alarm)),
          );
        }));
  }

  _boardPageTabBarDesign(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      new SliverAppBar(
        backgroundColor: Colors.white,
        title: new Text("widget.title"),
        pinned: true,
        floating: true,
        forceElevated: innerBoxIsScrolled,
        bottom: TabBar(
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Colors.white),
            tabs: [
              _tabBarTextDesign(text: "최신순"),
              _tabBarTextDesign(text: "추천순"),
              _tabBarTextDesign(text: "오늘의"),
            ]),
      ),
    ];
  }

  _boardPageTabBarView() {
    return TabBarView(
      children: <Widget>[
        FirstPageView(),
        TempPageView(),
        Icon(Icons.games),
      ],
    );
  }

  _tabBarTextDesign({@required String text, var textStyle}) {
    return Tab(
      child: Align(
          alignment: Alignment.center,
          child: Text(text,
              style: textStyle ??
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );
  }
// class _BoardState extends State<BoardState>
//     with SingleTickerProviderStateMixin {
//   TabController _tabController;
//   ScrollController _scrollViewController;
//   @override
//   void initState() {
//     super.initState();
//     _scrollViewController = new ScrollController();
//     _tabController = new TabController(vsync: this, length: 3);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new StoreConnector<ReduxState, MainPageViewModel>(
//       converter: (store) {
//         return new MainPageViewModel([...]);
//       },
//       builder: (context, viewModel) {
//         return new Scaffold(
//             appBar: new AppBar(
//               title: new Text("widget.title"),
//               bottom: new TabBar(
//                 tabs: <Tab>[
//                   new Tab(
//                     text: "STATISTICS",
//                     icon: new Icon(Icons.show_chart),
//                   ),
//                   new Tab(
//                     text: "HISTORY",
//                     icon: new Icon(Icons.history),
//                   ),
//                 ],
//                 controller: _tabController,
//               ),
//             ),
//             body: new TabBarView(
//               children: <Widget>[
//                 new Red(),
//                 new Blue(),
//               ],
//               controller: _tabController,
//             ),
//         );
//       },
//     );
//   }

// Widget build(BuildContext context) {
//   return MaterialApp(
//       home: DefaultTabController(
//           length: 3,
//           child: Scaffold(
//             body: new NestedScrollView(
//               headerSliverBuilder:
//                   (BuildContext context, bool innerBosIsScrolled) {
//                 return <Widget>[
//                   new SliverAppBar(

//                              )
//                 ];
//               },
//               body: null,
//               controller: _scrollController,
//             ),
//             appBar: AppBar(
//               backgroundColor: Colors.white,
//               elevation: 0,
//               bottom: TabBar(
//                   unselectedLabelColor: Colors.redAccent,
//                   indicatorSize: TabBarIndicatorSize.tab,
//                   indicator: BoxDecoration(
//                       gradient: LinearGradient(
//                           colors: [Colors.redAccent, Colors.orangeAccent]),
//                       borderRadius: BorderRadius.circular(50),
//                       color: Colors.redAccent),
//                   tabs: [
//                     Tab(
//                       child: Align(
//                         alignment: Alignment.center,
//                         child: Text("APPS"),
//                       ),
//                     ),
//                     Tab(
//                       child: Align(
//                         alignment: Alignment.center,
//                         child: Text("MOVIES"),
//                       ),
//                     ),
//                     Tab(
//                       child: Align(
//                         alignment: Alignment.center,
//                         child: Text("GAMES"),
//                       ),
//                     ),
//                   ]),
//             ),
//             body: TabBarView(children: <Widget>[
//               FirstPageView(),
//               Icon(Icons.movie),
//               Icon(Icons.games),
//             ]),
//           )
//           )
//           )            ;
// }
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
