import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class SecondPageView extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SecondPageView> {
  bool showTextField = false;
  Widget _buildFloatingSearchBtn() {
    return Expanded(
      child: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          setState(() {
            showTextField = !showTextField;
          });
        },
      ),
    );
  }

  Widget _buildTextField() {
    return Expanded(
      child: Center(
        child: TextField(
          onTap: () {
            showTextField = false;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search + Text'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
              child: Row(
                children: <Widget>[
                  showTextField ? _buildTextField() : Container(),
                  _buildFloatingSearchBtn(),
                ],
              ),
            )
          ],
        ));
  }
}
