import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'login/LoginPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(),
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
