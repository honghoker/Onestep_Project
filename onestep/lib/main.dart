import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onestep/cloth/category.dart';
import 'package:onestep/cloth/databaseprovider.dart';
import 'package:onestep/moor/moor_database.dart';
import 'package:provider/provider.dart';

import 'login/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //DatabaseProvider db = DatabaseProvider();
  //AppDatabase moordb = AppDatabase();
  runApp(
    MultiProvider(
      providers: [
        // StreamProvider<FirebaseUser>.value(
        //     value: FirebaseAuth.instance.authStateChanges()),
        // Provider<ProductsDao>(create: (_) => AppDatabase().productsDao),
        //Provider<AppDatabase>(create: (_) => AppDatabase()),
        
        Provider<AppDatabase>.value(value: AppDatabase()),
        // Provider<AppDatabase>.value(value: moordb),
        // StreamProvider<List<Category>>.value(value: db.getCategory())
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
