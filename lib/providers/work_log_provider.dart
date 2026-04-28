import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/database.dart';
import 'database_provider.dart';
import 'settings_provider.dart';

final workLogsForDateProvider =
    StreamProvider.family<List<WorkLog>, DateTime>((ref, date) {
  final db = ref.watch(databaseProvider);
  return db.watchWorkLogsForDate(date);
});

final eventDatesProvider =
    FutureProvider.family<Set<DateTime>, int>((ref, year) {
  final db = ref.watch(databaseProvider);
  return db.getDatesWithAnyRecord(year);
});

class WorkLogNotifier extends StateNotifier<void> {
  final AppDatabase _db;
  final int dailyWage;

  WorkLogNotifier(this._db, this.dailyWage) : super(null);

  Future<int> add(DateTime date, String cropName) async {
    return await _db.insertWorkLog(
      WorkLogsCompanion(
        date: Value(DateTime(date.year, date.month, date.day)),
        cropName: Value(cropName),
        workers: const Value(1.0),
        dailyWage: Value(dailyWage),
        needsSync: const Value(true),
      ),
    );
  }

  Future<void> update(WorkLog log) async {
    await _db.updateWorkLog(log.copyWith(needsSync: true));
  }

  Future<void> updateWorkers(WorkLog log, double workers) async {
    final wage = (workers * dailyWage).round();
    await _db.updateWorkLog(
      log.copyWith(workers: workers, dailyWage: wage, needsSync: true),
    );
  }

  Future<void> delete(int id) async {
    await _db.deleteWorkLog(id);
  }

  Future<void> softDelete(int id) async {
    await _db.softDeleteWorkLog(id);
  }
}

final workLogNotifierProvider =
    StateNotifierProvider.family<WorkLogNotifier, void, DateTime>(
  (ref, date) {
    final db = ref.watch(databaseProvider);
    final wage = ref.watch(settingsProvider).dailyWage;
    return WorkLogNotifier(db, wage);
  },
);
