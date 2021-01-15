import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

class Products extends Table {
  TextColumn get title => text()();
  TextColumn get firestoreid => text()();
  TextColumn get uid => text()();
  TextColumn get category => text()();
  TextColumn get price => text()();
  TextColumn get explain => text().nullable()();
  IntColumn get views => integer().nullable()();
  IntColumn get favorites => integer().nullable()();
  DateTimeColumn get uploadtime => dateTime().nullable()();
  DateTimeColumn get updatetime => dateTime().nullable()();
  DateTimeColumn get bumptime => dateTime().nullable()();
  TextColumn get images => text()();
  IntColumn get hide => integer()();
  IntColumn get deleted => integer()();

  @override
  Set<Column> get primaryKey => {firestoreid};
}

class Searchs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@UseDao(tables: [Products])
class ProductsDao extends DatabaseAccessor<AppDatabase>
    with _$ProductsDaoMixin {
  ProductsDao(AppDatabase db) : super(db);

  Future<List<Product>> getAllProducts() => select(products).get();
  Stream<List<Product>> watchProducts() => select(products).watch();
  Future insertProduct(Product product) => into(products).insert(product);
  Future deleteProduct(Product product) => delete(products).delete(product);
  Stream<QueryRow> watchsingleProduct(String firestoreid) => customSelect(
        "SELECT * FROM Products WHERE firestoreid LIKE '$firestoreid'",
        readsFrom: {products},
      ).watchSingle();

  Future updateProduct(Product product) => update(products).replace(product);

  deleteAllProduct() => delete(products).go();
}

@UseDao(tables: [Searchs])
class SearchsDao extends DatabaseAccessor<AppDatabase> with _$SearchsDaoMixin {
  SearchsDao(AppDatabase db) : super(db);

  Future<List<Search>> getAllSearchs() => select(searchs).get();
  Stream<List<Search>> watchSearchs() => select(searchs).watch();
  Future insertSearch(Search search) => into(searchs).insert(search);
  Future deleteSearch(Search search) => delete(searchs).delete(search);
  Future updateSearch(Search search) => update(searchs).replace(search);

  deleteAllSearch() => delete(searchs).go();
}

@UseMoor(tables: [Products, Searchs], daos: [ProductsDao, SearchsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;
}
