import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'appmain/Route_Generator.dart';

import 'package:onestep/moor/moor_database.dart';
import 'package:provider/provider.dart';

import 'cloth/models/category.dart';
import 'cloth/providers/productProvider.dart';

import 'login/LoginPage.dart';
import 'BoardLib/BoardProvi/boardClass.dart';
import 'BoardLib/BoardProvi/boardProvider.dart';

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
        StreamProvider<List<FreeBoardList>>.value(
            value: _boardDB.getFreeBoard(),
            catchError: (context, error) {
              print(error);
              return null;
            })
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: '/',
      title: '앱메인',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
