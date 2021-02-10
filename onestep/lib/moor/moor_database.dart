import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

class Searchs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get time => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@UseDao(tables: [Searchs])
class SearchsDao extends DatabaseAccessor<AppDatabase> with _$SearchsDaoMixin {
  SearchsDao(AppDatabase db) : super(db);

  Future<List<Search>> getAllSearchs() => select(searchs).get();

  Stream<List<QueryRow>> watchSearchs() => customSelect(
        "SELECT * FROM Searchs ORDER BY time DESC",
        readsFrom: {searchs},
      ).watch();

  Future insertSearch(Search search) => into(searchs).insert(search);
  Future deleteSearch(Search search) => delete(searchs).delete(search);
  Future updateSearch(Search search) => update(searchs).replace(search);

  deleteAllSearch() => delete(searchs).go();
}

@UseMoor(tables: [Searchs], daos: [SearchsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;
}
