import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

class Searchs extends Table {
  TextColumn get title => text()();
  DateTimeColumn get time => dateTime()();

  @override
  Set<Column> get primaryKey => {title};
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

class NotificationChks extends Table {
  TextColumn get firestoreid => text()();
  DateTimeColumn get uploadtime => dateTime().nullable()();
  TextColumn get entireChecked => text()();
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
          ..where((t) => t.readChecked.equals('false')))
        .watch();
  }

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

class PushNoticeChks extends Table {
  TextColumn get pushChecked => text()();

  @override
  Set<Column> get primaryKey => {pushChecked};
}

@UseDao(tables: [PushNoticeChks])
class PushNoticeChksDao extends DatabaseAccessor<AppDatabase> with _$PushNoticeChksDaoMixin {
  PushNoticeChksDao(AppDatabase db) : super(db);

  Future<List<PushNoticeChk>> getAllPushNoticeChks() => select(pushNoticeChks).get();

  Future insertPushNotice(PushNoticeChk pushNoticeChk) => into(pushNoticeChks).insert(pushNoticeChk);
  Future deletePushNotice(PushNoticeChk pushNoticeChk) => delete(pushNoticeChks).delete(pushNoticeChk);
  Future updatePushNotice(PushNoticeChk pushNoticeChk) => update(pushNoticeChks).replace(pushNoticeChk);

  deleteAllPushNotice() => delete(pushNoticeChks).go();
}

@UseMoor(
    tables: [Searchs, NotificationChks,PushNoticeChks],
    daos: [SearchsDao, NotificationChksDao,PushNoticeChksDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;
}
