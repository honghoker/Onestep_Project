// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Search extends DataClass implements Insertable<Search> {
  final String title;
  final DateTime time;
  Search({@required this.title, @required this.time});
  factory Search.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Search(
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      time:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}time']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || time != null) {
      map['time'] = Variable<DateTime>(time);
    }
    return map;
  }

  SearchsCompanion toCompanion(bool nullToAbsent) {
    return SearchsCompanion(
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
    );
  }

  factory Search.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Search(
      title: serializer.fromJson<String>(json['title']),
      time: serializer.fromJson<DateTime>(json['time']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'title': serializer.toJson<String>(title),
      'time': serializer.toJson<DateTime>(time),
    };
  }

  Search copyWith({String title, DateTime time}) => Search(
        title: title ?? this.title,
        time: time ?? this.time,
      );
  @override
  String toString() {
    return (StringBuffer('Search(')
          ..write('title: $title, ')
          ..write('time: $time')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(title.hashCode, time.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Search && other.title == this.title && other.time == this.time);
}

class SearchsCompanion extends UpdateCompanion<Search> {
  final Value<String> title;
  final Value<DateTime> time;
  const SearchsCompanion({
    this.title = const Value.absent(),
    this.time = const Value.absent(),
  });
  SearchsCompanion.insert({
    @required String title,
    @required DateTime time,
  })  : title = Value(title),
        time = Value(time);
  static Insertable<Search> custom({
    Expression<String> title,
    Expression<DateTime> time,
  }) {
    return RawValuesInsertable({
      if (title != null) 'title': title,
      if (time != null) 'time': time,
    });
  }

  SearchsCompanion copyWith({Value<String> title, Value<DateTime> time}) {
    return SearchsCompanion(
      title: title ?? this.title,
      time: time ?? this.time,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (time.present) {
      map['time'] = Variable<DateTime>(time.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchsCompanion(')
          ..write('title: $title, ')
          ..write('time: $time')
          ..write(')'))
        .toString();
  }
}

class $SearchsTable extends Searchs with TableInfo<$SearchsTable, Search> {
  final GeneratedDatabase _db;
  final String _alias;
  $SearchsTable(this._db, [this._alias]);
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

  final VerificationMeta _timeMeta = const VerificationMeta('time');
  GeneratedDateTimeColumn _time;
  @override
  GeneratedDateTimeColumn get time => _time ??= _constructTime();
  GeneratedDateTimeColumn _constructTime() {
    return GeneratedDateTimeColumn(
      'time',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [title, time];
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
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time'], _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {title};
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

class NotificationChk extends DataClass implements Insertable<NotificationChk> {
  final String firestoreid;
  final DateTime uploadtime;
  final String entireChecked;
  final String readChecked;
  NotificationChk(
      {@required this.firestoreid,
      this.uploadtime,
      @required this.entireChecked,
      @required this.readChecked});
  factory NotificationChk.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return NotificationChk(
      firestoreid: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}firestoreid']),
      uploadtime: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}uploadtime']),
      entireChecked: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}entire_checked']),
      readChecked: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}read_checked']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || firestoreid != null) {
      map['firestoreid'] = Variable<String>(firestoreid);
    }
    if (!nullToAbsent || uploadtime != null) {
      map['uploadtime'] = Variable<DateTime>(uploadtime);
    }
    if (!nullToAbsent || entireChecked != null) {
      map['entire_checked'] = Variable<String>(entireChecked);
    }
    if (!nullToAbsent || readChecked != null) {
      map['read_checked'] = Variable<String>(readChecked);
    }
    return map;
  }

  NotificationChksCompanion toCompanion(bool nullToAbsent) {
    return NotificationChksCompanion(
      firestoreid: firestoreid == null && nullToAbsent
          ? const Value.absent()
          : Value(firestoreid),
      uploadtime: uploadtime == null && nullToAbsent
          ? const Value.absent()
          : Value(uploadtime),
      entireChecked: entireChecked == null && nullToAbsent
          ? const Value.absent()
          : Value(entireChecked),
      readChecked: readChecked == null && nullToAbsent
          ? const Value.absent()
          : Value(readChecked),
    );
  }

  factory NotificationChk.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return NotificationChk(
      firestoreid: serializer.fromJson<String>(json['firestoreid']),
      uploadtime: serializer.fromJson<DateTime>(json['uploadtime']),
      entireChecked: serializer.fromJson<String>(json['entireChecked']),
      readChecked: serializer.fromJson<String>(json['readChecked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'firestoreid': serializer.toJson<String>(firestoreid),
      'uploadtime': serializer.toJson<DateTime>(uploadtime),
      'entireChecked': serializer.toJson<String>(entireChecked),
      'readChecked': serializer.toJson<String>(readChecked),
    };
  }

  NotificationChk copyWith(
          {String firestoreid,
          DateTime uploadtime,
          String entireChecked,
          String readChecked}) =>
      NotificationChk(
        firestoreid: firestoreid ?? this.firestoreid,
        uploadtime: uploadtime ?? this.uploadtime,
        entireChecked: entireChecked ?? this.entireChecked,
        readChecked: readChecked ?? this.readChecked,
      );
  @override
  String toString() {
    return (StringBuffer('NotificationChk(')
          ..write('firestoreid: $firestoreid, ')
          ..write('uploadtime: $uploadtime, ')
          ..write('entireChecked: $entireChecked, ')
          ..write('readChecked: $readChecked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      firestoreid.hashCode,
      $mrjc(uploadtime.hashCode,
          $mrjc(entireChecked.hashCode, readChecked.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is NotificationChk &&
          other.firestoreid == this.firestoreid &&
          other.uploadtime == this.uploadtime &&
          other.entireChecked == this.entireChecked &&
          other.readChecked == this.readChecked);
}

class NotificationChksCompanion extends UpdateCompanion<NotificationChk> {
  final Value<String> firestoreid;
  final Value<DateTime> uploadtime;
  final Value<String> entireChecked;
  final Value<String> readChecked;
  const NotificationChksCompanion({
    this.firestoreid = const Value.absent(),
    this.uploadtime = const Value.absent(),
    this.entireChecked = const Value.absent(),
    this.readChecked = const Value.absent(),
  });
  NotificationChksCompanion.insert({
    @required String firestoreid,
    this.uploadtime = const Value.absent(),
    @required String entireChecked,
    @required String readChecked,
  })  : firestoreid = Value(firestoreid),
        entireChecked = Value(entireChecked),
        readChecked = Value(readChecked);
  static Insertable<NotificationChk> custom({
    Expression<String> firestoreid,
    Expression<DateTime> uploadtime,
    Expression<String> entireChecked,
    Expression<String> readChecked,
  }) {
    return RawValuesInsertable({
      if (firestoreid != null) 'firestoreid': firestoreid,
      if (uploadtime != null) 'uploadtime': uploadtime,
      if (entireChecked != null) 'entire_checked': entireChecked,
      if (readChecked != null) 'read_checked': readChecked,
    });
  }

  NotificationChksCompanion copyWith(
      {Value<String> firestoreid,
      Value<DateTime> uploadtime,
      Value<String> entireChecked,
      Value<String> readChecked}) {
    return NotificationChksCompanion(
      firestoreid: firestoreid ?? this.firestoreid,
      uploadtime: uploadtime ?? this.uploadtime,
      entireChecked: entireChecked ?? this.entireChecked,
      readChecked: readChecked ?? this.readChecked,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (firestoreid.present) {
      map['firestoreid'] = Variable<String>(firestoreid.value);
    }
    if (uploadtime.present) {
      map['uploadtime'] = Variable<DateTime>(uploadtime.value);
    }
    if (entireChecked.present) {
      map['entire_checked'] = Variable<String>(entireChecked.value);
    }
    if (readChecked.present) {
      map['read_checked'] = Variable<String>(readChecked.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationChksCompanion(')
          ..write('firestoreid: $firestoreid, ')
          ..write('uploadtime: $uploadtime, ')
          ..write('entireChecked: $entireChecked, ')
          ..write('readChecked: $readChecked')
          ..write(')'))
        .toString();
  }
}

class $NotificationChksTable extends NotificationChks
    with TableInfo<$NotificationChksTable, NotificationChk> {
  final GeneratedDatabase _db;
  final String _alias;
  $NotificationChksTable(this._db, [this._alias]);
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

  final VerificationMeta _entireCheckedMeta =
      const VerificationMeta('entireChecked');
  GeneratedTextColumn _entireChecked;
  @override
  GeneratedTextColumn get entireChecked =>
      _entireChecked ??= _constructEntireChecked();
  GeneratedTextColumn _constructEntireChecked() {
    return GeneratedTextColumn(
      'entire_checked',
      $tableName,
      false,
    );
  }

  final VerificationMeta _readCheckedMeta =
      const VerificationMeta('readChecked');
  GeneratedTextColumn _readChecked;
  @override
  GeneratedTextColumn get readChecked =>
      _readChecked ??= _constructReadChecked();
  GeneratedTextColumn _constructReadChecked() {
    return GeneratedTextColumn(
      'read_checked',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [firestoreid, uploadtime, entireChecked, readChecked];
  @override
  $NotificationChksTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'notification_chks';
  @override
  final String actualTableName = 'notification_chks';
  @override
  VerificationContext validateIntegrity(Insertable<NotificationChk> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('firestoreid')) {
      context.handle(
          _firestoreidMeta,
          firestoreid.isAcceptableOrUnknown(
              data['firestoreid'], _firestoreidMeta));
    } else if (isInserting) {
      context.missing(_firestoreidMeta);
    }
    if (data.containsKey('uploadtime')) {
      context.handle(
          _uploadtimeMeta,
          uploadtime.isAcceptableOrUnknown(
              data['uploadtime'], _uploadtimeMeta));
    }
    if (data.containsKey('entire_checked')) {
      context.handle(
          _entireCheckedMeta,
          entireChecked.isAcceptableOrUnknown(
              data['entire_checked'], _entireCheckedMeta));
    } else if (isInserting) {
      context.missing(_entireCheckedMeta);
    }
    if (data.containsKey('read_checked')) {
      context.handle(
          _readCheckedMeta,
          readChecked.isAcceptableOrUnknown(
              data['read_checked'], _readCheckedMeta));
    } else if (isInserting) {
      context.missing(_readCheckedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {firestoreid};
  @override
  NotificationChk map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return NotificationChk.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $NotificationChksTable createAlias(String alias) {
    return $NotificationChksTable(_db, alias);
  }
}

class PushNoticeChk extends DataClass implements Insertable<PushNoticeChk> {
  final String pushChecked;
  PushNoticeChk({@required this.pushChecked});
  factory PushNoticeChk.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return PushNoticeChk(
      pushChecked: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}push_checked']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || pushChecked != null) {
      map['push_checked'] = Variable<String>(pushChecked);
    }
    return map;
  }

  PushNoticeChksCompanion toCompanion(bool nullToAbsent) {
    return PushNoticeChksCompanion(
      pushChecked: pushChecked == null && nullToAbsent
          ? const Value.absent()
          : Value(pushChecked),
    );
  }

  factory PushNoticeChk.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return PushNoticeChk(
      pushChecked: serializer.fromJson<String>(json['pushChecked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'pushChecked': serializer.toJson<String>(pushChecked),
    };
  }

  PushNoticeChk copyWith({String pushChecked}) => PushNoticeChk(
        pushChecked: pushChecked ?? this.pushChecked,
      );
  @override
  String toString() {
    return (StringBuffer('PushNoticeChk(')
          ..write('pushChecked: $pushChecked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf(pushChecked.hashCode);
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is PushNoticeChk && other.pushChecked == this.pushChecked);
}

class PushNoticeChksCompanion extends UpdateCompanion<PushNoticeChk> {
  final Value<String> pushChecked;
  const PushNoticeChksCompanion({
    this.pushChecked = const Value.absent(),
  });
  PushNoticeChksCompanion.insert({
    @required String pushChecked,
  }) : pushChecked = Value(pushChecked);
  static Insertable<PushNoticeChk> custom({
    Expression<String> pushChecked,
  }) {
    return RawValuesInsertable({
      if (pushChecked != null) 'push_checked': pushChecked,
    });
  }

  PushNoticeChksCompanion copyWith({Value<String> pushChecked}) {
    return PushNoticeChksCompanion(
      pushChecked: pushChecked ?? this.pushChecked,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (pushChecked.present) {
      map['push_checked'] = Variable<String>(pushChecked.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PushNoticeChksCompanion(')
          ..write('pushChecked: $pushChecked')
          ..write(')'))
        .toString();
  }
}

class $PushNoticeChksTable extends PushNoticeChks
    with TableInfo<$PushNoticeChksTable, PushNoticeChk> {
  final GeneratedDatabase _db;
  final String _alias;
  $PushNoticeChksTable(this._db, [this._alias]);
  final VerificationMeta _pushCheckedMeta =
      const VerificationMeta('pushChecked');
  GeneratedTextColumn _pushChecked;
  @override
  GeneratedTextColumn get pushChecked =>
      _pushChecked ??= _constructPushChecked();
  GeneratedTextColumn _constructPushChecked() {
    return GeneratedTextColumn(
      'push_checked',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [pushChecked];
  @override
  $PushNoticeChksTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'push_notice_chks';
  @override
  final String actualTableName = 'push_notice_chks';
  @override
  VerificationContext validateIntegrity(Insertable<PushNoticeChk> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('push_checked')) {
      context.handle(
          _pushCheckedMeta,
          pushChecked.isAcceptableOrUnknown(
              data['push_checked'], _pushCheckedMeta));
    } else if (isInserting) {
      context.missing(_pushCheckedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {pushChecked};
  @override
  PushNoticeChk map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return PushNoticeChk.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $PushNoticeChksTable createAlias(String alias) {
    return $PushNoticeChksTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $SearchsTable _searchs;
  $SearchsTable get searchs => _searchs ??= $SearchsTable(this);
  $NotificationChksTable _notificationChks;
  $NotificationChksTable get notificationChks =>
      _notificationChks ??= $NotificationChksTable(this);
  $PushNoticeChksTable _pushNoticeChks;
  $PushNoticeChksTable get pushNoticeChks =>
      _pushNoticeChks ??= $PushNoticeChksTable(this);
  SearchsDao _searchsDao;
  SearchsDao get searchsDao => _searchsDao ??= SearchsDao(this as AppDatabase);
  NotificationChksDao _notificationChksDao;
  NotificationChksDao get notificationChksDao =>
      _notificationChksDao ??= NotificationChksDao(this as AppDatabase);
  PushNoticeChksDao _pushNoticeChksDao;
  PushNoticeChksDao get pushNoticeChksDao =>
      _pushNoticeChksDao ??= PushNoticeChksDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [searchs, notificationChks, pushNoticeChks];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$SearchsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SearchsTable get searchs => attachedDatabase.searchs;
}
mixin _$NotificationChksDaoMixin on DatabaseAccessor<AppDatabase> {
  $NotificationChksTable get notificationChks =>
      attachedDatabase.notificationChks;
}
mixin _$PushNoticeChksDaoMixin on DatabaseAccessor<AppDatabase> {
  $PushNoticeChksTable get pushNoticeChks => attachedDatabase.pushNoticeChks;
}
