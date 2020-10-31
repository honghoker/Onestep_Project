import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentView extends StatelessWidget {
  final DocumentSnapshot documentData;
  final String loginId;

  DocumentView(this.documentData, this.loginId);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: ListTile(
          title: Row(
            children: <Widget>[
              Text(
                documentData.data()["board"].toString(),
              ),
              Text('   받은유저(본인id) : ' +
                  documentData.data()["receive_user"].toString()),
              Spacer(),
              SizedBox(width: 150, height: 10),
              // Text(
              //   documentData.data()["recent_chattime"].toString(),
              //   overflow: TextOverflow.fade,
              //   maxLines: 1,
              //   softWrap: false,
              // ),
            ],
          ),
          subtitle: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('sendUser : ' + documentData.data()["send_user"].toString()),
              SizedBox(width: 10, height: 10),
              Text('text : ' + documentData.data()["recent_text"].toString()),
              SizedBox(width: 10, height: 10),
              Spacer(), //간격 넓히기
              // Container(
              //   child: Text(
              //     '읽지 않음 : ' +
              //         documentData.data()["no_read_count"].toString() +
              //         '   ',
              //     textAlign: TextAlign.left,
              //   ),
              // ),
            ],
          ),
          onTap: () {
            print(loginId.toString() + ' 로그인');
            print(' 받는유저' + documentData.data()["receive_user"].toString());
            print(' 보낸유저' + documentData.data()["send_user"].toString());

            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => FriendlychatApp()));
          },
        ),
      ),
    );
  }
}
