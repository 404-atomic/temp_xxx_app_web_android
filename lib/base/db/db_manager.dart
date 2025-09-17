import 'package:drift/drift.dart';
import 'package:framework/base/utils/platfrom_utils.dart';
import 'tables/db_kv_tables.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'db_manager.g.dart'; //这里会报错，不过没关系，执行 flutter pub run build_runner build

@DriftDatabase(tables: [DbKeyValue])
class KeyValueDatabase extends _$KeyValueDatabase {
  final String dbname;

  KeyValueDatabase(this.dbname) : super(_openConnection(dbname));

  @override
  int get schemaVersion => 1;

  Future<List<DbKeyValueData>> getAll(String type) async {
    return (dbKeyValue.select()
          ..where((tbl) => tbl.type.equals(type))
          ..orderBy([
            (u) =>
                OrderingTerm(expression: u.updateTime, mode: OrderingMode.desc),
            (u) => OrderingTerm(expression: u.id)
          ]))
        .get();
  }

  Future<DbKeyValueData?> getOne(String key) async {
    return (select(dbKeyValue)..where((tbl) => tbl.key.equals(key)))
        .getSingleOrNull();
  }

  insertOne(DbKeyValueCompanion entry) async {
    return into(dbKeyValue).insert(entry);
  }

  updateOne(DbKeyValueCompanion entry) async {
    return (update(dbKeyValue)..where((tbl) => tbl.key.equals(entry.key.value)))
        .write(entry);
  }

  deleteOne(String key) async {
    return (delete(dbKeyValue)..where((tbl) => tbl.key.equals(key))).go();
  }

  deleteByType(String type) async {
    return (delete(dbKeyValue)..where((tbl) => tbl.type.equals(type))).go();
  }

  deleteByName(String name) async {
    return (delete(dbKeyValue)..where((tbl) => tbl.name.equals(name))).go();
  }

  deleteByCate(String cate) async {
    return (delete(dbKeyValue)..where((tbl) => tbl.cate.equals(cate))).go();
  }

  deleteAll() async {
    return delete(dbKeyValue).go();
  }

  static Map<String, KeyValueDatabase> _dbs = {};

  static KeyValueDatabase getDb(String dbname) {
    if (!_dbs.containsKey(dbname)) {
      _dbs[dbname] = KeyValueDatabase(dbname);
    }
    return _dbs[dbname]!;
  }
}

_openConnection(dbname) {
  if (PlatformUtils.isWeb) {
    return driftDatabase(
        name: dbname,
        web: DriftWebOptions(
          sqlite3Wasm: Uri.parse('sqlite3.wasm'),
          driftWorker: Uri.parse('drift_worker.js'),
        ));
  } else {
    return driftDatabase(name: dbname);
  }
}
