import 'package:flutter/material.dart';
import 'package:onestep/cloth/providers/productSearchProvider.dart';
import 'package:onestep/moor/moor_database.dart';
import 'package:provider/provider.dart';

import 'clothitem.dart';

class ClothSearchResultPage extends StatefulWidget {
  final ProuductSearchProvider prouductSearchProvider;

  const ClothSearchResultPage({
    Key key,
    this.prouductSearchProvider,
  }) : super(key: key);
  @override
  _ClothSearchResultPageState createState() => _ClothSearchResultPageState();
}

class _ClothSearchResultPageState extends State<ClothSearchResultPage> {
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
                      FocusScope.of(context).unfocus();
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

  Widget appbar() {
    SearchsDao p = Provider.of<AppDatabase>(context).searchsDao;
    return AppBar(
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
                  if (text.trim().length >= 2) {
                    print(text);
                    widget.prouductSearchProvider.searchProducts(text);
                    search = Search(title: text, id: null);
                    setState(() {
                      _isSearchMode = false;
                      if (text.trim().toString() != "") p.insertSearch(search);
                      // _isAutoFocus = false;
                    });
                  } else {
                    print("2글자 미만 제한 예외처리");
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
    );
  }

  Widget renderBody(double itemWidth, double itemHeight) {
    return GridView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: itemWidth > itemHeight
            ? (itemHeight / itemWidth)
            : (itemWidth / itemHeight),
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      children: [
        ...widget.prouductSearchProvider.products
            .map(
              (product) => ClothItem(
                product: product,
              ),
            )
            .toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // final TextEditingController _textController = TextEditingController(text: tempSearchValue);
    var _size = MediaQuery.of(context).size;
    final double _itemHeight = (_size.height - kToolbarHeight - 24) / 2.0;
    final double _itemWidth = _size.width / 2;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appbar(),
        body: _isSearchMode == false
            ? renderBody(_itemWidth, _itemHeight)
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
