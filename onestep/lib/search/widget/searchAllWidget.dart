import 'package:flutter/material.dart';
import 'package:moor/moor.dart' as mf;
import 'package:onestep/cloth/clothitem.dart';
import 'package:onestep/moor/moor_database.dart';
import 'package:onestep/search/provider/searchProvider.dart';
import 'package:provider/provider.dart';

class SearchAllWidget extends StatefulWidget {
  final SearchProvider searchProvider;

  const SearchAllWidget({Key key, this.searchProvider}) : super(key: key);
  @override
  _SearchAllWidgetState createState() => _SearchAllWidgetState();
}

class _SearchAllWidgetState extends State<SearchAllWidget> {
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
      child: StreamBuilder<List<mf.QueryRow>>(
        stream: p.watchSearchs(),
        builder:
            (BuildContext context, AsyncSnapshot<List<mf.QueryRow>> snapshot) {
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
                        child: Text("${snapshot.data[index].data['title']}",
                            style: TextStyle(), textAlign: TextAlign.center),
                      ),
                    ),
                    onTap: () {
                      print("searchClick");
                      String text = snapshot.data[index].data['title'];
                      FocusScope.of(context).unfocus();

                      widget.searchProvider.searchProducts(text);

                      setState(() {
                        _isSearchMode = false;
                        _textController.text = text;
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

  Widget getTab() {
    return TabBar(
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
    );
  }

  Widget renderProductBody() {
    var _size = MediaQuery.of(context).size;
    final double _itemHeight = (_size.height - kToolbarHeight - 24) / 2.0;
    final double _itemWidth = _size.width / 2;

    return GridView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: _itemWidth > _itemHeight
            ? (_itemHeight / _itemWidth)
            : (_itemWidth / _itemHeight),
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      children: [
        ...widget.searchProvider.products
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
                      if (text.trim().length >= 2) {
                        widget.searchProvider.searchProducts(text);
                        // "board 검색";

                        search = Search(title: text, time: DateTime.now());
                        p
                            .customSelect(
                                "SELECT * FROM Searchs WHERE title LIKE '$text'")
                            .getSingle()
                            .then((value) => {
                                  if (value != null)
                                    {
                                      p.updateSearch(Search.fromJson(value.data)
                                          .copyWith(
                                              time:
                                                  DateTime.now())), // 시간 update
                                    }
                                  else
                                    {
                                      p.insertSearch(search),
                                    }
                                });

                        setState(() {
                          _isSearchMode = false;
                          // _isAutoFocus = false;
                        });
                      } else {
                        print("두 글자 이상 입력해주세요. 팝업");
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
                        hintText: "상품이나 게시글을 검색해보세요."),
                  ),
                ),
              ),
            ],
          ),
          bottom: _isSearchMode == false ? getTab() : null,
        ),
        body: _isSearchMode == false
            ? TabBarView(
                children: [
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      renderProductBody(),
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
