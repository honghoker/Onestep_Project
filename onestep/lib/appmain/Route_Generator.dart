import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:onestep/login/joinPage.dart';
import '../BoardLib/CreateAlterBoard/parentState.dart';
import '../BoardLib/boardContent.dart';
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

    //example:

    //case에는 /를 제외하고 원하는 이름으로 설정, pushNamed할 때는 /를 포함하여 자신이 설정한 이름으로 불러옴.
    switch (_pageName) {
      case 'MainPage':
        //var arg = preferences.getString('id') ?? '아이디없음';
        // Navigator.of(context).pushNamed('/MainPage?UID=$arg'); 또는
        // Navigator.of(context).pushNamed('/BoardContent',arguments: {"BOARD_DATA": boardDataList[index]}); 으로 사용
        _pageWidget = MyHomePage();
        break;

      case 'BoardContent':
        // Navigator.of(context).pushNamed('/BoardContent?INDEX=$index&BOARD_NAME="current"') -> arguments['INDEX'] = index, arguments['BOARD_NAME'] = "current"
        _pageWidget = BoardContent(
          boardData: arguments["BOARD_DATA"],
        );
        break;
      case 'CreateBoard':
        _pageWidget = CreateBoard(
          currentBoard: arguments['CURRENTBOARD'],
        );
        break;
      case 'JoinPage':
        _pageWidget = JoinScreen(currentUserId: arguments['UID']);
        break;
    }
    return _isIOS
        ? CupertinoPageRoute(builder: (context) => _pageWidget)
        : MaterialPageRoute(builder: (context) => _pageWidget);
  }
}
