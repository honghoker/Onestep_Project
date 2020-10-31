import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

Future<void> Test() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  GoogleSignInAccount account = await googleSignIn.signIn();
  GoogleSignInAuthentication authentication = await account.authentication;
  AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: authentication.idToken, accessToken: authentication.accessToken);
  //AuthResult authResult = await auth.signInWithCredential(credential);
  //FirebaseUser user = authResult.user;
}
