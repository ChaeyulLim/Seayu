import 'package:drift/drift.dart';

class WorkLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get weather => text().withDefault(const Constant(''))();
  TextColumn get cropName => text()();
  TextColumn get workContent => text().withDefault(const Constant(''))();
  RealColumn get workers => real().withDefault(const Constant(1.0))();
  IntColumn get dailyWage => integer().withDefault(const Constant(0))();
  TextColumn get workNote => text().withDefault(const Constant(''))();
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

class PestControls extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get cropName => text()();
  TextColumn get cause => text().withDefault(const Constant(''))();
  TextColumn get method => text().withDefault(const Constant(''))();
  TextColumn get result => text().withDefault(const Constant(''))();
  RealColumn get cost => real().withDefault(const Constant(0.0))();
  TextColumn get note => text().withDefault(const Constant(''))();
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

@DataClassName('MaterialItem')
class MaterialItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get content => text().withDefault(const Constant(''))();
  RealColumn get cost => real().withDefault(const Constant(0.0))();
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

class AppSettings extends Table {
  TextColumn get settingKey => text()();
  TextColumn get settingValue => text()();

  @override
  Set<Column> get primaryKey => {settingKey};
}
