// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $WorkLogsTable extends WorkLogs with TableInfo<$WorkLogsTable, WorkLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _weatherMeta =
      const VerificationMeta('weather');
  @override
  late final GeneratedColumn<String> weather = GeneratedColumn<String>(
      'weather', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _cropNameMeta =
      const VerificationMeta('cropName');
  @override
  late final GeneratedColumn<String> cropName = GeneratedColumn<String>(
      'crop_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _workContentMeta =
      const VerificationMeta('workContent');
  @override
  late final GeneratedColumn<String> workContent = GeneratedColumn<String>(
      'work_content', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _workersMeta =
      const VerificationMeta('workers');
  @override
  late final GeneratedColumn<double> workers = GeneratedColumn<double>(
      'workers', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _dailyWageMeta =
      const VerificationMeta('dailyWage');
  @override
  late final GeneratedColumn<int> dailyWage = GeneratedColumn<int>(
      'daily_wage', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _workNoteMeta =
      const VerificationMeta('workNote');
  @override
  late final GeneratedColumn<String> workNote = GeneratedColumn<String>(
      'work_note', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _needsSyncMeta =
      const VerificationMeta('needsSync');
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
      'needs_sync', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("needs_sync" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        date,
        weather,
        cropName,
        workContent,
        workers,
        dailyWage,
        workNote,
        needsSync,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_logs';
  @override
  VerificationContext validateIntegrity(Insertable<WorkLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('weather')) {
      context.handle(_weatherMeta,
          weather.isAcceptableOrUnknown(data['weather']!, _weatherMeta));
    }
    if (data.containsKey('crop_name')) {
      context.handle(_cropNameMeta,
          cropName.isAcceptableOrUnknown(data['crop_name']!, _cropNameMeta));
    } else if (isInserting) {
      context.missing(_cropNameMeta);
    }
    if (data.containsKey('work_content')) {
      context.handle(
          _workContentMeta,
          workContent.isAcceptableOrUnknown(
              data['work_content']!, _workContentMeta));
    }
    if (data.containsKey('workers')) {
      context.handle(_workersMeta,
          workers.isAcceptableOrUnknown(data['workers']!, _workersMeta));
    }
    if (data.containsKey('daily_wage')) {
      context.handle(_dailyWageMeta,
          dailyWage.isAcceptableOrUnknown(data['daily_wage']!, _dailyWageMeta));
    }
    if (data.containsKey('work_note')) {
      context.handle(_workNoteMeta,
          workNote.isAcceptableOrUnknown(data['work_note']!, _workNoteMeta));
    }
    if (data.containsKey('needs_sync')) {
      context.handle(_needsSyncMeta,
          needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      weather: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weather'])!,
      cropName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}crop_name'])!,
      workContent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}work_content'])!,
      workers: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}workers'])!,
      dailyWage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}daily_wage'])!,
      workNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}work_note'])!,
      needsSync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}needs_sync'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $WorkLogsTable createAlias(String alias) {
    return $WorkLogsTable(attachedDatabase, alias);
  }
}

class WorkLog extends DataClass implements Insertable<WorkLog> {
  final int id;
  final DateTime date;
  final String weather;
  final String cropName;
  final String workContent;
  final double workers;
  final int dailyWage;
  final String workNote;
  final bool needsSync;
  final bool isDeleted;
  const WorkLog(
      {required this.id,
      required this.date,
      required this.weather,
      required this.cropName,
      required this.workContent,
      required this.workers,
      required this.dailyWage,
      required this.workNote,
      required this.needsSync,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['weather'] = Variable<String>(weather);
    map['crop_name'] = Variable<String>(cropName);
    map['work_content'] = Variable<String>(workContent);
    map['workers'] = Variable<double>(workers);
    map['daily_wage'] = Variable<int>(dailyWage);
    map['work_note'] = Variable<String>(workNote);
    map['needs_sync'] = Variable<bool>(needsSync);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  WorkLogsCompanion toCompanion(bool nullToAbsent) {
    return WorkLogsCompanion(
      id: Value(id),
      date: Value(date),
      weather: Value(weather),
      cropName: Value(cropName),
      workContent: Value(workContent),
      workers: Value(workers),
      dailyWage: Value(dailyWage),
      workNote: Value(workNote),
      needsSync: Value(needsSync),
      isDeleted: Value(isDeleted),
    );
  }

  factory WorkLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      weather: serializer.fromJson<String>(json['weather']),
      cropName: serializer.fromJson<String>(json['cropName']),
      workContent: serializer.fromJson<String>(json['workContent']),
      workers: serializer.fromJson<double>(json['workers']),
      dailyWage: serializer.fromJson<int>(json['dailyWage']),
      workNote: serializer.fromJson<String>(json['workNote']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'weather': serializer.toJson<String>(weather),
      'cropName': serializer.toJson<String>(cropName),
      'workContent': serializer.toJson<String>(workContent),
      'workers': serializer.toJson<double>(workers),
      'dailyWage': serializer.toJson<int>(dailyWage),
      'workNote': serializer.toJson<String>(workNote),
      'needsSync': serializer.toJson<bool>(needsSync),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  WorkLog copyWith(
          {int? id,
          DateTime? date,
          String? weather,
          String? cropName,
          String? workContent,
          double? workers,
          int? dailyWage,
          String? workNote,
          bool? needsSync,
          bool? isDeleted}) =>
      WorkLog(
        id: id ?? this.id,
        date: date ?? this.date,
        weather: weather ?? this.weather,
        cropName: cropName ?? this.cropName,
        workContent: workContent ?? this.workContent,
        workers: workers ?? this.workers,
        dailyWage: dailyWage ?? this.dailyWage,
        workNote: workNote ?? this.workNote,
        needsSync: needsSync ?? this.needsSync,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  WorkLog copyWithCompanion(WorkLogsCompanion data) {
    return WorkLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      weather: data.weather.present ? data.weather.value : this.weather,
      cropName: data.cropName.present ? data.cropName.value : this.cropName,
      workContent:
          data.workContent.present ? data.workContent.value : this.workContent,
      workers: data.workers.present ? data.workers.value : this.workers,
      dailyWage: data.dailyWage.present ? data.dailyWage.value : this.dailyWage,
      workNote: data.workNote.present ? data.workNote.value : this.workNote,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weather: $weather, ')
          ..write('cropName: $cropName, ')
          ..write('workContent: $workContent, ')
          ..write('workers: $workers, ')
          ..write('dailyWage: $dailyWage, ')
          ..write('workNote: $workNote, ')
          ..write('needsSync: $needsSync, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, weather, cropName, workContent,
      workers, dailyWage, workNote, needsSync, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.weather == this.weather &&
          other.cropName == this.cropName &&
          other.workContent == this.workContent &&
          other.workers == this.workers &&
          other.dailyWage == this.dailyWage &&
          other.workNote == this.workNote &&
          other.needsSync == this.needsSync &&
          other.isDeleted == this.isDeleted);
}

class WorkLogsCompanion extends UpdateCompanion<WorkLog> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> weather;
  final Value<String> cropName;
  final Value<String> workContent;
  final Value<double> workers;
  final Value<int> dailyWage;
  final Value<String> workNote;
  final Value<bool> needsSync;
  final Value<bool> isDeleted;
  const WorkLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.weather = const Value.absent(),
    this.cropName = const Value.absent(),
    this.workContent = const Value.absent(),
    this.workers = const Value.absent(),
    this.dailyWage = const Value.absent(),
    this.workNote = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  WorkLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.weather = const Value.absent(),
    required String cropName,
    this.workContent = const Value.absent(),
    this.workers = const Value.absent(),
    this.dailyWage = const Value.absent(),
    this.workNote = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.isDeleted = const Value.absent(),
  })  : date = Value(date),
        cropName = Value(cropName);
  static Insertable<WorkLog> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? weather,
    Expression<String>? cropName,
    Expression<String>? workContent,
    Expression<double>? workers,
    Expression<int>? dailyWage,
    Expression<String>? workNote,
    Expression<bool>? needsSync,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (weather != null) 'weather': weather,
      if (cropName != null) 'crop_name': cropName,
      if (workContent != null) 'work_content': workContent,
      if (workers != null) 'workers': workers,
      if (dailyWage != null) 'daily_wage': dailyWage,
      if (workNote != null) 'work_note': workNote,
      if (needsSync != null) 'needs_sync': needsSync,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  WorkLogsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<String>? weather,
      Value<String>? cropName,
      Value<String>? workContent,
      Value<double>? workers,
      Value<int>? dailyWage,
      Value<String>? workNote,
      Value<bool>? needsSync,
      Value<bool>? isDeleted}) {
    return WorkLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      weather: weather ?? this.weather,
      cropName: cropName ?? this.cropName,
      workContent: workContent ?? this.workContent,
      workers: workers ?? this.workers,
      dailyWage: dailyWage ?? this.dailyWage,
      workNote: workNote ?? this.workNote,
      needsSync: needsSync ?? this.needsSync,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (weather.present) {
      map['weather'] = Variable<String>(weather.value);
    }
    if (cropName.present) {
      map['crop_name'] = Variable<String>(cropName.value);
    }
    if (workContent.present) {
      map['work_content'] = Variable<String>(workContent.value);
    }
    if (workers.present) {
      map['workers'] = Variable<double>(workers.value);
    }
    if (dailyWage.present) {
      map['daily_wage'] = Variable<int>(dailyWage.value);
    }
    if (workNote.present) {
      map['work_note'] = Variable<String>(workNote.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weather: $weather, ')
          ..write('cropName: $cropName, ')
          ..write('workContent: $workContent, ')
          ..write('workers: $workers, ')
          ..write('dailyWage: $dailyWage, ')
          ..write('workNote: $workNote, ')
          ..write('needsSync: $needsSync, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $PestControlsTable extends PestControls
    with TableInfo<$PestControlsTable, PestControl> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PestControlsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _cropNameMeta =
      const VerificationMeta('cropName');
  @override
  late final GeneratedColumn<String> cropName = GeneratedColumn<String>(
      'crop_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _causeMeta = const VerificationMeta('cause');
  @override
  late final GeneratedColumn<String> cause = GeneratedColumn<String>(
      'cause', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
      'result', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
      'cost', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _needsSyncMeta =
      const VerificationMeta('needsSync');
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
      'needs_sync', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("needs_sync" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        date,
        cropName,
        cause,
        method,
        result,
        cost,
        note,
        needsSync,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pest_controls';
  @override
  VerificationContext validateIntegrity(Insertable<PestControl> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('crop_name')) {
      context.handle(_cropNameMeta,
          cropName.isAcceptableOrUnknown(data['crop_name']!, _cropNameMeta));
    } else if (isInserting) {
      context.missing(_cropNameMeta);
    }
    if (data.containsKey('cause')) {
      context.handle(
          _causeMeta, cause.isAcceptableOrUnknown(data['cause']!, _causeMeta));
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    }
    if (data.containsKey('result')) {
      context.handle(_resultMeta,
          result.isAcceptableOrUnknown(data['result']!, _resultMeta));
    }
    if (data.containsKey('cost')) {
      context.handle(
          _costMeta, cost.isAcceptableOrUnknown(data['cost']!, _costMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('needs_sync')) {
      context.handle(_needsSyncMeta,
          needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PestControl map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PestControl(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      cropName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}crop_name'])!,
      cause: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cause'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
      result: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}result'])!,
      cost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      needsSync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}needs_sync'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $PestControlsTable createAlias(String alias) {
    return $PestControlsTable(attachedDatabase, alias);
  }
}

class PestControl extends DataClass implements Insertable<PestControl> {
  final int id;
  final DateTime date;
  final String cropName;
  final String cause;
  final String method;
  final String result;
  final double cost;
  final String note;
  final bool needsSync;
  final bool isDeleted;
  const PestControl(
      {required this.id,
      required this.date,
      required this.cropName,
      required this.cause,
      required this.method,
      required this.result,
      required this.cost,
      required this.note,
      required this.needsSync,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['crop_name'] = Variable<String>(cropName);
    map['cause'] = Variable<String>(cause);
    map['method'] = Variable<String>(method);
    map['result'] = Variable<String>(result);
    map['cost'] = Variable<double>(cost);
    map['note'] = Variable<String>(note);
    map['needs_sync'] = Variable<bool>(needsSync);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  PestControlsCompanion toCompanion(bool nullToAbsent) {
    return PestControlsCompanion(
      id: Value(id),
      date: Value(date),
      cropName: Value(cropName),
      cause: Value(cause),
      method: Value(method),
      result: Value(result),
      cost: Value(cost),
      note: Value(note),
      needsSync: Value(needsSync),
      isDeleted: Value(isDeleted),
    );
  }

  factory PestControl.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PestControl(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      cropName: serializer.fromJson<String>(json['cropName']),
      cause: serializer.fromJson<String>(json['cause']),
      method: serializer.fromJson<String>(json['method']),
      result: serializer.fromJson<String>(json['result']),
      cost: serializer.fromJson<double>(json['cost']),
      note: serializer.fromJson<String>(json['note']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'cropName': serializer.toJson<String>(cropName),
      'cause': serializer.toJson<String>(cause),
      'method': serializer.toJson<String>(method),
      'result': serializer.toJson<String>(result),
      'cost': serializer.toJson<double>(cost),
      'note': serializer.toJson<String>(note),
      'needsSync': serializer.toJson<bool>(needsSync),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  PestControl copyWith(
          {int? id,
          DateTime? date,
          String? cropName,
          String? cause,
          String? method,
          String? result,
          double? cost,
          String? note,
          bool? needsSync,
          bool? isDeleted}) =>
      PestControl(
        id: id ?? this.id,
        date: date ?? this.date,
        cropName: cropName ?? this.cropName,
        cause: cause ?? this.cause,
        method: method ?? this.method,
        result: result ?? this.result,
        cost: cost ?? this.cost,
        note: note ?? this.note,
        needsSync: needsSync ?? this.needsSync,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  PestControl copyWithCompanion(PestControlsCompanion data) {
    return PestControl(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      cropName: data.cropName.present ? data.cropName.value : this.cropName,
      cause: data.cause.present ? data.cause.value : this.cause,
      method: data.method.present ? data.method.value : this.method,
      result: data.result.present ? data.result.value : this.result,
      cost: data.cost.present ? data.cost.value : this.cost,
      note: data.note.present ? data.note.value : this.note,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PestControl(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('cropName: $cropName, ')
          ..write('cause: $cause, ')
          ..write('method: $method, ')
          ..write('result: $result, ')
          ..write('cost: $cost, ')
          ..write('note: $note, ')
          ..write('needsSync: $needsSync, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, cropName, cause, method, result,
      cost, note, needsSync, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PestControl &&
          other.id == this.id &&
          other.date == this.date &&
          other.cropName == this.cropName &&
          other.cause == this.cause &&
          other.method == this.method &&
          other.result == this.result &&
          other.cost == this.cost &&
          other.note == this.note &&
          other.needsSync == this.needsSync &&
          other.isDeleted == this.isDeleted);
}

class PestControlsCompanion extends UpdateCompanion<PestControl> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> cropName;
  final Value<String> cause;
  final Value<String> method;
  final Value<String> result;
  final Value<double> cost;
  final Value<String> note;
  final Value<bool> needsSync;
  final Value<bool> isDeleted;
  const PestControlsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.cropName = const Value.absent(),
    this.cause = const Value.absent(),
    this.method = const Value.absent(),
    this.result = const Value.absent(),
    this.cost = const Value.absent(),
    this.note = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  PestControlsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String cropName,
    this.cause = const Value.absent(),
    this.method = const Value.absent(),
    this.result = const Value.absent(),
    this.cost = const Value.absent(),
    this.note = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.isDeleted = const Value.absent(),
  })  : date = Value(date),
        cropName = Value(cropName);
  static Insertable<PestControl> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? cropName,
    Expression<String>? cause,
    Expression<String>? method,
    Expression<String>? result,
    Expression<double>? cost,
    Expression<String>? note,
    Expression<bool>? needsSync,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (cropName != null) 'crop_name': cropName,
      if (cause != null) 'cause': cause,
      if (method != null) 'method': method,
      if (result != null) 'result': result,
      if (cost != null) 'cost': cost,
      if (note != null) 'note': note,
      if (needsSync != null) 'needs_sync': needsSync,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  PestControlsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<String>? cropName,
      Value<String>? cause,
      Value<String>? method,
      Value<String>? result,
      Value<double>? cost,
      Value<String>? note,
      Value<bool>? needsSync,
      Value<bool>? isDeleted}) {
    return PestControlsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      cropName: cropName ?? this.cropName,
      cause: cause ?? this.cause,
      method: method ?? this.method,
      result: result ?? this.result,
      cost: cost ?? this.cost,
      note: note ?? this.note,
      needsSync: needsSync ?? this.needsSync,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (cropName.present) {
      map['crop_name'] = Variable<String>(cropName.value);
    }
    if (cause.present) {
      map['cause'] = Variable<String>(cause.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PestControlsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('cropName: $cropName, ')
          ..write('cause: $cause, ')
          ..write('method: $method, ')
          ..write('result: $result, ')
          ..write('cost: $cost, ')
          ..write('note: $note, ')
          ..write('needsSync: $needsSync, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $MaterialItemsTable extends MaterialItems
    with TableInfo<$MaterialItemsTable, MaterialItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaterialItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
      'cost', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _needsSyncMeta =
      const VerificationMeta('needsSync');
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
      'needs_sync', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("needs_sync" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, content, cost, needsSync, isDeleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'material_items';
  @override
  VerificationContext validateIntegrity(Insertable<MaterialItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    }
    if (data.containsKey('cost')) {
      context.handle(
          _costMeta, cost.isAcceptableOrUnknown(data['cost']!, _costMeta));
    }
    if (data.containsKey('needs_sync')) {
      context.handle(_needsSyncMeta,
          needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaterialItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaterialItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      cost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost'])!,
      needsSync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}needs_sync'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $MaterialItemsTable createAlias(String alias) {
    return $MaterialItemsTable(attachedDatabase, alias);
  }
}

class MaterialItem extends DataClass implements Insertable<MaterialItem> {
  final int id;
  final DateTime date;
  final String content;
  final double cost;
  final bool needsSync;
  final bool isDeleted;
  const MaterialItem(
      {required this.id,
      required this.date,
      required this.content,
      required this.cost,
      required this.needsSync,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['content'] = Variable<String>(content);
    map['cost'] = Variable<double>(cost);
    map['needs_sync'] = Variable<bool>(needsSync);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  MaterialItemsCompanion toCompanion(bool nullToAbsent) {
    return MaterialItemsCompanion(
      id: Value(id),
      date: Value(date),
      content: Value(content),
      cost: Value(cost),
      needsSync: Value(needsSync),
      isDeleted: Value(isDeleted),
    );
  }

  factory MaterialItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaterialItem(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      content: serializer.fromJson<String>(json['content']),
      cost: serializer.fromJson<double>(json['cost']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'content': serializer.toJson<String>(content),
      'cost': serializer.toJson<double>(cost),
      'needsSync': serializer.toJson<bool>(needsSync),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  MaterialItem copyWith(
          {int? id,
          DateTime? date,
          String? content,
          double? cost,
          bool? needsSync,
          bool? isDeleted}) =>
      MaterialItem(
        id: id ?? this.id,
        date: date ?? this.date,
        content: content ?? this.content,
        cost: cost ?? this.cost,
        needsSync: needsSync ?? this.needsSync,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  MaterialItem copyWithCompanion(MaterialItemsCompanion data) {
    return MaterialItem(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      content: data.content.present ? data.content.value : this.content,
      cost: data.cost.present ? data.cost.value : this.cost,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaterialItem(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('content: $content, ')
          ..write('cost: $cost, ')
          ..write('needsSync: $needsSync, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, content, cost, needsSync, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaterialItem &&
          other.id == this.id &&
          other.date == this.date &&
          other.content == this.content &&
          other.cost == this.cost &&
          other.needsSync == this.needsSync &&
          other.isDeleted == this.isDeleted);
}

class MaterialItemsCompanion extends UpdateCompanion<MaterialItem> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> content;
  final Value<double> cost;
  final Value<bool> needsSync;
  final Value<bool> isDeleted;
  const MaterialItemsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.content = const Value.absent(),
    this.cost = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  MaterialItemsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.content = const Value.absent(),
    this.cost = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : date = Value(date);
  static Insertable<MaterialItem> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? content,
    Expression<double>? cost,
    Expression<bool>? needsSync,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (content != null) 'content': content,
      if (cost != null) 'cost': cost,
      if (needsSync != null) 'needs_sync': needsSync,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  MaterialItemsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<String>? content,
      Value<double>? cost,
      Value<bool>? needsSync,
      Value<bool>? isDeleted}) {
    return MaterialItemsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      content: content ?? this.content,
      cost: cost ?? this.cost,
      needsSync: needsSync ?? this.needsSync,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaterialItemsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('content: $content, ')
          ..write('cost: $cost, ')
          ..write('needsSync: $needsSync, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _settingKeyMeta =
      const VerificationMeta('settingKey');
  @override
  late final GeneratedColumn<String> settingKey = GeneratedColumn<String>(
      'setting_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _settingValueMeta =
      const VerificationMeta('settingValue');
  @override
  late final GeneratedColumn<String> settingValue = GeneratedColumn<String>(
      'setting_value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [settingKey, settingValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('setting_key')) {
      context.handle(
          _settingKeyMeta,
          settingKey.isAcceptableOrUnknown(
              data['setting_key']!, _settingKeyMeta));
    } else if (isInserting) {
      context.missing(_settingKeyMeta);
    }
    if (data.containsKey('setting_value')) {
      context.handle(
          _settingValueMeta,
          settingValue.isAcceptableOrUnknown(
              data['setting_value']!, _settingValueMeta));
    } else if (isInserting) {
      context.missing(_settingValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {settingKey};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      settingKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}setting_key'])!,
      settingValue: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}setting_value'])!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String settingKey;
  final String settingValue;
  const AppSetting({required this.settingKey, required this.settingValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['setting_key'] = Variable<String>(settingKey);
    map['setting_value'] = Variable<String>(settingValue);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      settingKey: Value(settingKey),
      settingValue: Value(settingValue),
    );
  }

  factory AppSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      settingKey: serializer.fromJson<String>(json['settingKey']),
      settingValue: serializer.fromJson<String>(json['settingValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'settingKey': serializer.toJson<String>(settingKey),
      'settingValue': serializer.toJson<String>(settingValue),
    };
  }

  AppSetting copyWith({String? settingKey, String? settingValue}) => AppSetting(
        settingKey: settingKey ?? this.settingKey,
        settingValue: settingValue ?? this.settingValue,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      settingKey:
          data.settingKey.present ? data.settingKey.value : this.settingKey,
      settingValue: data.settingValue.present
          ? data.settingValue.value
          : this.settingValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(settingKey, settingValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.settingKey == this.settingKey &&
          other.settingValue == this.settingValue);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> settingKey;
  final Value<String> settingValue;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.settingKey = const Value.absent(),
    this.settingValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String settingKey,
    required String settingValue,
    this.rowid = const Value.absent(),
  })  : settingKey = Value(settingKey),
        settingValue = Value(settingValue);
  static Insertable<AppSetting> custom({
    Expression<String>? settingKey,
    Expression<String>? settingValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (settingKey != null) 'setting_key': settingKey,
      if (settingValue != null) 'setting_value': settingValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<String>? settingKey,
      Value<String>? settingValue,
      Value<int>? rowid}) {
    return AppSettingsCompanion(
      settingKey: settingKey ?? this.settingKey,
      settingValue: settingValue ?? this.settingValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (settingKey.present) {
      map['setting_key'] = Variable<String>(settingKey.value);
    }
    if (settingValue.present) {
      map['setting_value'] = Variable<String>(settingValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorkLogsTable workLogs = $WorkLogsTable(this);
  late final $PestControlsTable pestControls = $PestControlsTable(this);
  late final $MaterialItemsTable materialItems = $MaterialItemsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [workLogs, pestControls, materialItems, appSettings];
}

typedef $$WorkLogsTableCreateCompanionBuilder = WorkLogsCompanion Function({
  Value<int> id,
  required DateTime date,
  Value<String> weather,
  required String cropName,
  Value<String> workContent,
  Value<double> workers,
  Value<int> dailyWage,
  Value<String> workNote,
  Value<bool> needsSync,
  Value<bool> isDeleted,
});
typedef $$WorkLogsTableUpdateCompanionBuilder = WorkLogsCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  Value<String> weather,
  Value<String> cropName,
  Value<String> workContent,
  Value<double> workers,
  Value<int> dailyWage,
  Value<String> workNote,
  Value<bool> needsSync,
  Value<bool> isDeleted,
});

class $$WorkLogsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkLogsTable> {
  $$WorkLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weather => $composableBuilder(
      column: $table.weather, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cropName => $composableBuilder(
      column: $table.cropName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workContent => $composableBuilder(
      column: $table.workContent, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get workers => $composableBuilder(
      column: $table.workers, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dailyWage => $composableBuilder(
      column: $table.dailyWage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workNote => $composableBuilder(
      column: $table.workNote, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get needsSync => $composableBuilder(
      column: $table.needsSync, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$WorkLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkLogsTable> {
  $$WorkLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weather => $composableBuilder(
      column: $table.weather, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cropName => $composableBuilder(
      column: $table.cropName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workContent => $composableBuilder(
      column: $table.workContent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get workers => $composableBuilder(
      column: $table.workers, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dailyWage => $composableBuilder(
      column: $table.dailyWage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workNote => $composableBuilder(
      column: $table.workNote, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get needsSync => $composableBuilder(
      column: $table.needsSync, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$WorkLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkLogsTable> {
  $$WorkLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get weather =>
      $composableBuilder(column: $table.weather, builder: (column) => column);

  GeneratedColumn<String> get cropName =>
      $composableBuilder(column: $table.cropName, builder: (column) => column);

  GeneratedColumn<String> get workContent => $composableBuilder(
      column: $table.workContent, builder: (column) => column);

  GeneratedColumn<double> get workers =>
      $composableBuilder(column: $table.workers, builder: (column) => column);

  GeneratedColumn<int> get dailyWage =>
      $composableBuilder(column: $table.dailyWage, builder: (column) => column);

  GeneratedColumn<String> get workNote =>
      $composableBuilder(column: $table.workNote, builder: (column) => column);

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$WorkLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkLogsTable,
    WorkLog,
    $$WorkLogsTableFilterComposer,
    $$WorkLogsTableOrderingComposer,
    $$WorkLogsTableAnnotationComposer,
    $$WorkLogsTableCreateCompanionBuilder,
    $$WorkLogsTableUpdateCompanionBuilder,
    (WorkLog, BaseReferences<_$AppDatabase, $WorkLogsTable, WorkLog>),
    WorkLog,
    PrefetchHooks Function()> {
  $$WorkLogsTableTableManager(_$AppDatabase db, $WorkLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> weather = const Value.absent(),
            Value<String> cropName = const Value.absent(),
            Value<String> workContent = const Value.absent(),
            Value<double> workers = const Value.absent(),
            Value<int> dailyWage = const Value.absent(),
            Value<String> workNote = const Value.absent(),
            Value<bool> needsSync = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
          }) =>
              WorkLogsCompanion(
            id: id,
            date: date,
            weather: weather,
            cropName: cropName,
            workContent: workContent,
            workers: workers,
            dailyWage: dailyWage,
            workNote: workNote,
            needsSync: needsSync,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            Value<String> weather = const Value.absent(),
            required String cropName,
            Value<String> workContent = const Value.absent(),
            Value<double> workers = const Value.absent(),
            Value<int> dailyWage = const Value.absent(),
            Value<String> workNote = const Value.absent(),
            Value<bool> needsSync = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
          }) =>
              WorkLogsCompanion.insert(
            id: id,
            date: date,
            weather: weather,
            cropName: cropName,
            workContent: workContent,
            workers: workers,
            dailyWage: dailyWage,
            workNote: workNote,
            needsSync: needsSync,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WorkLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkLogsTable,
    WorkLog,
    $$WorkLogsTableFilterComposer,
    $$WorkLogsTableOrderingComposer,
    $$WorkLogsTableAnnotationComposer,
    $$WorkLogsTableCreateCompanionBuilder,
    $$WorkLogsTableUpdateCompanionBuilder,
    (WorkLog, BaseReferences<_$AppDatabase, $WorkLogsTable, WorkLog>),
    WorkLog,
    PrefetchHooks Function()>;
typedef $$PestControlsTableCreateCompanionBuilder = PestControlsCompanion
    Function({
  Value<int> id,
  required DateTime date,
  required String cropName,
  Value<String> cause,
  Value<String> method,
  Value<String> result,
  Value<double> cost,
  Value<String> note,
  Value<bool> needsSync,
  Value<bool> isDeleted,
});
typedef $$PestControlsTableUpdateCompanionBuilder = PestControlsCompanion
    Function({
  Value<int> id,
  Value<DateTime> date,
  Value<String> cropName,
  Value<String> cause,
  Value<String> method,
  Value<String> result,
  Value<double> cost,
  Value<String> note,
  Value<bool> needsSync,
  Value<bool> isDeleted,
});

class $$PestControlsTableFilterComposer
    extends Composer<_$AppDatabase, $PestControlsTable> {
  $$PestControlsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cropName => $composableBuilder(
      column: $table.cropName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cause => $composableBuilder(
      column: $table.cause, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get result => $composableBuilder(
      column: $table.result, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cost => $composableBuilder(
      column: $table.cost, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get needsSync => $composableBuilder(
      column: $table.needsSync, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$PestControlsTableOrderingComposer
    extends Composer<_$AppDatabase, $PestControlsTable> {
  $$PestControlsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cropName => $composableBuilder(
      column: $table.cropName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cause => $composableBuilder(
      column: $table.cause, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get result => $composableBuilder(
      column: $table.result, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cost => $composableBuilder(
      column: $table.cost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get needsSync => $composableBuilder(
      column: $table.needsSync, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$PestControlsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PestControlsTable> {
  $$PestControlsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get cropName =>
      $composableBuilder(column: $table.cropName, builder: (column) => column);

  GeneratedColumn<String> get cause =>
      $composableBuilder(column: $table.cause, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<double> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$PestControlsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PestControlsTable,
    PestControl,
    $$PestControlsTableFilterComposer,
    $$PestControlsTableOrderingComposer,
    $$PestControlsTableAnnotationComposer,
    $$PestControlsTableCreateCompanionBuilder,
    $$PestControlsTableUpdateCompanionBuilder,
    (
      PestControl,
      BaseReferences<_$AppDatabase, $PestControlsTable, PestControl>
    ),
    PestControl,
    PrefetchHooks Function()> {
  $$PestControlsTableTableManager(_$AppDatabase db, $PestControlsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PestControlsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PestControlsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PestControlsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> cropName = const Value.absent(),
            Value<String> cause = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<String> result = const Value.absent(),
            Value<double> cost = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<bool> needsSync = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
          }) =>
              PestControlsCompanion(
            id: id,
            date: date,
            cropName: cropName,
            cause: cause,
            method: method,
            result: result,
            cost: cost,
            note: note,
            needsSync: needsSync,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            required String cropName,
            Value<String> cause = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<String> result = const Value.absent(),
            Value<double> cost = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<bool> needsSync = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
          }) =>
              PestControlsCompanion.insert(
            id: id,
            date: date,
            cropName: cropName,
            cause: cause,
            method: method,
            result: result,
            cost: cost,
            note: note,
            needsSync: needsSync,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PestControlsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PestControlsTable,
    PestControl,
    $$PestControlsTableFilterComposer,
    $$PestControlsTableOrderingComposer,
    $$PestControlsTableAnnotationComposer,
    $$PestControlsTableCreateCompanionBuilder,
    $$PestControlsTableUpdateCompanionBuilder,
    (
      PestControl,
      BaseReferences<_$AppDatabase, $PestControlsTable, PestControl>
    ),
    PestControl,
    PrefetchHooks Function()>;
typedef $$MaterialItemsTableCreateCompanionBuilder = MaterialItemsCompanion
    Function({
  Value<int> id,
  required DateTime date,
  Value<String> content,
  Value<double> cost,
  Value<bool> needsSync,
  Value<bool> isDeleted,
});
typedef $$MaterialItemsTableUpdateCompanionBuilder = MaterialItemsCompanion
    Function({
  Value<int> id,
  Value<DateTime> date,
  Value<String> content,
  Value<double> cost,
  Value<bool> needsSync,
  Value<bool> isDeleted,
});

class $$MaterialItemsTableFilterComposer
    extends Composer<_$AppDatabase, $MaterialItemsTable> {
  $$MaterialItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cost => $composableBuilder(
      column: $table.cost, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get needsSync => $composableBuilder(
      column: $table.needsSync, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$MaterialItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $MaterialItemsTable> {
  $$MaterialItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cost => $composableBuilder(
      column: $table.cost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get needsSync => $composableBuilder(
      column: $table.needsSync, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$MaterialItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaterialItemsTable> {
  $$MaterialItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<double> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$MaterialItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MaterialItemsTable,
    MaterialItem,
    $$MaterialItemsTableFilterComposer,
    $$MaterialItemsTableOrderingComposer,
    $$MaterialItemsTableAnnotationComposer,
    $$MaterialItemsTableCreateCompanionBuilder,
    $$MaterialItemsTableUpdateCompanionBuilder,
    (
      MaterialItem,
      BaseReferences<_$AppDatabase, $MaterialItemsTable, MaterialItem>
    ),
    MaterialItem,
    PrefetchHooks Function()> {
  $$MaterialItemsTableTableManager(_$AppDatabase db, $MaterialItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaterialItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaterialItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaterialItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<double> cost = const Value.absent(),
            Value<bool> needsSync = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
          }) =>
              MaterialItemsCompanion(
            id: id,
            date: date,
            content: content,
            cost: cost,
            needsSync: needsSync,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            Value<String> content = const Value.absent(),
            Value<double> cost = const Value.absent(),
            Value<bool> needsSync = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
          }) =>
              MaterialItemsCompanion.insert(
            id: id,
            date: date,
            content: content,
            cost: cost,
            needsSync: needsSync,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MaterialItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MaterialItemsTable,
    MaterialItem,
    $$MaterialItemsTableFilterComposer,
    $$MaterialItemsTableOrderingComposer,
    $$MaterialItemsTableAnnotationComposer,
    $$MaterialItemsTableCreateCompanionBuilder,
    $$MaterialItemsTableUpdateCompanionBuilder,
    (
      MaterialItem,
      BaseReferences<_$AppDatabase, $MaterialItemsTable, MaterialItem>
    ),
    MaterialItem,
    PrefetchHooks Function()>;
typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  required String settingKey,
  required String settingValue,
  Value<int> rowid,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<String> settingKey,
  Value<String> settingValue,
  Value<int> rowid,
});

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get settingKey => $composableBuilder(
      column: $table.settingKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get settingValue => $composableBuilder(
      column: $table.settingValue, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get settingKey => $composableBuilder(
      column: $table.settingKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get settingValue => $composableBuilder(
      column: $table.settingValue,
      builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get settingKey => $composableBuilder(
      column: $table.settingKey, builder: (column) => column);

  GeneratedColumn<String> get settingValue => $composableBuilder(
      column: $table.settingValue, builder: (column) => column);
}

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> settingKey = const Value.absent(),
            Value<String> settingValue = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            settingKey: settingKey,
            settingValue: settingValue,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String settingKey,
            required String settingValue,
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion.insert(
            settingKey: settingKey,
            settingValue: settingValue,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkLogsTableTableManager get workLogs =>
      $$WorkLogsTableTableManager(_db, _db.workLogs);
  $$PestControlsTableTableManager get pestControls =>
      $$PestControlsTableTableManager(_db, _db.pestControls);
  $$MaterialItemsTableTableManager get materialItems =>
      $$MaterialItemsTableTableManager(_db, _db.materialItems);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
