import 'package:drift/drift.dart';

class DbKeyValue extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().named('key')();
  TextColumn get name => text().named('name').nullable()();
  TextColumn get type => text().named('type').nullable()();
  TextColumn get cate => text().named('cate').nullable()();
  TextColumn get value => text().named('value').nullable()();
  TextColumn get extra => text().named('extra').nullable()();
  DateTimeColumn get updateTime => dateTime().nullable()();
  DateTimeColumn get createdTime => dateTime().nullable()();
}
