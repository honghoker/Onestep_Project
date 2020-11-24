import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

class Products extends Table {
  TextColumn get title => text()();
  TextColumn get firestoreid => text()();
  TextColumn get category => text()();
  TextColumn get price => text()();
  TextColumn get explain => text()();
  IntColumn get views => integer()();
  DateTimeColumn get uploadtime => dateTime()();
  TextColumn get images => text()();

  @override
  Set<Column> get primaryKey => {firestoreid};
}

@UseDao(tables: [Products])
class ProductsDao extends DatabaseAccessor<AppDatabase>
    with _$ProductsDaoMixin {
  ProductsDao(AppDatabase db) : super(db);

  Future<List<Product>> getAllProducts() => select(products).get();
  Stream<List<Product>> watchProducts() => select(products).watch();
  Future insertProduct(Product product) => into(products).insert(product);
  Future deleteProduct(Product product) => delete(products).delete(product);
}

@UseMoor(tables: [Products], daos: [ProductsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;
}
