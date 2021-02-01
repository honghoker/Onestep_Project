// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Product extends DataClass implements Insertable<Product> {
  final String title;
  final String firestoreid;
  final String uid;
  final String category;
  final String price;
  final String explain;
  final int views;
  final int favorites;
  final DateTime uploadtime;
  final DateTime updatetime;
  final DateTime bumptime;
  DateTime favoritetime;
  final String images;
  final int hide;
  final int deleted;
  Product(
      {@required this.title,
      @required this.firestoreid,
      @required this.uid,
      @required this.category,
      @required this.price,
      this.explain,
      this.views,
      this.favorites,
      this.uploadtime,
      this.updatetime,
      this.bumptime,
      this.favoritetime,
      @required this.images,
      @required this.hide,
      @required this.deleted});
  factory Product.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Product(
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      firestoreid: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}firestoreid']),
      uid: stringType.mapFromDatabaseResponse(data['${effectivePrefix}uid']),
      category: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}category']),
      price:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}price']),
      explain:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}explain']),
      views: intType.mapFromDatabaseResponse(data['${effectivePrefix}views']),
      favorites:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}favorites']),
      uploadtime: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}uploadtime']),
      updatetime: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updatetime']),
      bumptime: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}bumptime']),
      favoritetime: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}favoritetime']),
      images:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}images']),
      hide: intType.mapFromDatabaseResponse(data['${effectivePrefix}hide']),
      deleted:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}deleted']),
    );
  }

  void setFavoriteTime(DateTime time) {
    this.favoritetime = time;
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || firestoreid != null) {
      map['firestoreid'] = Variable<String>(firestoreid);
    }
    if (!nullToAbsent || uid != null) {
      map['uid'] = Variable<String>(uid);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<String>(price);
    }
    if (!nullToAbsent || explain != null) {
      map['explain'] = Variable<String>(explain);
    }
    if (!nullToAbsent || views != null) {
      map['views'] = Variable<int>(views);
    }
    if (!nullToAbsent || favorites != null) {
      map['favorites'] = Variable<int>(favorites);
    }
    if (!nullToAbsent || uploadtime != null) {
      map['uploadtime'] = Variable<DateTime>(uploadtime);
    }
    if (!nullToAbsent || updatetime != null) {
      map['updatetime'] = Variable<DateTime>(updatetime);
    }
    if (!nullToAbsent || bumptime != null) {
      map['bumptime'] = Variable<DateTime>(bumptime);
    }
    if (!nullToAbsent || favoritetime != null) {
      map['favoritetime'] = Variable<DateTime>(favoritetime);
    }
    if (!nullToAbsent || images != null) {
      map['images'] = Variable<String>(images);
    }
    if (!nullToAbsent || hide != null) {
      map['hide'] = Variable<int>(hide);
    }
    if (!nullToAbsent || deleted != null) {
      map['deleted'] = Variable<int>(deleted);
    }
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      firestoreid: firestoreid == null && nullToAbsent
          ? const Value.absent()
          : Value(firestoreid),
      uid: uid == null && nullToAbsent ? const Value.absent() : Value(uid),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      price:
          price == null && nullToAbsent ? const Value.absent() : Value(price),
      explain: explain == null && nullToAbsent
          ? const Value.absent()
          : Value(explain),
      views:
          views == null && nullToAbsent ? const Value.absent() : Value(views),
      favorites: favorites == null && nullToAbsent
          ? const Value.absent()
          : Value(favorites),
      uploadtime: uploadtime == null && nullToAbsent
          ? const Value.absent()
          : Value(uploadtime),
      updatetime: updatetime == null && nullToAbsent
          ? const Value.absent()
          : Value(updatetime),
      bumptime: bumptime == null && nullToAbsent
          ? const Value.absent()
          : Value(bumptime),
      favoritetime: favoritetime == null && nullToAbsent
          ? const Value.absent()
          : Value(favoritetime),
      images:
          images == null && nullToAbsent ? const Value.absent() : Value(images),
      hide: hide == null && nullToAbsent ? const Value.absent() : Value(hide),
      deleted: deleted == null && nullToAbsent
          ? const Value.absent()
          : Value(deleted),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json, String id,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Product(
      title: serializer.fromJson<String>(json['title']),
      firestoreid: id,
      uid: serializer.fromJson<String>(json['uid']),
      category: serializer.fromJson<String>(json['category']),
      price: serializer.fromJson<String>(json['price']),
      explain: serializer.fromJson<String>(json['explain']),
      views: serializer.fromJson<int>(json['views']),
      favorites: serializer.fromJson<int>(json['favorites']),
      uploadtime: json['uploadtime'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
              json['uploadtime'].millisecondsSinceEpoch),
      updatetime: json['updatetime'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
              json['updatetime'].millisecondsSinceEpoch),
      bumptime: json['bumptime'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
              json['bumptime'].millisecondsSinceEpoch),
      favoritetime: json['favoritetime'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['favoritetime']),
      images: serializer.fromJson<String>(json['images'].toString()),
      hide: json['hide'] is int
          ? json['hide']
          : json['hide']
              ? 1
              : 0,
      deleted: json['deleted'] is int
          ? json['deleted']
          : json['deleted']
              ? 1
              : 0,
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'title': serializer.toJson<String>(title),
      'firestoreid': serializer.toJson<String>(firestoreid),
      'uid': serializer.toJson<String>(uid),
      'category': serializer.toJson<String>(category),
      'price': serializer.toJson<String>(price),
      'explain': serializer.toJson<String>(explain),
      'views': serializer.toJson<int>(views),
      'favorites': serializer.toJson<int>(favorites),
      'uploadtime': serializer.toJson<DateTime>(uploadtime),
      'updatetime': serializer.toJson<DateTime>(updatetime),
      'bumptime': serializer.toJson<DateTime>(bumptime),
      'favoritetime': serializer.toJson<DateTime>(favoritetime),
      'images': serializer.toJson<String>(images),
      'hide': serializer.toJson<int>(hide),
      'deleted': serializer.toJson<int>(deleted),
    };
  }

  Product copyWith(
          {String title,
          String firestoreid,
          String uid,
          String category,
          String price,
          String explain,
          int views,
          int favorites,
          DateTime uploadtime,
          DateTime updatetime,
          DateTime bumptime,
          DateTime favoritetime,
          String images,
          int hide,
          int deleted}) =>
      Product(
        title: title ?? this.title,
        firestoreid: firestoreid ?? this.firestoreid,
        uid: uid ?? this.uid,
        category: category ?? this.category,
        price: price ?? this.price,
        explain: explain ?? this.explain,
        views: views ?? this.views,
        favorites: favorites ?? this.favorites,
        uploadtime: uploadtime ?? this.uploadtime,
        updatetime: updatetime ?? this.updatetime,
        bumptime: bumptime ?? this.bumptime,
        favoritetime: favoritetime ?? this.favoritetime,
        images: images ?? this.images,
        hide: hide ?? this.hide,
        deleted: deleted ?? this.deleted,
      );
  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('title: $title, ')
          ..write('firestoreid: $firestoreid, ')
          ..write('uid: $uid, ')
          ..write('category: $category, ')
          ..write('price: $price, ')
          ..write('explain: $explain, ')
          ..write('views: $views, ')
          ..write('favorites: $favorites, ')
          ..write('uploadtime: $uploadtime, ')
          ..write('updatetime: $updatetime, ')
          ..write('bumptime: $bumptime, ')
          ..write('favoritetime: $favoritetime, ')
          ..write('images: $images, ')
          ..write('hide: $hide, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      title.hashCode,
      $mrjc(
          firestoreid.hashCode,
          $mrjc(
              uid.hashCode,
              $mrjc(
                  category.hashCode,
                  $mrjc(
                      price.hashCode,
                      $mrjc(
                          explain.hashCode,
                          $mrjc(
                              views.hashCode,
                              $mrjc(
                                  favorites.hashCode,
                                  $mrjc(
                                      uploadtime.hashCode,
                                      $mrjc(
                                          updatetime.hashCode,
                                          $mrjc(
                                              bumptime.hashCode,
                                              $mrjc(
                                                  favoritetime.hashCode,
                                                  $mrjc(
                                                      images.hashCode,
                                                      $mrjc(
                                                          hide.hashCode,
                                                          deleted
                                                              .hashCode)))))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Product &&
          other.title == this.title &&
          other.firestoreid == this.firestoreid &&
          other.uid == this.uid &&
          other.category == this.category &&
          other.price == this.price &&
          other.explain == this.explain &&
          other.views == this.views &&
          other.favorites == this.favorites &&
          other.uploadtime == this.uploadtime &&
          other.updatetime == this.updatetime &&
          other.bumptime == this.bumptime &&
          other.favoritetime == this.favoritetime &&
          other.images == this.images &&
          other.hide == this.hide &&
          other.deleted == this.deleted);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> title;
  final Value<String> firestoreid;
  final Value<String> uid;
  final Value<String> category;
  final Value<String> price;
  final Value<String> explain;
  final Value<int> views;
  final Value<int> favorites;
  final Value<DateTime> uploadtime;
  final Value<DateTime> updatetime;
  final Value<DateTime> bumptime;
  final Value<DateTime> favoritetime;
  final Value<String> images;
  final Value<int> hide;
  final Value<int> deleted;
  const ProductsCompanion({
    this.title = const Value.absent(),
    this.firestoreid = const Value.absent(),
    this.uid = const Value.absent(),
    this.category = const Value.absent(),
    this.price = const Value.absent(),
    this.explain = const Value.absent(),
    this.views = const Value.absent(),
    this.favorites = const Value.absent(),
    this.uploadtime = const Value.absent(),
    this.updatetime = const Value.absent(),
    this.bumptime = const Value.absent(),
    this.favoritetime = const Value.absent(),
    this.images = const Value.absent(),
    this.hide = const Value.absent(),
    this.deleted = const Value.absent(),
  });
  ProductsCompanion.insert({
    @required String title,
    @required String firestoreid,
    @required String uid,
    @required String category,
    @required String price,
    this.explain = const Value.absent(),
    this.views = const Value.absent(),
    this.favorites = const Value.absent(),
    this.uploadtime = const Value.absent(),
    this.updatetime = const Value.absent(),
    this.bumptime = const Value.absent(),
    this.favoritetime = const Value.absent(),
    @required String images,
    @required int hide,
    @required int deleted,
  })  : title = Value(title),
        firestoreid = Value(firestoreid),
        uid = Value(uid),
        category = Value(category),
        price = Value(price),
        images = Value(images),
        hide = Value(hide),
        deleted = Value(deleted);
  static Insertable<Product> custom({
    Expression<String> title,
    Expression<String> firestoreid,
    Expression<String> uid,
    Expression<String> category,
    Expression<String> price,
    Expression<String> explain,
    Expression<int> views,
    Expression<int> favorites,
    Expression<DateTime> uploadtime,
    Expression<DateTime> updatetime,
    Expression<DateTime> bumptime,
    Expression<DateTime> favoritetime,
    Expression<String> images,
    Expression<int> hide,
    Expression<int> deleted,
  }) {
    return RawValuesInsertable({
      if (title != null) 'title': title,
      if (firestoreid != null) 'firestoreid': firestoreid,
      if (uid != null) 'uid': uid,
      if (category != null) 'category': category,
      if (price != null) 'price': price,
      if (explain != null) 'explain': explain,
      if (views != null) 'views': views,
      if (favorites != null) 'favorites': favorites,
      if (uploadtime != null) 'uploadtime': uploadtime,
      if (updatetime != null) 'updatetime': updatetime,
      if (bumptime != null) 'bumptime': bumptime,
      if (favoritetime != null) 'favoritetime': favoritetime,
      if (images != null) 'images': images,
      if (hide != null) 'hide': hide,
      if (deleted != null) 'deleted': deleted,
    });
  }

  ProductsCompanion copyWith(
      {Value<String> title,
      Value<String> firestoreid,
      Value<String> uid,
      Value<String> category,
      Value<String> price,
      Value<String> explain,
      Value<int> views,
      Value<int> favorites,
      Value<DateTime> uploadtime,
      Value<DateTime> updatetime,
      Value<DateTime> bumptime,
      Value<DateTime> favoritetime,
      Value<String> images,
      Value<int> hide,
      Value<int> deleted}) {
    return ProductsCompanion(
      title: title ?? this.title,
      firestoreid: firestoreid ?? this.firestoreid,
      uid: uid ?? this.uid,
      category: category ?? this.category,
      price: price ?? this.price,
      explain: explain ?? this.explain,
      views: views ?? this.views,
      favorites: favorites ?? this.favorites,
      uploadtime: uploadtime ?? this.uploadtime,
      updatetime: updatetime ?? this.updatetime,
      bumptime: bumptime ?? this.bumptime,
      favoritetime: favoritetime ?? this.favoritetime,
      images: images ?? this.images,
      hide: hide ?? this.hide,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (firestoreid.present) {
      map['firestoreid'] = Variable<String>(firestoreid.value);
    }
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (price.present) {
      map['price'] = Variable<String>(price.value);
    }
    if (explain.present) {
      map['explain'] = Variable<String>(explain.value);
    }
    if (views.present) {
      map['views'] = Variable<int>(views.value);
    }
    if (favorites.present) {
      map['favorites'] = Variable<int>(favorites.value);
    }
    if (uploadtime.present) {
      map['uploadtime'] = Variable<DateTime>(uploadtime.value);
    }
    if (updatetime.present) {
      map['updatetime'] = Variable<DateTime>(updatetime.value);
    }
    if (bumptime.present) {
      map['bumptime'] = Variable<DateTime>(bumptime.value);
    }
    if (favoritetime.present) {
      map['favoritetime'] = Variable<DateTime>(favoritetime.value);
    }
    if (images.present) {
      map['images'] = Variable<String>(images.value);
    }
    if (hide.present) {
      map['hide'] = Variable<int>(hide.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<int>(deleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('title: $title, ')
          ..write('firestoreid: $firestoreid, ')
          ..write('uid: $uid, ')
          ..write('category: $category, ')
          ..write('price: $price, ')
          ..write('explain: $explain, ')
          ..write('views: $views, ')
          ..write('favorites: $favorites, ')
          ..write('uploadtime: $uploadtime, ')
          ..write('updatetime: $updatetime, ')
          ..write('bumptime: $bumptime, ')
          ..write('favoritetime: $favoritetime, ')
          ..write('images: $images, ')
          ..write('hide: $hide, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  final GeneratedDatabase _db;
  final String _alias;
  $ProductsTable(this._db, [this._alias]);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  final VerificationMeta _firestoreidMeta =
      const VerificationMeta('firestoreid');
  GeneratedTextColumn _firestoreid;
  @override
  GeneratedTextColumn get firestoreid =>
      _firestoreid ??= _constructFirestoreid();
  GeneratedTextColumn _constructFirestoreid() {
    return GeneratedTextColumn(
      'firestoreid',
      $tableName,
      false,
    );
  }

  final VerificationMeta _uidMeta = const VerificationMeta('uid');
  GeneratedTextColumn _uid;
  @override
  GeneratedTextColumn get uid => _uid ??= _constructUid();
  GeneratedTextColumn _constructUid() {
    return GeneratedTextColumn(
      'uid',
      $tableName,
      false,
    );
  }

  final VerificationMeta _categoryMeta = const VerificationMeta('category');
  GeneratedTextColumn _category;
  @override
  GeneratedTextColumn get category => _category ??= _constructCategory();
  GeneratedTextColumn _constructCategory() {
    return GeneratedTextColumn(
      'category',
      $tableName,
      false,
    );
  }

  final VerificationMeta _priceMeta = const VerificationMeta('price');
  GeneratedTextColumn _price;
  @override
  GeneratedTextColumn get price => _price ??= _constructPrice();
  GeneratedTextColumn _constructPrice() {
    return GeneratedTextColumn(
      'price',
      $tableName,
      false,
    );
  }

  final VerificationMeta _explainMeta = const VerificationMeta('explain');
  GeneratedTextColumn _explain;
  @override
  GeneratedTextColumn get explain => _explain ??= _constructExplain();
  GeneratedTextColumn _constructExplain() {
    return GeneratedTextColumn(
      'explain',
      $tableName,
      true,
    );
  }

  final VerificationMeta _viewsMeta = const VerificationMeta('views');
  GeneratedIntColumn _views;
  @override
  GeneratedIntColumn get views => _views ??= _constructViews();
  GeneratedIntColumn _constructViews() {
    return GeneratedIntColumn(
      'views',
      $tableName,
      true,
    );
  }

  final VerificationMeta _favoritesMeta = const VerificationMeta('favorites');
  GeneratedIntColumn _favorites;
  @override
  GeneratedIntColumn get favorites => _favorites ??= _constructFavorites();
  GeneratedIntColumn _constructFavorites() {
    return GeneratedIntColumn(
      'favorites',
      $tableName,
      true,
    );
  }

  final VerificationMeta _uploadtimeMeta = const VerificationMeta('uploadtime');
  GeneratedDateTimeColumn _uploadtime;
  @override
  GeneratedDateTimeColumn get uploadtime =>
      _uploadtime ??= _constructUploadtime();
  GeneratedDateTimeColumn _constructUploadtime() {
    return GeneratedDateTimeColumn(
      'uploadtime',
      $tableName,
      true,
    );
  }

  final VerificationMeta _updatetimeMeta = const VerificationMeta('updatetime');
  GeneratedDateTimeColumn _updatetime;
  @override
  GeneratedDateTimeColumn get updatetime =>
      _updatetime ??= _constructUpdatetime();
  GeneratedDateTimeColumn _constructUpdatetime() {
    return GeneratedDateTimeColumn(
      'updatetime',
      $tableName,
      true,
    );
  }

  final VerificationMeta _bumptimeMeta = const VerificationMeta('bumptime');
  GeneratedDateTimeColumn _bumptime;
  @override
  GeneratedDateTimeColumn get bumptime => _bumptime ??= _constructBumptime();
  GeneratedDateTimeColumn _constructBumptime() {
    return GeneratedDateTimeColumn(
      'bumptime',
      $tableName,
      true,
    );
  }

  final VerificationMeta _favoritetimeMeta =
      const VerificationMeta('favoritetime');
  GeneratedDateTimeColumn _favoritetime;
  @override
  GeneratedDateTimeColumn get favoritetime =>
      _favoritetime ??= _constructFavoritetime();
  GeneratedDateTimeColumn _constructFavoritetime() {
    return GeneratedDateTimeColumn(
      'favoritetime',
      $tableName,
      true,
    );
  }

  final VerificationMeta _imagesMeta = const VerificationMeta('images');
  GeneratedTextColumn _images;
  @override
  GeneratedTextColumn get images => _images ??= _constructImages();
  GeneratedTextColumn _constructImages() {
    return GeneratedTextColumn(
      'images',
      $tableName,
      false,
    );
  }

  final VerificationMeta _hideMeta = const VerificationMeta('hide');
  GeneratedIntColumn _hide;
  @override
  GeneratedIntColumn get hide => _hide ??= _constructHide();
  GeneratedIntColumn _constructHide() {
    return GeneratedIntColumn(
      'hide',
      $tableName,
      false,
    );
  }

  final VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  GeneratedIntColumn _deleted;
  @override
  GeneratedIntColumn get deleted => _deleted ??= _constructDeleted();
  GeneratedIntColumn _constructDeleted() {
    return GeneratedIntColumn(
      'deleted',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        title,
        firestoreid,
        uid,
        category,
        price,
        explain,
        views,
        favorites,
        uploadtime,
        updatetime,
        bumptime,
        favoritetime,
        images,
        hide,
        deleted
      ];
  @override
  $ProductsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'products';
  @override
  final String actualTableName = 'products';
  @override
  VerificationContext validateIntegrity(Insertable<Product> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('firestoreid')) {
      context.handle(
          _firestoreidMeta,
          firestoreid.isAcceptableOrUnknown(
              data['firestoreid'], _firestoreidMeta));
    } else if (isInserting) {
      context.missing(_firestoreidMeta);
    }
    if (data.containsKey('uid')) {
      context.handle(
          _uidMeta, uid.isAcceptableOrUnknown(data['uid'], _uidMeta));
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category'], _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price'], _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('explain')) {
      context.handle(_explainMeta,
          explain.isAcceptableOrUnknown(data['explain'], _explainMeta));
    }
    if (data.containsKey('views')) {
      context.handle(
          _viewsMeta, views.isAcceptableOrUnknown(data['views'], _viewsMeta));
    }
    if (data.containsKey('favorites')) {
      context.handle(_favoritesMeta,
          favorites.isAcceptableOrUnknown(data['favorites'], _favoritesMeta));
    }
    if (data.containsKey('uploadtime')) {
      context.handle(
          _uploadtimeMeta,
          uploadtime.isAcceptableOrUnknown(
              data['uploadtime'], _uploadtimeMeta));
    }
    if (data.containsKey('updatetime')) {
      context.handle(
          _updatetimeMeta,
          updatetime.isAcceptableOrUnknown(
              data['updatetime'], _updatetimeMeta));
    }
    if (data.containsKey('bumptime')) {
      context.handle(_bumptimeMeta,
          bumptime.isAcceptableOrUnknown(data['bumptime'], _bumptimeMeta));
    }
    if (data.containsKey('favoritetime')) {
      context.handle(
          _favoritetimeMeta,
          favoritetime.isAcceptableOrUnknown(
              data['favoritetime'], _favoritetimeMeta));
    }
    if (data.containsKey('images')) {
      context.handle(_imagesMeta,
          images.isAcceptableOrUnknown(data['images'], _imagesMeta));
    } else if (isInserting) {
      context.missing(_imagesMeta);
    }
    if (data.containsKey('hide')) {
      context.handle(
          _hideMeta, hide.isAcceptableOrUnknown(data['hide'], _hideMeta));
    } else if (isInserting) {
      context.missing(_hideMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted'], _deletedMeta));
    } else if (isInserting) {
      context.missing(_deletedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {firestoreid};
  @override
  Product map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Product.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(_db, alias);
  }
}

class Search extends DataClass implements Insertable<Search> {
  final int id;
  final String title;
  Search({@required this.id, @required this.title});
  factory Search.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Search(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    return map;
  }

  SearchsCompanion toCompanion(bool nullToAbsent) {
    return SearchsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
    );
  }

  factory Search.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Search(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
    };
  }

  Search copyWith({int id, String title}) => Search(
        id: id ?? this.id,
        title: title ?? this.title,
      );
  @override
  String toString() {
    return (StringBuffer('Search(')
          ..write('id: $id, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, title.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Search && other.id == this.id && other.title == this.title);
}

class SearchsCompanion extends UpdateCompanion<Search> {
  final Value<int> id;
  final Value<String> title;
  const SearchsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
  });
  SearchsCompanion.insert({
    this.id = const Value.absent(),
    @required String title,
  }) : title = Value(title);
  static Insertable<Search> custom({
    Expression<int> id,
    Expression<String> title,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
    });
  }

  SearchsCompanion copyWith({Value<int> id, Value<String> title}) {
    return SearchsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class $SearchsTable extends Searchs with TableInfo<$SearchsTable, Search> {
  final GeneratedDatabase _db;
  final String _alias;
  $SearchsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, title];
  @override
  $SearchsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'searchs';
  @override
  final String actualTableName = 'searchs';
  @override
  VerificationContext validateIntegrity(Insertable<Search> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Search map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Search.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $SearchsTable createAlias(String alias) {
    return $SearchsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $ProductsTable _products;
  $ProductsTable get products => _products ??= $ProductsTable(this);
  $SearchsTable _searchs;
  $SearchsTable get searchs => _searchs ??= $SearchsTable(this);
  ProductsDao _productsDao;
  ProductsDao get productsDao =>
      _productsDao ??= ProductsDao(this as AppDatabase);
  SearchsDao _searchsDao;
  SearchsDao get searchsDao => _searchsDao ??= SearchsDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [products, searchs];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$ProductsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProductsTable get products => attachedDatabase.products;
}
mixin _$SearchsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SearchsTable get searchs => attachedDatabase.searchs;
}
