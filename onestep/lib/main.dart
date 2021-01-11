import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'appmain/Route_Generator.dart';

import 'package:onestep/moor/moor_database.dart';
import 'package:provider/provider.dart';

import 'appmain/myhomepage.dart';
import 'cloth/models/category.dart';
import 'cloth/providers/productProvider.dart';

import 'login/LoginPage.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        Provider<Category>.value(value: new Category()),
        Provider<AppDatabase>.value(value: AppDatabase()),
        ChangeNotifierProvider<ProuductProvider>.value(
            value: new ProuductProvider()),
        Provider<User>.value(
          value: _auth.currentUser,
        ),
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
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: '/',
      title: '앱메인',
      debugShowCheckedModeBanner: false,
      home: _auth.currentUser != null ? MyHomePage() : LoginScreen(),
    );
  }
}
