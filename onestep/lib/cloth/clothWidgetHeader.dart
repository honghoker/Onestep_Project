import 'package:flutter/material.dart';
import 'package:onestep/cloth/clothCategoryWidget.dart';
import 'package:onestep/cloth/models/categoryItem.dart';
import 'package:onestep/cloth/providers/categoryProductProvider.dart';
import 'package:provider/provider.dart';

import 'models/category.dart';

class ClothWidgetHeader extends StatefulWidget {
  final Category category;
  ClothWidgetHeader({Key key, this.category}) : super(key: key);

  @override
  _ClothWidgetHeaderState createState() => _ClothWidgetHeaderState();
}

class _ClothWidgetHeaderState extends State<ClothWidgetHeader> {
  bool categoryBool = false;

  Widget all() {
    return GridView(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1.0,
        crossAxisSpacing: 1.0,
      ),
      shrinkWrap: true,
      children: [
        ...CategoryItem.items
            .map(
              (item) => InkWell(
                splashColor: Colors.red,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Consumer<CategoryProuductProvider>(
                        builder: (context, prouductProvider, _) =>
                            ClothCategoryWidget(
                          productProvider: prouductProvider,
                          category: item.name,
                        ),
                      ),
                    ),
                  );
                },
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                        child: Image(image: item.image, width: 45, height: 45)),
                    Text(item.name, style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  Widget header() {
    return GridView(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1.0,
        crossAxisSpacing: 1.0,
      ),
      shrinkWrap: true,
      children: [
        ...CategoryItem.headeritems
            .map(
              (item) => InkWell(
                splashColor: Colors.red,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Consumer<CategoryProuductProvider>(
                        builder: (context, prouductProvider, _) =>
                            ClothCategoryWidget(
                          productProvider: prouductProvider,
                          category: item.name,
                        ),
                      ),
                    ),
                  );
                },
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                        child: Image(image: item.image, width: 45, height: 45)),
                    Text(item.name, style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            )
            .toList(),
        GestureDetector(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 5.0),
                  child: Icon(Icons.add, size: 45)),
              Text("더보기", style: TextStyle(fontSize: 12)),
            ],
          ),
          onTap: () {
            setState(() {
              categoryBool = !categoryBool;
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        categoryBool ? all() : header(),
      ],
    );
  }
}
