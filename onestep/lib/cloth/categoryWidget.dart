import 'package:flutter/material.dart';
import 'package:onestep/cloth/models/category.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatefulWidget {
  CategoryWidget({Key key}) : super(key: key);

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  List<String> list;
  @override
  void initState() {
    super.initState();
    list = Provider.of<Category>(context, listen: false).getCategoryItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("카테고리"),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            // leading: Icon(Icons.person),
            title: Text(list[index]),
            // subtitle: Text("${_person.age}세"),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
          );
        },
      ),
    );
  }
}
