import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'BoardList/boardList.dart';
import 'BoardList/boardListView.dart';
import 'boardContent.dart';
import 'boardPersonal.dart';

class TempPageView extends StatefulWidget {
  _Temp createState() => _Temp();
}

class _Temp extends State<TempPageView> {
  // BuildContext context;
  // GeneralBoard(BuildContext context);
  // GeneralBoard({@required this.context}) : assert(context != null);

  @override
  Widget build(BuildContext context) {
    return Container(
        // child: ListView.builder(

        //     //PageStorageKey is Keepping ListView scroll position when switching pageview
        //     key: PageStorageKey<String>("value"),
        //     //Bottom Padding
        //     padding:
        //         const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 60),
        //     itemCount: tempData.length,
        //     itemBuilder: (context, index) => _buildListCard(context, index))
        );
  }
}

Widget _buildListCard(BuildContext context, int index) {
  return Card(
      child: Padding(
          padding: const EdgeInsets.all(1.0),
          //Click Animation
          child: InkWell(
            // Set Click Color
            splashColor: Colors.grey,
            //Click Event
            onTap: () {
              Navigator.of(context).pushNamed('/BoardContent', arguments: {
                "INDEX": index,
                "BOARD_NAME": 'current test Board'
              });
              // Navigator.push(
              //     context,
              //     CupertinoPageRoute(
              //       fullscreenDialog: false,
              //       builder: (context) => BoardContent(
              //         index: index,
              //         boardName: 'Current Test Board',
              //       ),
              //     ));
            },
            child: Column(
              children: <Widget>[
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //Title Container
                    // titleContainerMethod(index),
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
