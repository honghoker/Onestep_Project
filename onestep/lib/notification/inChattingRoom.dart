import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onestep/notification/time/chat_time.dart';
import 'package:onestep/notification/widget/FullmageWidget.dart';
import 'package:intl/intl.dart';

import 'Controllers/firebaseChatController.dart';

class InChattingRoomPage extends StatelessWidget {
  final String myUid;
  final String friendId;
  final String postId;

  InChattingRoomPage(
      {@required this.myUid, @required this.friendId, @required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              //backgroundImage: CachedNetworkImageProvider(),
            ),
          ),
          //_deleteChattingRoom(context), //삭제 다시 구현
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "myUid : $myUid",
              style: TextStyle(fontSize: 9),
            ),
            Text(
              "friendId : $friendId",
              style: TextStyle(fontSize: 9),
            ),
            Text(
              "chatRoomUid : $postId",
              style: TextStyle(fontSize: 9),
            ),
          ],
        ),
      ),
      body: ChatScreen(
        myUid: myUid,
        friendId: friendId,
        postId: postId,
      ),
    );
  }
}

//  Widget _deleteChattingRoom(var context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: <Widget>[
//         IconButton(
//             icon: Icon(Icons.delete),
//             onPressed: () {
//               try {
//                 FirebaseFirestore.instance
//                     .collection("chattingroom")
//                     .doc(copy)
//                     .collection('message')
//                     .get()
//                     .then((snapshot) {
//                   for (DocumentSnapshot ds in snapshot.docs) {
//                     ds.reference.delete();
//                   }
//                 });
//                 FirebaseFirestore.instance
//                     .collection("chattingroom")
//                     .doc(chat)
//                     .delete();

//                 Navigator.of(context).pop();
//                 print("삭제 되었습니다." + chattingRoomId);
//               } catch (e) {
//                 print(e.message);
//               }
//             }),
//       ],
//     );
//   }

class ChatScreen extends StatefulWidget {
  final String myUid;
  final String friendId;
  final String postId;

  ChatScreen(
      {Key key,
      @required this.myUid,
      @required this.friendId,
      @required this.postId})
      : super(key: key);

  @override
  _LastChatState createState() =>
      _LastChatState(myId: myUid, friendId: friendId, postId: postId);
}

class _LastChatState extends State<ChatScreen> {
  final String myId; // uid 받음
  final String friendId;
  final String postId;

  _LastChatState(
      {Key key,
      @required this.myId,
      @required this.friendId,
      @required this.postId});

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  final FocusNode focusNode = FocusNode();
  bool isDisplaySticker;
  bool isLoading;
  //add image
  File imageFile;
  String imageUrl;

  //메시지 보내기
  String chatId; //내아이디 #미사용
  String senderId; //보내는 내 아이디
  String receiveId; //받는 상대 아이디

  //SharedPreferences preferences;
  //String id; //내아이디
  var listMessage;

  //채팅방 생성 판별
  String chattingRoomId;
  bool existChattingRoom;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    focusNode.addListener(() {
      onFocusChange();
    });

    isDisplaySticker = false;
    isLoading = false;
    existChattingRoom = false;

    FirebaseFirestore.instance.collection("chattingroom").get().then((value) {
      value.docChanges.forEach((change) {
        // print(change.doc.id);
        // print(change.doc.data()['title']);
        if (myId == change.doc.data()['cusers'][0] &&
            friendId == change.doc.data()['cusers'][1] &&
            postId == change.doc.data()['postId']) {
          existChattingRoom = true;
          chattingRoomId = change.doc.id;
        }
      });

      if (existChattingRoom == true) {
        //만약 채팅방이 있으면
        setState(() {});
      } else {
        chattingRoomId = DateTime.now().millisecondsSinceEpoch.toString();
      }
    });

    chatId = "";
//    readLocal(); Local DB
  }

  // readLocal() async {
  //   preferences = await SharedPreferences.getInstance();
  //   id = preferences.getString("id").toString() ?? ""; //일단 가져온 아이디값으로 사용함
  //   //if(id.hashCode <= )
  //   print("읽은 로그인 아이디 : " + id + ' 내 아이디 ' + myId + "상대 아이디" + friendId);
  // }

  onFocusChange() {
    //print("^^^포커스체인지" + id.toString());
    if (focusNode.hasFocus) {
      //hide stickers whenever keypad appears
      setState(() {
        isDisplaySticker = false;
      });
    }
  }

  @override
  build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              //create List of Message
              //_chattingbuildList(),
              createListMessages(),
              (isDisplaySticker ? createStickers() : Container()),
              //Input Controllers
              createInput(),
            ],
          ),
          createLoding(),
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  createLoding() {
    return Positioned(
      child: isLoading ? CircularProgressIndicator() : Container(),
    );
  }

  Future<bool> onBackPress() {
    if (isDisplaySticker) {
      setState(() {
        isDisplaySticker = false;
      });
    } else {
      Navigator.pop(context);
      //print('뒤로감');
    }
    return Future.value(false);
  }

  createStickers() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => print("test@"),
                //onSendMessage("mimi1", 2),
                child: Image.asset(
                  "images/mimi1.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage("st", 2),
                padding: EdgeInsets.all(0.0),
                child: Image.asset(
                  "images/st.png",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage("mimi3", 2),
                child: Image.asset(
                  "images/mimi3.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ],
      ),
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  void getSticker() {
    focusNode.unfocus();
    setState(() {
      isDisplaySticker = !isDisplaySticker;
    });
  }

  createListMessages() {
    return Flexible(
        child: myId == ""
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              )
            : StreamBuilder(
                stream: Firestore.instance
                    .collection("chattingroom")
                    .doc(chattingRoomId)
                    .collection("message")
                    //.where("idTo", isEqualTo: myId)
                    .orderBy("timestamp", descending: true)
                    .limit(20)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    //읽어올 데이터 없으면 출력
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.yellow),
                      ),
                    );
                  } //if 종료
                  else {
                    listMessage = snapshot.data.documents;
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {
                        if (index > 0 &&
                            index < snapshot.data.documents.length - 1) //중간 문자
                          return createItem(
                              index,
                              snapshot.data.documents[index],
                              snapshot.data.documents[index + 1],
                              snapshot.data.documents.length);
                        else if (index == 0 &&
                            index != snapshot.data.documents.length - 1) //첫 문자
                          return createItem(
                              index,
                              snapshot.data.documents[index],
                              snapshot.data.documents[index + 1],
                              snapshot.data.documents.length);
                        else if (index ==
                            snapshot.data.documents.length - 1) //가장 마지막 문자
                          return createItem(
                              index,
                              snapshot.data.documents[index],
                              snapshot.data.documents[index],
                              snapshot.data.documents.length);
                      },
                      itemCount: snapshot.data.documents.length,
                      reverse: true,
                      controller: listScrollController,
                    );
                  }
                },
              ));
  }

  bool isLastMsgLeft(int index) {
    //얘는 falst 반환
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]["idFrom"] == receiveId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMsgRight(int index) {
    //얘는 트루 반환함
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]["idFrom"] != receiveId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget createItem(int index, DocumentSnapshot document,
      DocumentSnapshot datedocument, int size) {
    //My messages - Right Side
    var chatTime = DateFormat("yyyy-MM-dd").format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(document["timestamp"])));
    var nextchatTime = DateFormat("yyyy-MM-dd").format(
        DateTime.fromMillisecondsSinceEpoch(
            int.parse(datedocument["timestamp"])));
    if (document["idFrom"] == myId) {
      senderId = myId;
      receiveId = friendId;
      //내가 보냈을 경우
      return Column(
        //요기
        children: <Widget>[
          // Text("index = $index / " +
          //     document.data().length.toString() +
          //     " size : " +
          //     size.toString()),
          if (index == size - 1) Text(chatTime),
          if (chatTime != nextchatTime) Text(chatTime),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              GetTime(document),
              SizedBox(width: 5, height: 10),
              document["type"] == 0
                  //Text Msg
                  ? Container(
                      child: Text(
                        document["content"],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      width: 150.0,
                      decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(8.0)),
                      margin: EdgeInsets.only(
                          //textmargin
                          top: 10,
                          bottom: isLastMsgRight(index) ? 0.0 : 10.0,
                          right: 10.0),
                    )

                  //Image Msg
                  : document["type"] == 1
                      ? Container(
                          child: FlatButton(
                            child: Material(
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        (Colors.lightBlueAccent)),
                                  ),
                                  width: 200.0,
                                  height: 200.0,
                                  padding: EdgeInsets.all(70.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Material(
                                  child: Image.asset("images/mimi1.gif",
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                imageUrl: document["content"],
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                            onPressed: () {
                              print("pic click " +
                                  document["content"] +
                                  'index : ' +
                                  index.toString());
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FullPhoto(url: document["content"])));
                            },
                          ),
                          margin: EdgeInsets.only(
                              //image margin
                              top: 10,
                              bottom: isLastMsgRight(index) ? 0.0 : 10.0,
                              right: 0.0),
                        )

                      //Sticker . gif Msg
                      : Container(
                          child: Image.asset(
                            "images/${document['content']}.gif",
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                          margin: EdgeInsets.only(
                              bottom: isLastMsgRight(index) ? 20.0 : 10.0,
                              right: 10.0),
                        ),
              // GetTime(document), //채팅 우측 시간출력
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          )
        ],
      );
    } //if My messages - Right Side

    //Receiver Messages - Left Side
    else {
      //상대가 보냈을 경우

      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMsgLeft(index)
                    ? Material(
                        //display receiver profile image
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  (Colors.lightBlueAccent)),
                            ),
                            width: 35.0,
                            height: 35.0,
                            padding: EdgeInsets.all(10.0),
                          ),
                          imageUrl: "images/mimi1.gif",
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(
                        width: 35.0,
                      ),
                //displayMessages
                document["type"] == 0
                    //Text Msg
                    ? Container(
                        child: Text(
                          document["content"],
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w400),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 150.0,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(
                            left: 10.0, right: 10.0), //상대 텍스트 마진
                      )
                    : document["type"] == 1
                        ? Container(
                            child: FlatButton(
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          (Colors.lightBlueAccent)),
                                    ),
                                    width: 200.0,
                                    height: 200.0,
                                    padding: EdgeInsets.all(70.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Material(
                                    child: Image.asset("images/test.jpeg",
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  imageUrl: document["content"],
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FullPhoto(
                                            url: document["content"])));
                              },
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          )
                        //Sticker
                        : Container(
                            child: Image.asset(
                              "images/${document['content']}.gif",
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            margin: EdgeInsets.only(
                                bottom: isLastMsgLeft(index) ? 20.0 : 10.0,
                                right: 10.0),
                          ),
                GetTime(document),
              ],
            ),

            //Msg time 하단이라 지움
/*
            isLastMsgLeft(index)
                ? Container(
                    child: GetTime(document), //채팅 우측 시간출력
                    margin: EdgeInsets.only(left: 50.0, top: 50.0, bottom: 5.0),
                  )
                : Container(
                    child: Text(' 텍스트?'),
                  )
                  */
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    } //else 상대방 Receiver Messages - Left Side
  }

  createInput() {
    return Container(
      child: Row(
        children: <Widget>[
          //pick image icon button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                color: Colors.lightBlueAccent,
                onPressed: getImage, //getImageFromGallery,
              ),
            ),
            color: Colors.white,
          ),

          //emoji icon button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                color: Colors.lightBlueAccent,
                onPressed: getSticker, //getImageFromGallery,
              ),
            ),
            color: Colors.white,
          ),

          //Text Field
          Flexible(
            child: TextField(
              style: TextStyle(color: Colors.black, fontSize: 15.0),
              controller: textEditingController,
              decoration: InputDecoration.collapsed(
                  hintText: "Write here...,",
                  hintStyle: TextStyle(color: Colors.grey)),
              focusNode: focusNode,
            ),
          ),

          //Send Message Icon Button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.lightBlueAccent,
                  onPressed: () {
                    print("# myid $myId / fid $friendId");
                    if (existChattingRoom == false) {
                      //방 만들어진 적이 없으면
                      FirebaseChatController()
                          .createProductChatingRoomToFirebaseStorage(
                              postId, chattingRoomId);
                      existChattingRoom = true;
                    }

                    onSendMessage(textEditingController.text, 0);
                  }),
              color: Colors.white,
            ),
          ),
        ],
      ),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
          color: Colors.grey,
          width: 0.5,
        )),
        color: Colors.white,
      ),
    );
  }

  void onSendMessage(String contentMsg, int type) {
    //type = 0 its text msg
    //type = 1 its imageFile
    //type = 2 its sticker image
    if (contentMsg != "") {
      textEditingController.clear();

      //기존
      var docRef2 = Firestore.instance
          .collection("chattinglist")
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      var docRef = Firestore.instance
          .collection("chattingroom")
          .doc(chattingRoomId) //채팅룸 입력
          .collection("message")
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(docRef, {
          "idFrom": myId,
          "idTo": friendId,
          "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
          "content": contentMsg,
          "type": type,
        });
      });
      listScrollController.animateTo(0.0,
          duration: Duration(microseconds: 300), curve: Curves.easeOut);
    } //if
    else {
      Fluttertoast.showToast(msg: 'Empty Message. Can not be send.');
    }
  }

  Future getImage() async {
    // ignore: deprecated_member_use

    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      isLoading = true;
    }
    uploadImageFile();
    print('업로드 실행');
  }

  Future uploadImageFile() async {
    print('업로드 호출');

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("chat Images").child(fileName);

    StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;

    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (error) {
      setState(() {
        isLoading = false;
      });
      print('에러' + error);
      //Fluttertoast.showToast(msg: "Error: ", error);
    });
  }
}
