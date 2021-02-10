// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Search extends DataClass implements Insertable<Search> {
  final int id;
  final String title;
  final DateTime time;
  Search({@required this.id, @required this.title, @required this.time});
  factory Search.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Search(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      time:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}time']),
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
    if (!nullToAbsent || time != null) {
      map['time'] = Variable<DateTime>(time);
    }
    return map;
  }

  SearchsCompanion toCompanion(bool nullToAbsent) {
    return SearchsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
    );
  }

  factory Search.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Search(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      time: serializer.fromJson<DateTime>(json['time']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'time': serializer.toJson<DateTime>(time),
    };
  }

  Search copyWith({int id, String title, DateTime time}) => Search(
        id: id ?? this.id,
        title: title ?? this.title,
        time: time ?? this.time,
      );
  @override
  String toString() {
    return (StringBuffer('Search(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('time: $time')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(title.hashCode, time.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Search &&
          other.id == this.id &&
          other.title == this.title &&
          other.time == this.time);
}

class SearchsCompanion extends UpdateCompanion<Search> {
  final Value<int> id;
  final Value<String> title;
  final Value<DateTime> time;
  const SearchsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.time = const Value.absent(),
  });
  SearchsCompanion.insert({
    this.id = const Value.absent(),
    @required String title,
    @required DateTime time,
  })  : title = Value(title),
        time = Value(time);
  static Insertable<Search> custom({
    Expression<int> id,
    Expression<String> title,
    Expression<DateTime> time,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (time != null) 'time': time,
    });
  }

  SearchsCompanion copyWith(
      {Value<int> id, Value<String> title, Value<DateTime> time}) {
    return SearchsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
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
    if (time.present) {
      map['time'] = Variable<DateTime>(time.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchsCompanion(')
          ..write('id: $id, ')
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
  List<GeneratedColumn> get $columns => [id, title, time];
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
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time'], _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
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
  $SearchsTable _searchs;
  $SearchsTable get searchs => _searchs ??= $SearchsTable(this);
  SearchsDao _searchsDao;
  SearchsDao get searchsDao => _searchsDao ??= SearchsDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [searchs];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$SearchsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SearchsTable get searchs => attachedDatabase.searchs;
}
