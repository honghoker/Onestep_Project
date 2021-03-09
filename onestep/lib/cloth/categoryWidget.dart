import 'package:flutter/material.dart';
import 'package:onestep/cloth/models/category.dart';
import 'package:provider/provider.dart';

import 'models/categoryItem.dart';

class CategoryWidget extends StatefulWidget {
  CategoryWidget({Key key}) : super(key: key);

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("카테고리"),
      ),
      body: ListView.builder(
        itemCount: CategoryItem.items.length,
        itemBuilder: (BuildContext context, int index) {
          // list[index];
          return ListTile(
            leading: Image(
                image: CategoryItem.items[index].image, width: 30, height: 30),

            title: Text(CategoryItem.items[index].name),
            // subtitle: Text("${_person.age}세"),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              print(CategoryItem.items[index]);
              Navigator.pop(context, CategoryItem.items[index].name);
            },
          );
        },
      ),
    );
  }
}
