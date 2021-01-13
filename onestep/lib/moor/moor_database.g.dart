// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Product extends DataClass implements Insertable<Product> {
  final String title;
  final String firestoreid;
  final String category;
  final String price;
  final String explain;
  final int views;
  final DateTime uploadtime;
  final String images;
  Product(
      {@required this.title,
      @required this.firestoreid,
      @required this.category,
      @required this.price,
      this.explain,
      this.views,
      this.uploadtime,
      @required this.images});
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
      category: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}category']),
      price:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}price']),
      explain:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}explain']),
      views: intType.mapFromDatabaseResponse(data['${effectivePrefix}views']),
      uploadtime: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}uploadtime']),
      images:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}images']),
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
    if (!nullToAbsent || uploadtime != null) {
      map['uploadtime'] = Variable<DateTime>(uploadtime);
    }
    if (!nullToAbsent || images != null) {
      map['images'] = Variable<String>(images);
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
      uploadtime: uploadtime == null && nullToAbsent
          ? const Value.absent()
          : Value(uploadtime),
      images:
          images == null && nullToAbsent ? const Value.absent() : Value(images),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Product(
      title: serializer.fromJson<String>(json['title']),
      firestoreid: serializer.fromJson<String>(json['firestoreid']),
      category: serializer.fromJson<String>(json['category']),
      price: serializer.fromJson<String>(json['price']),
      explain: serializer.fromJson<String>(json['explain']),
      views: serializer.fromJson<int>(json['views']),
      uploadtime: serializer.fromJson<DateTime>(json['uploadtime']),
      images: serializer.fromJson<String>(json['images']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'title': serializer.toJson<String>(title),
      'firestoreid': serializer.toJson<String>(firestoreid),
      'category': serializer.toJson<String>(category),
      'price': serializer.toJson<String>(price),
      'explain': serializer.toJson<String>(explain),
      'views': serializer.toJson<int>(views),
      'uploadtime': serializer.toJson<DateTime>(uploadtime),
      'images': serializer.toJson<String>(images),
    };
  }

  Product copyWith(
          {String title,
          String firestoreid,
          String category,
          String price,
          String explain,
          int views,
          DateTime uploadtime,
          String images}) =>
      Product(
        title: title ?? this.title,
        firestoreid: firestoreid ?? this.firestoreid,
        category: category ?? this.category,
        price: price ?? this.price,
        explain: explain ?? this.explain,
        views: views ?? this.views,
        uploadtime: uploadtime ?? this.uploadtime,
        images: images ?? this.images,
      );
  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('title: $title, ')
          ..write('firestoreid: $firestoreid, ')
          ..write('category: $category, ')
          ..write('price: $price, ')
          ..write('explain: $explain, ')
          ..write('views: $views, ')
          ..write('uploadtime: $uploadtime, ')
          ..write('images: $images')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      title.hashCode,
      $mrjc(
          firestoreid.hashCode,
          $mrjc(
              category.hashCode,
              $mrjc(
                  price.hashCode,
                  $mrjc(
                      explain.hashCode,
                      $mrjc(views.hashCode,
                          $mrjc(uploadtime.hashCode, images.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Product &&
          other.title == this.title &&
          other.firestoreid == this.firestoreid &&
          other.category == this.category &&
          other.price == this.price &&
          other.explain == this.explain &&
          other.views == this.views &&
          other.uploadtime == this.uploadtime &&
          other.images == this.images);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> title;
  final Value<String> firestoreid;
  final Value<String> category;
  final Value<String> price;
  final Value<String> explain;
  final Value<int> views;
  final Value<DateTime> uploadtime;
  final Value<String> images;
  const ProductsCompanion({
    this.title = const Value.absent(),
    this.firestoreid = const Value.absent(),
    this.category = const Value.absent(),
    this.price = const Value.absent(),
    this.explain = const Value.absent(),
    this.views = const Value.absent(),
    this.uploadtime = const Value.absent(),
    this.images = const Value.absent(),
  });
  ProductsCompanion.insert({
    @required String title,
    @required String firestoreid,
    @required String category,
    @required String price,
    this.explain = const Value.absent(),
    this.views = const Value.absent(),
    this.uploadtime = const Value.absent(),
    @required String images,
  })  : title = Value(title),
        firestoreid = Value(firestoreid),
        category = Value(category),
        price = Value(price),
        images = Value(images);
  static Insertable<Product> custom({
    Expression<String> title,
    Expression<String> firestoreid,
    Expression<String> category,
    Expression<String> price,
    Expression<String> explain,
    Expression<int> views,
    Expression<DateTime> uploadtime,
    Expression<String> images,
  }) {
    return RawValuesInsertable({
      if (title != null) 'title': title,
      if (firestoreid != null) 'firestoreid': firestoreid,
      if (category != null) 'category': category,
      if (price != null) 'price': price,
      if (explain != null) 'explain': explain,
      if (views != null) 'views': views,
      if (uploadtime != null) 'uploadtime': uploadtime,
      if (images != null) 'images': images,
    });
  }

  ProductsCompanion copyWith(
      {Value<String> title,
      Value<String> firestoreid,
      Value<String> category,
      Value<String> price,
      Value<String> explain,
      Value<int> views,
      Value<DateTime> uploadtime,
      Value<String> images}) {
    return ProductsCompanion(
      title: title ?? this.title,
      firestoreid: firestoreid ?? this.firestoreid,
      category: category ?? this.category,
      price: price ?? this.price,
      explain: explain ?? this.explain,
      views: views ?? this.views,
      uploadtime: uploadtime ?? this.uploadtime,
      images: images ?? this.images,
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
    if (uploadtime.present) {
      map['uploadtime'] = Variable<DateTime>(uploadtime.value);
    }
    if (images.present) {
      map['images'] = Variable<String>(images.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('title: $title, ')
          ..write('firestoreid: $firestoreid, ')
          ..write('category: $category, ')
          ..write('price: $price, ')
          ..write('explain: $explain, ')
          ..write('views: $views, ')
          ..write('uploadtime: $uploadtime, ')
          ..write('images: $images')
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

  @override
  List<GeneratedColumn> get $columns =>
      [title, firestoreid, category, price, explain, views, uploadtime, images];
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

mixin _$SearchsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SearchsTable get searchs => attachedDatabase.searchs;
}
mixin _$ProductsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProductsTable get products => attachedDatabase.products;
}
