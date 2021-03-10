import 'package:flutter/widgets.dart';

class Product {
  final String title;
  final String firestoreid;
  final String uid;
  final String category;
  final String price;
  final String explain;
  final int views;
  final List<dynamic> favoriteuserlist;
  final DateTime uploadtime;
  final DateTime updatetime;
  final DateTime bumptime;

  final List<dynamic> images;
  final bool hide;
  final bool deleted;

  Product(
      {@required this.title,
      @required this.firestoreid,
      @required this.uid,
      @required this.category,
      @required this.price,
      this.explain,
      this.views,
      this.favoriteuserlist,
      this.uploadtime,
      this.updatetime,
      this.bumptime,
      @required this.images,
      this.hide,
      this.deleted});

  factory Product.fromJson(Map<String, dynamic> json, String id) {
    return Product(
      title: json['title'],
      firestoreid: id,
      uid: json['uid'],
      category: json['category'],
      price: json['price'],
      explain: json['explain'],
      views: json['vies'],
      updatetime: json['updatetime'].toDate(),
      uploadtime: json['uploadtime'].toDate(),
      bumptime: json['bumptime'].toDate(),
      favoriteuserlist: json['favoriteuserlist'],
      images: json['images'],
      hide: json['hide'],
      deleted: json['deleted'],
    );

    // firestoreid: id,
    // uid: serializer.fromJson<String>(json['uid']),
    // category: serializer.fromJson<String>(json['category']),
    // price: serializer.fromJson<String>(json['price']),
    // explain: serializer.fromJson<String>(json['explain']),
    // views: serializer.fromJson<int>(json['views']),
    // favorites: serializer.fromJson<int>(json['favorites']),
    // uploadtime: json['uploadtime'] == null
    //     ? null
    //     : DateTime.fromMillisecondsSinceEpoch(
    //         json['uploadtime'].millisecondsSinceEpoch),
    // updatetime: json['updatetime'] == null
    //     ? null
    //     : DateTime.fromMillisecondsSinceEpoch(
    //         json['updatetime'].millisecondsSinceEpoch),
    // bumptime: json['bumptime'] == null
    //     ? null
    //     : json['bumptime'] is int
    //         ? DateTime(json['bumptime'])
    //         : DateTime.fromMillisecondsSinceEpoch(
    //             json['bumptime'].millisecondsSinceEpoch),
    // favoritetime: json['favoritetime'] == null
    //     ? null
    //     : DateTime.fromMillisecondsSinceEpoch(json['favoritetime']),
    // // images: serializer.fromJson<String>(json['images'].toString()),
    // images: json['images'].toString(),
    // hide: json['hide'] is int
    //     ? json['hide']
    //     : json['hide']
    //         ? 1
    //         : 0,
    // deleted: json['deleted'] is int
    //     ? json['deleted']
    //     : json['deleted']
    //         ? 1
    //         : 0
  }
}
