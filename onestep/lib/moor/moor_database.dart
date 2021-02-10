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

class Searchs extends Table {
  TextColumn get title => text()();

  @override
  Set<Column> get primaryKey => {title};
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

class NotificationChks extends Table {
  TextColumn get firestoreid => text()();
  DateTimeColumn get uploadtime => dateTime().nullable()();
  // BoolColumn get readChecked => boolean()();
  TextColumn get readChecked => text()();

  @override
  Set<Column> get primaryKey => {firestoreid};
}

@UseDao(tables: [NotificationChks])
class NotificationChksDao extends DatabaseAccessor<AppDatabase>
    with _$NotificationChksDaoMixin {
  NotificationChksDao(AppDatabase db) : super(db);

  Future<List<NotificationChk>> getAllNotification() =>
      select(notificationChks).get();

  Stream<List<NotificationChk>> watchNotification() {
    return (select(notificationChks)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.uploadtime, mode: OrderingMode.desc),
          ])
          ..limit(1, offset: 0))
        .watch();
  }

  Stream<List<NotificationChk>> watchNotificationAll() {
    return (select(notificationChks)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.uploadtime, mode: OrderingMode.desc),
          ])
          ..where((t) => t.readChecked.equals('false'))
          )
        .watch();
  }


  // Stream<List<NotificationChk>> watchNotificationAll() =>
  //     select(notificationChks).watch();

  // Stream<QueryRow> watchNotificationAll(bool type) =>
  //     customSelect(
  //       "SELECT * FROM notification_chks WHERE read_checked LIKE '$type'",
  //       readsFrom: {notificationChks},
  //     ).watchSingle();

  Future insertNotification(NotificationChk notificationChk) =>
      into(notificationChks).insert(notificationChk);

  Future deleteNotification(NotificationChk notificationChk) =>
      delete(notificationChks).delete(notificationChk);

  Future updateNotification(NotificationChk notificationChk) =>
      update(notificationChks).replace(notificationChk);

  Stream<QueryRow> watchsingleNotification(String firestoreid, bool type) =>
      customSelect(
        "SELECT * FROM notification_chks WHERE firestoreid LIKE '$firestoreid' AND read_checked = '$type'",
        readsFrom: {notificationChks},
      ).watchSingle();


  deleteAllNotification() => delete(notificationChks).go();
}

@UseMoor(
    tables: [Products, Searchs, NotificationChks],
    daos: [ProductsDao, SearchsDao, NotificationChksDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;
}
