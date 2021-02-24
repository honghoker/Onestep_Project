import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onestep/cloth/providers/myProductProvider.dart';
import 'package:onestep/favorite/providers/favoriteProvider.dart';
import 'package:onestep/profile/provider/userProductProvider.dart';
import 'package:onestep/search/provider/searchProvider.dart';

import 'appmain/Route_Generator.dart';

import 'package:onestep/moor/moor_database.dart';
import 'package:provider/provider.dart';

import 'appmain/myhomepage.dart';
import 'cloth/models/category.dart';
import 'cloth/providers/productProvider.dart';

import 'login/CheckAuth.dart';
import 'login/LoginPage.dart';
import 'BoardLib/BoardProvi/boardClass.dart';
import 'BoardLib/BoardProvi/boardProvider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  BoardProvider _boardDB = BoardProvider();
  runApp(
    MultiProvider(
      providers: [
        Provider<Category>.value(value: new Category()),
        Provider<AppDatabase>.value(value: AppDatabase()),
        ChangeNotifierProvider<ProuductProvider>.value(
            value: new ProuductProvider()),
        ChangeNotifierProvider<SearchProvider>.value(
            value: new SearchProvider()),
        ChangeNotifierProvider<MyProductProvider>.value(
            value: new MyProductProvider()),
        ChangeNotifierProvider<UserProductProvider>.value(
            value: new UserProductProvider()),
        ChangeNotifierProvider<FavoriteProvider>.value(
            value: new FavoriteProvider()),
        StreamProvider<List<FreeBoardList>>.value(
            value: _boardDB.getFreeBoard(),
            catchError: (context, error) {
              print(error);
              return null;
            }),
        Provider<User>.value(
          value: _auth.currentUser,
        ),
        ChangeNotifierProvider<CheckAuth>(create: (_) => CheckAuth()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.grey, accentColor: Colors.grey),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: '/',
      title: '앱메인',
      debugShowCheckedModeBanner: false,
      home: _auth.currentUser != null ? MyHomePage() : LoginScreen(),
    );
  }
}

// void main() => runApp(TestApp());

// class TestApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Welcome to Flutter',
//       home: Scaffold(
//           appBar: AppBar(
//             title: Text('Welcome to Flutter'),
//           ),
//           body: MessageWidget()),
//     );
//   }
// }

// class MessageWidget extends StatefulWidget {
//   MessageWidget({Key key}) : super(key: key);

//   @override
//   _MessageWidgetState createState() => _MessageWidgetState();
// }

// class _MessageWidgetState extends State<MessageWidget> {
//   final List<Message> messages = [];
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   Future<dynamic> myBackgroundMessageHandler(
//       Map<String, dynamic> message) async {
//     if (message.containsKey('data')) {
//       // Handle data message
//       final dynamic data = message['data'];
//     }

//     if (message.containsKey('notification')) {
//       // Handle notification message
//       final dynamic notification = message['notification'];
//     }

//     // Or do other work.
//   }

//   @override
//   void initState() {
//     super.initState();
//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
//         final notification = message['notification'];
//         setState(() {
//           messages.add(Message(
//               title: notification['title'], body: notification['body']));
//         });
//         // _showItemDialog(message);
//       },
//       // onBackgroundMessage: myBackgroundMessageHandler,
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
//         setState(() {
//           messages.add(Message(title: '$message', body: 'OnLaunch'));
//         });

//         final notification = message['data'];

//         setState(() {
//           messages.add(Message(
//               title: 'OnLaunch : ${notification['title']}',
//               body: 'OnLaunch : ${notification['title']}'));
//         });
//         // _navigateToItemDetail(message);
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//         // _navigateToItemDetail(message);
//       },
//     );
//     _firebaseMessaging.requestNotificationPermissions(
//         const IosNotificationSettings(sound: true, badge: true, alert: true));
//   }

//   @override
//   Widget build(BuildContext context) => ListView(
//         children: messages.map(buildMessage).toList(),
//       );

//   Widget buildMessage(Message e) => ListTile(
//         title: Text(e.title),
//         subtitle: Text(e.body),
//       );
// }

// class Message {
//   final String title;
//   final String body;
//   Message({@required this.title, @required this.body});
// }

// final Map<String, Item> _items = <String, Item>{};
// Item _itemForMessage(Map<String, dynamic> message) {
//   final dynamic data = message['data'] ?? message;
//   final String itemId = data['id'];
//   final Item item = _items.putIfAbsent(itemId, () => Item(itemId: itemId))
//     ..status = data['status'];
//   return item;
// }

// class Item {
//   Item({this.itemId});
//   final String itemId;

//   StreamController<Item> _controller = StreamController<Item>.broadcast();
//   Stream<Item> get onChanged => _controller.stream;

//   String _status;
//   String get status => _status;
//   set status(String value) {
//     _status = value;
//     _controller.add(this);
//   }

//   static final Map<String, Route<void>> routes = <String, Route<void>>{};
//   Route<void> get route {
//     final String routeName = '/detail/$itemId';
//     return routes.putIfAbsent(
//       routeName,
//       () => MaterialPageRoute<void>(
//         settings: RouteSettings(name: routeName),
//         builder: (BuildContext context) => DetailPage(itemId),
//       ),
//     );
//   }
// }

// class DetailPage extends StatefulWidget {
//   DetailPage(this.itemId);
//   final String itemId;
//   @override
//   _DetailPageState createState() => _DetailPageState();
// }

// class _DetailPageState extends State<DetailPage> {
//   Item _item;
//   StreamSubscription<Item> _subscription;

//   @override
//   void initState() {
//     super.initState();
//     _item = _items[widget.itemId];
//     _subscription = _item.onChanged.listen((Item item) {
//       if (!mounted) {
//         _subscription.cancel();
//       } else {
//         setState(() {
//           _item = item;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Item ${_item.itemId}"),
//       ),
//       body: Material(
//         child: Center(child: Text("Item status: ${_item.status}")),
//       ),
//     );
//   }
// }

// class PushMessagingExample extends StatefulWidget {
//   @override
//   _PushMessagingExampleState createState() => _PushMessagingExampleState();
// }

// class _PushMessagingExampleState extends State<PushMessagingExample> {
//   String _homeScreenText = "Waiting for token...";
//   bool _topicButtonsDisabled = false;

//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   final TextEditingController _topicController =
//       TextEditingController(text: 'topic');

//   Widget _buildDialog(BuildContext context, Item item) {
//     return AlertDialog(
//       content: Text("Item ${item.itemId} has been updated"),
//       actions: <Widget>[
//         FlatButton(
//           child: const Text('CLOSE'),
//           onPressed: () {
//             Navigator.pop(context, false);
//           },
//         ),
//         FlatButton(
//           child: const Text('SHOW'),
//           onPressed: () {
//             Navigator.pop(context, true);
//           },
//         ),
//       ],
//     );
//   }

//   void _showItemDialog(Map<String, dynamic> message) {
//     showDialog<bool>(
//       context: context,
//       builder: (_) => _buildDialog(context, _itemForMessage(message)),
//     ).then((bool shouldNavigate) {
//       if (shouldNavigate == true) {
//         _navigateToItemDetail(message);
//       }
//     });
//   }

//   void _navigateToItemDetail(Map<String, dynamic> message) {
//     final Item item = _itemForMessage(message);
//     // Clear away dialogs
//     Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
//     if (!item.route.isCurrent) {
//       Navigator.push(context, item.route);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
//         _showItemDialog(message);
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
//         _navigateToItemDetail(message);
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//         _navigateToItemDetail(message);
//       },
//     );
//     _firebaseMessaging.requestNotificationPermissions(
//         const IosNotificationSettings(
//             sound: true, badge: true, alert: true, provisional: true));
//     _firebaseMessaging.onIosSettingsRegistered
//         .listen((IosNotificationSettings settings) {
//       print("Settings registered: $settings");
//     });
//     _firebaseMessaging.getToken().then((String token) {
//       assert(token != null);
//       setState(() {
//         _homeScreenText = "Push Messaging token: $token";
//       });
//       print(_homeScreenText);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Push Messaging Demo'),
//         ),
//         // For testing -- simulate a message being received
//         floatingActionButton: FloatingActionButton(
//           onPressed: () => _showItemDialog(<String, dynamic>{
//             "data": <String, String>{
//               "id": "2",
//               "status": "out of stock",
//             },
//           }),
//           tooltip: 'Simulate Message',
//           child: const Icon(Icons.message),
//         ),
//         body: Material(
//           child: Column(
//             children: <Widget>[
//               Center(
//                 child: Text(_homeScreenText),
//               ),
//               Row(children: <Widget>[
//                 Expanded(
//                   child: TextField(
//                       controller: _topicController,
//                       onChanged: (String v) {
//                         setState(() {
//                           _topicButtonsDisabled = v.isEmpty;
//                         });
//                       }),
//                 ),
//                 FlatButton(
//                   child: const Text("subscribe"),
//                   onPressed: _topicButtonsDisabled
//                       ? null
//                       : () {
//                           _firebaseMessaging
//                               .subscribeToTopic(_topicController.text);
//                           _clearTopicText();
//                         },
//                 ),
//                 FlatButton(
//                   child: const Text("unsubscribe"),
//                   onPressed: _topicButtonsDisabled
//                       ? null
//                       : () {
//                           _firebaseMessaging
//                               .unsubscribeFromTopic(_topicController.text);
//                           _clearTopicText();
//                         },
//                 ),
//               ])
//             ],
//           ),
//         ));
//   }

//   void _clearTopicText() {
//     setState(() {
//       _topicController.text = "";
//       _topicButtonsDisabled = true;
//     });
//   }
// }

// void main() => runApp(TestApp());
// class TestApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: PushMessagingExample(),
//     );
//   }
// }
