
import 'package:drift/src/runtime/executor/executor.dart';
import 'package:drift/web.dart';
import 'database_creator.dart';

class DatabaseNative implements DatabaseCreator {
  final String dbname;

  DatabaseNative(this.dbname);

  @override
  Future<QueryExecutor> createDatabase() async {
    // final dbFolder = await getApplicationDocumentsDirectory();
    // final file = File(p.join(dbFolder.path, dbname));
    // return NativeDatabase(file);
    var db= WebDatabase.withStorage(DriftWebStorage(dbname));
    return db;
  }
}
