import 'package:flutter/material.dart';

class HomeSearchResultPage extends StatefulWidget {
  @override
  _HomeSearchResultPageState createState() => _HomeSearchResultPageState();
}

class _HomeSearchResultPageState extends State<HomeSearchResultPage> {
  String tempSearchValue = "";
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: tempSearchValue);
    _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length));
  }

  @override
  Widget build(BuildContext context) {
    // final TextEditingController _textController = TextEditingController(text: tempSearchValue);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Container(
            width: 300,
            height: 50,
            child: TextField(
              // autofocus: true,
              // focusNode: FocusNode(canRequestFocus: true),
              // key: UniqueKey(),
              controller: _textController,

              onChanged: (text) {
                setState(() {
                  tempSearchValue = text;
                });
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Icon(Icons.search),
                  ),
                  // icon: Icon(Icons.search),
                  suffixIcon: _textController.text != ""
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _textController.clear();
                            });
                          },
                        )
                      : null,
                  hintText: "장터나 게시판을 검색해보세요!"),
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  "장터",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  "게시판",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
                child: Text(
              "장터",
              style: TextStyle(color: Colors.black),
            )),
            Center(
                child: Text(
              "게시판",
              style: TextStyle(color: Colors.black),
            )),
          ],
        ),
      ),
    );
  }
}
