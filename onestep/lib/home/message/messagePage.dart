import 'package:flutter/material.dart';
import 'package:onestep/home/sendMail.dart';
import 'package:onestep/report/reportController.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class FavoriteProvider {}

class _MessagePageState extends State<MessagePage> {
  final _explainTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "쪽지 보내기",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: [
            FlatButton(
              onPressed: () {
                // sendMail(0);

                // report test
                showModalBottomSheet(
                    context: context,
                    builder: buildBottomSheet,
                    isScrollControlled: false);
              },
              child: Text("보내기"),
            )
          ],
        ),
        body: Container(
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: TextField(
              controller: _explainTextEditingController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "내용을 입력해주세요",
                border: InputBorder.none,
              ),
            ),
          ),
        ));
  }
}
