import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onestep/cloth/category.dart';
import 'package:onestep/moor/moor_database.dart';
import 'package:provider/provider.dart';

import 'login/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        Provider<Category>.value(value: new Category()),
        Provider<AppDatabase>.value(value: AppDatabase()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '앱메인',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      //home: MyHomePage(),
      //home: GoogleSignInDemo2(),
    );
  }
}
