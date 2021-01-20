import 'package:flutter/material.dart';
import 'package:onestep/api/firebase_api.dart';

class FavoriteAnimation {
  void showFavoriteDialog(BuildContext context) {
    Future.delayed(Duration(milliseconds: 300), () {
      Navigator.pop(context);
    });
    showDialog(
      context: context,
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: Icon(Icons.favorite, color: Colors.pink, size: 200),
        // ),
      ),
    );
  }

  void incdecProductFavorites(bool chk, BuildContext context, String uid) {
    if (chk) showFavoriteDialog(context);
    FirebaseApi().incdecProductFavorites(chk, uid);
  }
}
