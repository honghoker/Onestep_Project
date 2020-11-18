import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

GoogleSignInDemoState pageState;

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
]);

class GoogleSignInDemo2 extends StatefulWidget {
  @override
  GoogleSignInDemoState createState() {
    pageState = GoogleSignInDemoState();
    return pageState;
  }
}

class GoogleSignInDemoState extends State<GoogleSignInDemo2> {
  GoogleSignInAccount _currentUser;
  String _contactText;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
        print('사용자인증1' + _currentUser.toString());
      });
      if (_currentUser != null) {
        _handleGetContact();
        print('사용자인증2' + _currentUser.toString());
      }
      _googleSignIn.signInSilently();
      print('구글로그인 성공 후 작동?');
    });
  }

  Future<void> _handleGetContact() async {
    setState(() {
      _contactText = "Loading contact info...";
    });
    final http.Response response = await http.get(
        'https://people.googleapis.com/v1/people/me/connections'
        '?requestMask.includeField=person.names',
        headers: await _currentUser.authHeaders);

    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for detailes.";
      });
      print("People API ${response.statusCode} response: ${response.body}");
      return;
    }

    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }

//구글 영어 이름 전환인데 필요없는듯
  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("2. 구글로그인 단계")),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }

  Widget _buildBody() {
    if (_currentUser != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: _currentUser,
            ),
            title: Text(_currentUser.displayName ?? ""),
            subtitle: Text(_currentUser.email ?? ""),
          ),
          const Text("Signed in successfully."),
          Text(_contactText ?? ""),
          RaisedButton(
            child: const Text("SIGN OUT"),
            onPressed: _handleSignOut,
          ),
          RaisedButton(
            child: const Text("REFRESH"),
            onPressed: _handleGetContact,
          )
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("You are not currently signed in 로그인 안했을 때 화면임0"),
          RaisedButton(
            child: const Text("SIGN INs"),
            onPressed: _handleSignIn,
          )
        ],
      );
    }
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      print('사용자인증0 로그인 로그아웃과정?' + _currentUser.toString());
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
  }
}
