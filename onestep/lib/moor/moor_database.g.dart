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
      images:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}images']),
      hide: intType.mapFromDatabaseResponse(data['${effectivePrefix}hide']),
      deleted:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}deleted']),
    );
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
      images:
          images == null && nullToAbsent ? const Value.absent() : Value(images),
      hide: hide == null && nullToAbsent ? const Value.absent() : Value(hide),
      deleted: deleted == null && nullToAbsent
          ? const Value.absent()
          : Value(deleted),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Product(
      title: serializer.fromJson<String>(json['title']),
      firestoreid: serializer.fromJson<String>(json['firestoreid']),
      uid: serializer.fromJson<String>(json['uid']),
      category: serializer.fromJson<String>(json['category']),
      price: serializer.fromJson<String>(json['price']),
      explain: serializer.fromJson<String>(json['explain']),
      views: serializer.fromJson<int>(json['views']),
      favorites: serializer.fromJson<int>(json['favorites']),
      uploadtime: serializer.fromJson<DateTime>(json['uploadtime']),
      images: serializer.fromJson<String>(json['images']),
      hide: serializer.fromJson<int>(json['hide']),
      deleted: serializer.fromJson<int>(json['deleted']),
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
                                          images.hashCode,
                                          $mrjc(hide.hashCode,
                                              deleted.hashCode))))))))))));
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $ProductsTable _products;
  $ProductsTable get products => _products ??= $ProductsTable(this);
  ProductsDao _productsDao;
  ProductsDao get productsDao =>
      _productsDao ??= ProductsDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [products];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$ProductsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProductsTable get products => attachedDatabase.products;
}
