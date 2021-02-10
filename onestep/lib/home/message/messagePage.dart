import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep/api/firebase_api.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class FavoriteProvider {}

class _MessagePageState extends State<MessagePage> {
  final _explainTextEditingController = TextEditingController();

  Widget buildBottomSheet(BuildContext context) {
    return Container(
      color: Color(0xFF737373),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              topRight: const Radius.circular(10),
            )),
        child: Column(
          children: [
            ListTile(
              title: Center(
                  child: Text(
                "낚시/도배",
                style: TextStyle(fontSize: 20),
              )),
              onTap: () => reportDialog(),
            ),
            Divider(
              height: 10,
              thickness: 2,
            ),
            ListTile(
              title: Center(
                  child: Text(
                "욕설/비하",
                style: TextStyle(fontSize: 20),
              )),
              onTap: () => reportDialog(),
            ),
            Divider(
              height: 10,
              thickness: 2,
            ),
            ListTile(
              title: Center(
                  child: Text(
                "상업적 광고 및 피해",
                style: TextStyle(fontSize: 20),
              )),
              onTap: () => reportDialog(),
            ),
            Divider(
              height: 10,
              thickness: 2,
            ),
            ListTile(
              title: Center(
                  child: Text(
                "정당/정치인 비하 및 선거운동",
                style: TextStyle(fontSize: 20),
              )),
              onTap: () => reportDialog(),
            ),
            Divider(
              height: 10,
              thickness: 2,
            ),
            ListTile(
              title: Center(
                  child: Text(
                "기타",
                style: TextStyle(fontSize: 20),
              )),
              onTap: () => showModalBottomSheet(
                  context: context,
                  builder: buildBottomEtcSheet,
                  isScrollControlled: false),
            )
          ],
        ),
      ),
    );
  }

  Widget buildBottomEtcSheet(BuildContext context) {
    return Container(
        height: 500,
        color: Color(0xFF737373),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: ("내용을 입력해주세요"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    onPressed: () {
                      reportDialog();
                    },
                    child: Text("보내기"),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void reportDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: IntrinsicWidth(
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Title",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: "Roboto",
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Content",
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("OK"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // void reportDialog(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           title: Text("Title"),
  //           content: Text("Content"),
  //           actions: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 FlatButton(
  //                   onPressed: () {
  //                     print("취소 click");
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text("취소"),
  //                 ),
  //                 FlatButton(
  //                   onPressed: () {
  //                     print("확인 click");
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text("확인"),
  //                 ),
  //               ],
  //             )
  //           ],
  //         );
  //       });
  // }

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
                // sendMail();
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
