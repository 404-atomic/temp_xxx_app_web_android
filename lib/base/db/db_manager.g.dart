// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_manager.dart';

// ignore_for_file: type=lint
class $DbKeyValueTable extends DbKeyValue
    with TableInfo<$DbKeyValueTable, DbKeyValueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbKeyValueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cateMeta = const VerificationMeta('cate');
  @override
  late final GeneratedColumn<String> cate = GeneratedColumn<String>(
      'cate', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _extraMeta = const VerificationMeta('extra');
  @override
  late final GeneratedColumn<String> extra = GeneratedColumn<String>(
      'extra', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updateTimeMeta =
      const VerificationMeta('updateTime');
  @override
  late final GeneratedColumn<DateTime> updateTime = GeneratedColumn<DateTime>(
      'update_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdTimeMeta =
      const VerificationMeta('createdTime');
  @override
  late final GeneratedColumn<DateTime> createdTime = GeneratedColumn<DateTime>(
      'created_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, key, name, type, cate, value, extra, updateTime, createdTime];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_key_value';
  @override
  VerificationContext validateIntegrity(Insertable<DbKeyValueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('cate')) {
      context.handle(
          _cateMeta, cate.isAcceptableOrUnknown(data['cate']!, _cateMeta));
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    }
    if (data.containsKey('extra')) {
      context.handle(
          _extraMeta, extra.isAcceptableOrUnknown(data['extra']!, _extraMeta));
    }
    if (data.containsKey('update_time')) {
      context.handle(
          _updateTimeMeta,
          updateTime.isAcceptableOrUnknown(
              data['update_time']!, _updateTimeMeta));
    }
    if (data.containsKey('created_time')) {
      context.handle(
          _createdTimeMeta,
          createdTime.isAcceptableOrUnknown(
              data['created_time']!, _createdTimeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbKeyValueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbKeyValueData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type']),
      cate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cate']),
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value']),
      extra: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extra']),
      updateTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}update_time']),
      createdTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_time']),
    );
  }

  @override
  $DbKeyValueTable createAlias(String alias) {
    return $DbKeyValueTable(attachedDatabase, alias);
  }
}

class DbKeyValueData extends DataClass implements Insertable<DbKeyValueData> {
  final int id;
  final String key;
  final String? name;
  final String? type;
  final String? cate;
  final String? value;
  final String? extra;
  final DateTime? updateTime;
  final DateTime? createdTime;
  const DbKeyValueData(
      {required this.id,
      required this.key,
      this.name,
      this.type,
      this.cate,
      this.value,
      this.extra,
      this.updateTime,
      this.createdTime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || cate != null) {
      map['cate'] = Variable<String>(cate);
    }
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    if (!nullToAbsent || extra != null) {
      map['extra'] = Variable<String>(extra);
    }
    if (!nullToAbsent || updateTime != null) {
      map['update_time'] = Variable<DateTime>(updateTime);
    }
    if (!nullToAbsent || createdTime != null) {
      map['created_time'] = Variable<DateTime>(createdTime);
    }
    return map;
  }

  DbKeyValueCompanion toCompanion(bool nullToAbsent) {
    return DbKeyValueCompanion(
      id: Value(id),
      key: Value(key),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      cate: cate == null && nullToAbsent ? const Value.absent() : Value(cate),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
      extra:
          extra == null && nullToAbsent ? const Value.absent() : Value(extra),
      updateTime: updateTime == null && nullToAbsent
          ? const Value.absent()
          : Value(updateTime),
      createdTime: createdTime == null && nullToAbsent
          ? const Value.absent()
          : Value(createdTime),
    );
  }

  factory DbKeyValueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbKeyValueData(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      name: serializer.fromJson<String?>(json['name']),
      type: serializer.fromJson<String?>(json['type']),
      cate: serializer.fromJson<String?>(json['cate']),
      value: serializer.fromJson<String?>(json['value']),
      extra: serializer.fromJson<String?>(json['extra']),
      updateTime: serializer.fromJson<DateTime?>(json['updateTime']),
      createdTime: serializer.fromJson<DateTime?>(json['createdTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'name': serializer.toJson<String?>(name),
      'type': serializer.toJson<String?>(type),
      'cate': serializer.toJson<String?>(cate),
      'value': serializer.toJson<String?>(value),
      'extra': serializer.toJson<String?>(extra),
      'updateTime': serializer.toJson<DateTime?>(updateTime),
      'createdTime': serializer.toJson<DateTime?>(createdTime),
    };
  }

  DbKeyValueData copyWith(
          {int? id,
          String? key,
          Value<String?> name = const Value.absent(),
          Value<String?> type = const Value.absent(),
          Value<String?> cate = const Value.absent(),
          Value<String?> value = const Value.absent(),
          Value<String?> extra = const Value.absent(),
          Value<DateTime?> updateTime = const Value.absent(),
          Value<DateTime?> createdTime = const Value.absent()}) =>
      DbKeyValueData(
        id: id ?? this.id,
        key: key ?? this.key,
        name: name.present ? name.value : this.name,
        type: type.present ? type.value : this.type,
        cate: cate.present ? cate.value : this.cate,
        value: value.present ? value.value : this.value,
        extra: extra.present ? extra.value : this.extra,
        updateTime: updateTime.present ? updateTime.value : this.updateTime,
        createdTime: createdTime.present ? createdTime.value : this.createdTime,
      );
  DbKeyValueData copyWithCompanion(DbKeyValueCompanion data) {
    return DbKeyValueData(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      cate: data.cate.present ? data.cate.value : this.cate,
      value: data.value.present ? data.value.value : this.value,
      extra: data.extra.present ? data.extra.value : this.extra,
      updateTime:
          data.updateTime.present ? data.updateTime.value : this.updateTime,
      createdTime:
          data.createdTime.present ? data.createdTime.value : this.createdTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbKeyValueData(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('cate: $cate, ')
          ..write('value: $value, ')
          ..write('extra: $extra, ')
          ..write('updateTime: $updateTime, ')
          ..write('createdTime: $createdTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, key, name, type, cate, value, extra, updateTime, createdTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbKeyValueData &&
          other.id == this.id &&
          other.key == this.key &&
          other.name == this.name &&
          other.type == this.type &&
          other.cate == this.cate &&
          other.value == this.value &&
          other.extra == this.extra &&
          other.updateTime == this.updateTime &&
          other.createdTime == this.createdTime);
}

class DbKeyValueCompanion extends UpdateCompanion<DbKeyValueData> {
  final Value<int> id;
  final Value<String> key;
  final Value<String?> name;
  final Value<String?> type;
  final Value<String?> cate;
  final Value<String?> value;
  final Value<String?> extra;
  final Value<DateTime?> updateTime;
  final Value<DateTime?> createdTime;
  const DbKeyValueCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.cate = const Value.absent(),
    this.value = const Value.absent(),
    this.extra = const Value.absent(),
    this.updateTime = const Value.absent(),
    this.createdTime = const Value.absent(),
  });
  DbKeyValueCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.cate = const Value.absent(),
    this.value = const Value.absent(),
    this.extra = const Value.absent(),
    this.updateTime = const Value.absent(),
    this.createdTime = const Value.absent(),
  }) : key = Value(key);
  static Insertable<DbKeyValueData> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? cate,
    Expression<String>? value,
    Expression<String>? extra,
    Expression<DateTime>? updateTime,
    Expression<DateTime>? createdTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (cate != null) 'cate': cate,
      if (value != null) 'value': value,
      if (extra != null) 'extra': extra,
      if (updateTime != null) 'update_time': updateTime,
      if (createdTime != null) 'created_time': createdTime,
    });
  }

  DbKeyValueCompanion copyWith(
      {Value<int>? id,
      Value<String>? key,
      Value<String?>? name,
      Value<String?>? type,
      Value<String?>? cate,
      Value<String?>? value,
      Value<String?>? extra,
      Value<DateTime?>? updateTime,
      Value<DateTime?>? createdTime}) {
    return DbKeyValueCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      name: name ?? this.name,
      type: type ?? this.type,
      cate: cate ?? this.cate,
      value: value ?? this.value,
      extra: extra ?? this.extra,
      updateTime: updateTime ?? this.updateTime,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (cate.present) {
      map['cate'] = Variable<String>(cate.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (extra.present) {
      map['extra'] = Variable<String>(extra.value);
    }
    if (updateTime.present) {
      map['update_time'] = Variable<DateTime>(updateTime.value);
    }
    if (createdTime.present) {
      map['created_time'] = Variable<DateTime>(createdTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbKeyValueCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('cate: $cate, ')
          ..write('value: $value, ')
          ..write('extra: $extra, ')
          ..write('updateTime: $updateTime, ')
          ..write('createdTime: $createdTime')
          ..write(')'))
        .toString();
  }
}

abstract class _$KeyValueDatabase extends GeneratedDatabase {
  _$KeyValueDatabase(QueryExecutor e) : super(e);
  $KeyValueDatabaseManager get managers => $KeyValueDatabaseManager(this);
  late final $DbKeyValueTable dbKeyValue = $DbKeyValueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [dbKeyValue];
}

typedef $$DbKeyValueTableCreateCompanionBuilder = DbKeyValueCompanion Function({
  Value<int> id,
  required String key,
  Value<String?> name,
  Value<String?> type,
  Value<String?> cate,
  Value<String?> value,
  Value<String?> extra,
  Value<DateTime?> updateTime,
  Value<DateTime?> createdTime,
});
typedef $$DbKeyValueTableUpdateCompanionBuilder = DbKeyValueCompanion Function({
  Value<int> id,
  Value<String> key,
  Value<String?> name,
  Value<String?> type,
  Value<String?> cate,
  Value<String?> value,
  Value<String?> extra,
  Value<DateTime?> updateTime,
  Value<DateTime?> createdTime,
});

class $$DbKeyValueTableFilterComposer
    extends FilterComposer<_$KeyValueDatabase, $DbKeyValueTable> {
  $$DbKeyValueTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get key => $state.composableBuilder(
      column: $state.table.key,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get cate => $state.composableBuilder(
      column: $state.table.cate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get extra => $state.composableBuilder(
      column: $state.table.extra,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updateTime => $state.composableBuilder(
      column: $state.table.updateTime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdTime => $state.composableBuilder(
      column: $state.table.createdTime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$DbKeyValueTableOrderingComposer
    extends OrderingComposer<_$KeyValueDatabase, $DbKeyValueTable> {
  $$DbKeyValueTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get key => $state.composableBuilder(
      column: $state.table.key,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get cate => $state.composableBuilder(
      column: $state.table.cate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get extra => $state.composableBuilder(
      column: $state.table.extra,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updateTime => $state.composableBuilder(
      column: $state.table.updateTime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdTime => $state.composableBuilder(
      column: $state.table.createdTime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$DbKeyValueTableTableManager extends RootTableManager<
    _$KeyValueDatabase,
    $DbKeyValueTable,
    DbKeyValueData,
    $$DbKeyValueTableFilterComposer,
    $$DbKeyValueTableOrderingComposer,
    $$DbKeyValueTableCreateCompanionBuilder,
    $$DbKeyValueTableUpdateCompanionBuilder,
    (
      DbKeyValueData,
      BaseReferences<_$KeyValueDatabase, $DbKeyValueTable, DbKeyValueData>
    ),
    DbKeyValueData,
    PrefetchHooks Function()> {
  $$DbKeyValueTableTableManager(_$KeyValueDatabase db, $DbKeyValueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$DbKeyValueTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$DbKeyValueTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> key = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<String?> cate = const Value.absent(),
            Value<String?> value = const Value.absent(),
            Value<String?> extra = const Value.absent(),
            Value<DateTime?> updateTime = const Value.absent(),
            Value<DateTime?> createdTime = const Value.absent(),
          }) =>
              DbKeyValueCompanion(
            id: id,
            key: key,
            name: name,
            type: type,
            cate: cate,
            value: value,
            extra: extra,
            updateTime: updateTime,
            createdTime: createdTime,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String key,
            Value<String?> name = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<String?> cate = const Value.absent(),
            Value<String?> value = const Value.absent(),
            Value<String?> extra = const Value.absent(),
            Value<DateTime?> updateTime = const Value.absent(),
            Value<DateTime?> createdTime = const Value.absent(),
          }) =>
              DbKeyValueCompanion.insert(
            id: id,
            key: key,
            name: name,
            type: type,
            cate: cate,
            value: value,
            extra: extra,
            updateTime: updateTime,
            createdTime: createdTime,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DbKeyValueTableProcessedTableManager = ProcessedTableManager<
    _$KeyValueDatabase,
    $DbKeyValueTable,
    DbKeyValueData,
    $$DbKeyValueTableFilterComposer,
    $$DbKeyValueTableOrderingComposer,
    $$DbKeyValueTableCreateCompanionBuilder,
    $$DbKeyValueTableUpdateCompanionBuilder,
    (
      DbKeyValueData,
      BaseReferences<_$KeyValueDatabase, $DbKeyValueTable, DbKeyValueData>
    ),
    DbKeyValueData,
    PrefetchHooks Function()>;

class $KeyValueDatabaseManager {
  final _$KeyValueDatabase _db;
  $KeyValueDatabaseManager(this._db);
  $$DbKeyValueTableTableManager get dbKeyValue =>
      $$DbKeyValueTableTableManager(_db, _db.dbKeyValue);
}
