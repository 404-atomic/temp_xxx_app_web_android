import 'package:drift/backends.dart';

abstract class DatabaseCreator {
  Future<QueryExecutor> createDatabase();
}
