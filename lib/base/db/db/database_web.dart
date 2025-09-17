import 'package:drift/src/runtime/executor/executor.dart';
import 'package:drift/web.dart';

import 'database_creator.dart';

class DatabaseWeb implements DatabaseCreator {
  final String dbname;

  DatabaseWeb(this.dbname);

  @override
  Future<QueryExecutor> createDatabase() async {
    var db = DriftWebStorage(dbname);
    db.open();
    return WebDatabase.withStorage(db);
  }
}
