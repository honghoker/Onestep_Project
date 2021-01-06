import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'CreateAlterBoard/parentState.dart';
import 'boardContent.dart';
import 'package:path/path.dart' as p;
import 'package:onestep/appmain/myhomepage.dart';

class RouteGenerator {
  static bool _isIOS =
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  static Route<dynamic> generateRoute(RouteSettings settings) {
    assert(settings.name.indexOf("/") == 0,
        "[ROUTER] routing MUST Begin with '/'");

    var _reDefine = settings.name.replaceFirst("/", "");
    var _pathParams = p.split(
        _reDefine.split("?").length > 1 ? _reDefine.split("?")[0] : _reDefine);

    //QueryParameters example
    // print(Uri.base.toString()); // http://localhost:8082/game.html?id=15&randomNumber=3.14
    // print(Uri.base.query);  // id=15&randomNumber=3.14
    // print(Uri.base.queryParameters['randomNumber']); // 3.14
    Map<String, dynamic> arguments = settings.arguments ??
        Uri.parse(settings.name.replaceFirst("/", "")).queryParameters ??
        {};
    var _pageName = _pathParams.isNotEmpty ? _pathParams.first : null;
    Widget _pageWidget;

    switch (_pageName) {
      case 'MainPage':
        _pageWidget = MyHomePage(currentUserId: arguments['UID']);
        break;

      case 'BoardContent':
        _pageWidget = BoardContent(
          index: int.parse(arguments['INDEX']),
          boardName: arguments["BOARD_NAME"],
        );
        break;
      case 'CreateBoard':
        _pageWidget = CreateBoard();
        break;
    }
    return _isIOS
        ? CupertinoPageRoute(builder: (context) => _pageWidget)
        : MaterialPageRoute(builder: (context) => _pageWidget);
  }
}
