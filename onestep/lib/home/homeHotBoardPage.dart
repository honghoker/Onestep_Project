import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeHotBoardPage extends StatefulWidget {
  @override
  _HomeHotBoardPageState createState() => _HomeHotBoardPageState();
}

class _HomeHotBoardPageState extends State<HomeHotBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text("Hot 게시물"),
      ),
      body: ListView(
          children: [
            // Load a Lottie file from your assets
            // Lottie.asset('images/Logo.json'),

            // // Load a Lottie file from a remote url
            Lottie.network(
                'https://assets9.lottiefiles.com/private_files/lf30_8vt2n7.json'),

            // // Load an animation and its images from a zip file
            // Lottie.asset('assets/lottiefiles/angel.zip'),
          ],
        ),
    );
  }
}