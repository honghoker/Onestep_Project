import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

class Products extends Table {
  TextColumn get title => text()();
  TextColumn get firestoreid => text()();
  TextColumn get category => text()();
  TextColumn get price => text()();
  TextColumn get explain => text().nullable()();
  IntColumn get views => integer().nullable()();
  DateTimeColumn get uploadtime => dateTime().nullable()();
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

  deleteAllProduct() => delete(products).go();
}

@UseMoor(tables: [Products], daos: [ProductsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;
}
