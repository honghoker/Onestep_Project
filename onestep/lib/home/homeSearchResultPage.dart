import 'package:flutter/material.dart';
import 'package:onestep/moor/moor_database.dart';
import 'package:provider/provider.dart';

class HomeSearchResultPage extends StatefulWidget {
  @override
  _HomeSearchResultPageState createState() => _HomeSearchResultPageState();
}

class _HomeSearchResultPageState extends State<HomeSearchResultPage> {
  String tempSearchValue = "";
  TextEditingController _textController;
  bool _isSearchMode = true;
  bool _isAutoFocus = true;
  Search search;

  FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: tempSearchValue);
    _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length));

    myFocusNode = FocusNode();
  }

  Widget searchBody() {
    SearchsDao p = Provider.of<AppDatabase>(context).searchsDao;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder<List<Search>>(
        stream: p.watchSearchs(),
        builder: (BuildContext context, AsyncSnapshot<List<Search>> snapshot) {
          if (snapshot.data == null) return new Text(""); // 이거 안넣어주면 오류남
          SizedBox(
            height: 5,
          );
          return SizedBox(
            height: 50,
            child: ListView.builder(
              itemCount: snapshot.data.length,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 5,
                        bottom: 5,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                            "${snapshot.data[snapshot.data.length - (index + 1)].title}",
                            style: TextStyle(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    onTap: () {
                      print("searchClick");
                      setState(() {
                        _isSearchMode = false;
                        _textController.text = snapshot
                            .data[snapshot.data.length - (index + 1)].title;
                      });
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final TextEditingController _textController = TextEditingController(text: tempSearchValue);
    SearchsDao p = Provider.of<AppDatabase>(context).searchsDao;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Row(
            children: [
              // Flexible : overFlowd pixels -> 화면 크기 넘어가는거 막아줌
              Flexible(
                child: Container(
                  width: 300,
                  height: 50,
                  child: TextField(
                    onTap: () {
                      print("textOnTap");
                      setState(() {
                        _isSearchMode = true;
                        // _isAutoFocus = true;
                      });
                    },
                    // focusNode: myFocusNode,
                    autofocus: _isSearchMode == true ? true : false,
                    controller: _textController,
                    onSubmitted: (text) {
                      // 2글자 제한
                      if (text.length > 2) {
                        print("2글자 초과");
                      } else if (text == "") {
                        print("공백");
                      } else {
                        print("search $text");
                        search = Search(title: text, id: null);
                        setState(() {
                          _isSearchMode = false;
                          // p.insertSearch(search);
                          text != "" ? p.insertSearch(search) : null;
                          // _isAutoFocus = false;
                        });
                      }
                    },
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
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    child: Text("취소", style: TextStyle(fontSize: 15)),
                  ),
                ),
              )
            ],
          ),
          bottom: _isSearchMode == false
              ? TabBar(
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
                )
              : null,
        ),
        body: _isSearchMode == false
            ? TabBarView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("장터", style: TextStyle(color: Colors.black)),
                      Text("${_textController.text}"),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "게시판",
                        style: TextStyle(color: Colors.black),
                      ),
                      Text("${_textController.text}"),
                    ],
                  ),
                ],
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text("최근 검색어"),
                        ),
                        GestureDetector(
                          onTap: () {
                            Provider.of<AppDatabase>(context, listen: false)
                                .searchsDao
                                .deleteAllSearch();
                            setState(() {
                              _textController.clear();
                            });
                          },
                          child: Container(
                            child: Text("모두 삭제"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  searchBody(),
                ],
              ),
      ),
    );
  }
}
