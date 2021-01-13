import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Widget GetTime(DocumentSnapshot document) {
//   return Text(
//     DateFormat("yy년 MM월 dd일 kk:mm: aa").format(
//         DateTime.fromMillisecondsSinceEpoch(int.parse(document["timestamp"]))),
//     style: TextStyle(
//         color: Colors.grey, fontSize: 12.0, fontStyle: FontStyle.italic),
//   );
// }
//GetTimeToChatList
Widget GetTime(DocumentSnapshot document) {
  // var t2 = DateFormat("yy년 MM월 dd일 kk:mm:a").format(
  //     DateTime.fromMillisecondsSinceEpoch(int.parse(document["timestamp"])));

  // print("datetime " + t);
  // print("datetime " + t2);
  // print("datetime원문 " + document["timestamp"]);
  // print("datetime스플릿 " + tsp.toString());

  return Text(
    _getChatListTime(document),
    style: TextStyle(
      color: Colors.grey,
      fontSize: 12.0,
      //  fontStyle: FontStyle.italic,
    ),
  );
}

//String _translateTime(String time) {}

String _getChatListTime(DocumentSnapshot document) {
  var date; //chattingRoom
  var time;
  var dayoftheweek; //chattingRoom
  var meridiem;

  var nowtime = DateFormat("yyyy년 MM월 dd일/EEEE/a/kk:mm").format(
      DateTime.fromMillisecondsSinceEpoch(
          int.parse(DateTime.now().millisecondsSinceEpoch.toString())));
  var nowtimelist = nowtime.split('/');

  var gettime = DateFormat("yyyy년 MM월 dd일/EEEE/a/kk:mm").format(
      DateTime.fromMillisecondsSinceEpoch(int.parse(document["timestamp"])));
  var gettimelist = gettime.split('/');

  if (nowtimelist[0] == gettimelist[0]) {
    print(nowtimelist[0] + gettimelist[0]);
    //오늘날짜일 경우 시간 보여준다.
    meridiem = _getMeridiem((gettimelist[2]));
    time = gettimelist[3]; //오전 오후 12시 기준
    //dayoftheweek = _getDayOfTheWeek((gettimelist[1]));

    return meridiem + " " + time;
  } else {
    //오늘 날짜 아닐 경우
    var nowtime = DateFormat("yyyy-MM-dd-").format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(document["timestamp"])));
    dayoftheweek = _getDayOfTheWeek((gettimelist[1]));
    return nowtime + dayoftheweek;
  }
}

String _getMeridiem(String meridiem) {
  return meridiem == "PM" ? "오후" : "오전";
}

String _getDayOfTheWeek(String dayoftheweek) {
  //String dayoftheweek;
  switch (dayoftheweek) {
    case 'Monday':
      dayoftheweek = "월";
      break;
    case 'Tuesday':
      dayoftheweek = "화";
      break;
    case 'Wednesday':
      dayoftheweek = "수";
      break;
    case 'Thursday':
      dayoftheweek = "목";
      break;
    case 'Friday':
      dayoftheweek = "금";
      break;
    case 'Saturday':
      dayoftheweek = "토";
      break;
    case 'Sunday':
      dayoftheweek = "일";
      break;
    default:
      dayoftheweek = "요일 오류";
      break;
  }
  return dayoftheweek;
}
