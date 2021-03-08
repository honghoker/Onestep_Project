import 'package:cloud_firestore/cloud_firestore.dart';

class LoginController {
  static LoginController get instanace => LoginController();

  Future<void> saveUserInfoToFirebaseStorage(
      userUid, userName, timeStamp) async {
    // userImageFile,
    try {
      FirebaseFirestore.instance.collection("users").doc(userUid).set({
        "id": userUid,
        "nickname": userName,
        "boardChatCount": 0,
        "productChatCount": 0,
        "photoUrl": "",
        "authUniversity": "",
        "userLevel": 1, // 0: BAN / 1: GUEST / 2:AUTHENTIFICATION USER
        "userScore": 100, //장터 평가, 유저 신고 점수 , 100 이하일 경우 불량 유저
        "userUniversity": "", //universityID
        "userUniversityEmail": "", //학교인증 이메일
        "userEmail": "", //User Email
        "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
      });
    } catch (e) {
      print(e.message);
    }
  }
}
