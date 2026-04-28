import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [WorkLogs, PestControls, MaterialItems, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await customStatement(
          'ALTER TABLE work_logs ADD COLUMN is_deleted INTEGER NOT NULL DEFAULT 0',
        );
        await customStatement(
          'ALTER TABLE pest_controls ADD COLUMN is_deleted INTEGER NOT NULL DEFAULT 0',
        );
        await customStatement(
          'ALTER TABLE material_items ADD COLUMN is_deleted INTEGER NOT NULL DEFAULT 0',
        );
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'seayu_db',
      web: kIsWeb
          ? DriftWebOptions(
              sqlite3Wasm: Uri.parse('sqlite3.wasm'),
              driftWorker: Uri.parse('drift_worker.js'),
            )
          : null,
    );
  }

  // ── WorkLogs ──────────────────────────────────────────────────────────────

  Stream<List<WorkLog>> watchWorkLogsForDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (select(workLogs)
          ..where(
            (t) =>
                t.date.isBiggerOrEqualValue(start) &
                t.date.isSmallerThanValue(end) &
                t.isDeleted.equals(false),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .watch();
  }

  Future<List<WorkLog>> getWorkLogsForDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (select(workLogs)
          ..where(
            (t) =>
                t.date.isBiggerOrEqualValue(start) &
                t.date.isSmallerThanValue(end),
          ))
        .get();
  }

  Future<List<WorkLog>> getWorkLogsForYear(int year) {
    final start = DateTime(year);
    final end = DateTime(year + 1);
    return (select(workLogs)
          ..where(
            (t) =>
                t.date.isBiggerOrEqualValue(start) &
                t.date.isSmallerThanValue(end),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
  }

  Future<WorkLog?> getWorkLogById(int id) =>
      (select(workLogs)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<PestControl?> getPestControlById(int id) =>
      (select(pestControls)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<MaterialItem?> getMaterialItemById(int id) =>
      (select(materialItems)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<WorkLog>> getUnsyncedWorkLogs() =>
      (select(workLogs)..where((t) => t.needsSync.equals(true))).get();

  Future<int> insertWorkLog(WorkLogsCompanion entry) =>
      into(workLogs).insert(entry);

  Future<bool> updateWorkLog(WorkLog entry) =>
      update(workLogs).replace(entry);

  Future<int> deleteWorkLog(int id) =>
      (delete(workLogs)..where((t) => t.id.equals(id))).go();

  Future<void> softDeleteWorkLog(int id) =>
      (update(workLogs)..where((t) => t.id.equals(id)))
          .write(const WorkLogsCompanion(
            isDeleted: Value(true),
            needsSync: Value(true),
          ));

  Future<void> markWorkLogsSynced(List<int> ids) =>
      (update(workLogs)..where((t) => t.id.isIn(ids)))
          .write(const WorkLogsCompanion(needsSync: Value(false)));

  // ── PestControls ──────────────────────────────────────────────────────────

  Stream<List<PestControl>> watchPestControlsForDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (select(pestControls)
          ..where(
            (t) =>
                t.date.isBiggerOrEqualValue(start) &
                t.date.isSmallerThanValue(end) &
                t.isDeleted.equals(false),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .watch();
  }

  Future<List<PestControl>> getPestControlsForDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (select(pestControls)
          ..where(
            (t) =>
                t.date.isBiggerOrEqualValue(start) &
                t.date.isSmallerThanValue(end),
          ))
        .get();
  }

  Future<List<PestControl>> getPestControlsForYear(int year) {
    final start = DateTime(year);
    final end = DateTime(year + 1);
    return (select(pestControls)
          ..where(
            (t) =>
                t.date.isBiggerOrEqualValue(start) &
                t.date.isSmallerThanValue(end),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
  }

  Future<List<PestControl>> getUnsyncedPestControls() =>
      (select(pestControls)..where((t) => t.needsSync.equals(true))).get();

  Future<int> insertPestControl(PestControlsCompanion entry) =>
      into(pestControls).insert(entry);

  Future<bool> updatePestControl(PestControl entry) =>
      update(pestControls).replace(entry);

  Future<int> deletePestControl(int id) =>
      (delete(pestControls)..where((t) => t.id.equals(id))).go();

  Future<void> softDeletePestControl(int id) =>
      (update(pestControls)..where((t) => t.id.equals(id)))
          .write(const PestControlsCompanion(
            isDeleted: Value(true),
            needsSync: Value(true),
          ));

  Future<void> markPestControlsSynced(List<int> ids) =>
      (update(pestControls)..where((t) => t.id.isIn(ids)))
          .write(const PestControlsCompanion(needsSync: Value(false)));

  // ── MaterialItems ─────────────────────────────────────────────────────────

  Stream<List<MaterialItem>> watchMaterialItemsForDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (select(materialItems)
          ..where(
            (t) =>
                t.date.isBiggerOrEqualValue(start) &
                t.date.isSmallerThanValue(end) &
                t.isDeleted.equals(false),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .watch();
  }

  Future<List<MaterialItem>> getMaterialItemsForDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (select(materialItems)
          ..where(
            (t) =>
                t.date.isBiggerOrEqualValue(start) &
                t.date.isSmallerThanValue(end),
          ))
        .get();
  }

  Future<List<MaterialItem>> getMaterialItemsForYear(int year) {
    final start = DateTime(year);
    final end = DateTime(year + 1);
    return (select(materialItems)
          ..where(
            (t) =>
                t.date.isBiggerOrEqualValue(start) &
                t.date.isSmallerThanValue(end),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
  }

  Future<List<MaterialItem>> getUnsyncedMaterialItems() =>
      (select(materialItems)..where((t) => t.needsSync.equals(true))).get();

  Future<int> insertMaterialItem(MaterialItemsCompanion entry) =>
      into(materialItems).insert(entry);

  Future<bool> updateMaterialItem(MaterialItem entry) =>
      update(materialItems).replace(entry);

  Future<int> deleteMaterialItem(int id) =>
      (delete(materialItems)..where((t) => t.id.equals(id))).go();

  Future<void> softDeleteMaterialItem(int id) =>
      (update(materialItems)..where((t) => t.id.equals(id)))
          .write(const MaterialItemsCompanion(
            isDeleted: Value(true),
            needsSync: Value(true),
          ));

  Future<void> markMaterialItemsSynced(List<int> ids) =>
      (update(materialItems)..where((t) => t.id.isIn(ids)))
          .write(const MaterialItemsCompanion(needsSync: Value(false)));

  // ── Search ───────────────────────────────────────────────────────────────

  Future<List<WorkLog>> searchWorkLogs(String query) {
    final q = '%$query%';
    return (select(workLogs)
          ..where(
            (t) =>
                t.isDeleted.equals(false) &
                (t.workContent.like(q) |
                    t.cropName.like(q) |
                    t.weather.like(q) |
                    t.workNote.like(q)),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  Future<List<PestControl>> searchPestControls(String query) {
    final q = '%$query%';
    return (select(pestControls)
          ..where(
            (t) =>
                t.isDeleted.equals(false) &
                (t.cause.like(q) |
                    t.cropName.like(q) |
                    t.method.like(q) |
                    t.result.like(q) |
                    t.note.like(q)),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  Future<List<MaterialItem>> searchMaterialItems(String query) {
    final q = '%$query%';
    return (select(materialItems)
          ..where(
            (t) =>
                t.isDeleted.equals(false) & t.content.like(q),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  // ── AppSettings ───────────────────────────────────────────────────────────

  Future<String?> getSetting(String key) async {
    final row = await (select(appSettings)
          ..where((t) => t.settingKey.equals(key)))
        .getSingleOrNull();
    return row?.settingValue;
  }

  Future<void> setSetting(String key, String value) =>
      into(appSettings).insertOnConflictUpdate(
        AppSettingsCompanion(
          settingKey: Value(key),
          settingValue: Value(value),
        ),
      );

  Future<Map<String, String>> getAllSettings() async {
    final rows = await select(appSettings).get();
    return {for (final r in rows) r.settingKey: r.settingValue};
  }

  // ── Calendar helpers ──────────────────────────────────────────────────────

  Future<Set<DateTime>> getDatesWithAnyRecord(int year) async {
    final start = DateTime(year);
    final end = DateTime(year + 1);

    final wDates = await (selectOnly(workLogs)
          ..addColumns([workLogs.date])
          ..where(
            workLogs.date.isBiggerOrEqualValue(start) &
                workLogs.date.isSmallerThanValue(end) &
                workLogs.isDeleted.equals(false),
          ))
        .get()
        .then((r) => r.map((e) => e.read(workLogs.date)!));

    final pDates = await (selectOnly(pestControls)
          ..addColumns([pestControls.date])
          ..where(
            pestControls.date.isBiggerOrEqualValue(start) &
                pestControls.date.isSmallerThanValue(end) &
                pestControls.isDeleted.equals(false),
          ))
        .get()
        .then((r) => r.map((e) => e.read(pestControls.date)!));

    final mDates = await (selectOnly(materialItems)
          ..addColumns([materialItems.date])
          ..where(
            materialItems.date.isBiggerOrEqualValue(start) &
                materialItems.date.isSmallerThanValue(end) &
                materialItems.isDeleted.equals(false),
          ))
        .get()
        .then((r) => r.map((e) => e.read(materialItems.date)!));

    return {
      for (final d in [...wDates, ...pDates, ...mDates])
        DateTime(d.year, d.month, d.day),
    };
  }

  // ── Bulk sync helpers ─────────────────────────────────────────────────────

  Future<void> replaceAllData({
    required List<WorkLogsCompanion> workLogEntries,
    required List<PestControlsCompanion> pestControlEntries,
    required List<MaterialItemsCompanion> materialEntries,
  }) async {
    await transaction(() async {
      await delete(workLogs).go();
      await delete(pestControls).go();
      await delete(materialItems).go();
      if (workLogEntries.isNotEmpty) {
        await batch(
          (b) => b.insertAll(workLogs, workLogEntries,
              mode: InsertMode.insertOrReplace),
        );
      }
      if (pestControlEntries.isNotEmpty) {
        await batch(
          (b) => b.insertAll(pestControls, pestControlEntries,
              mode: InsertMode.insertOrReplace),
        );
      }
      if (materialEntries.isNotEmpty) {
        await batch(
          (b) => b.insertAll(materialItems, materialEntries,
              mode: InsertMode.insertOrReplace),
        );
      }
    });
  }
}
