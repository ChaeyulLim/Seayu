import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/database.dart';
import 'database_provider.dart';

final pestControlsForDateProvider =
    StreamProvider.family<List<PestControl>, DateTime>((ref, date) {
  final db = ref.watch(databaseProvider);
  return db.watchPestControlsForDate(date);
});

class PestControlNotifier extends StateNotifier<void> {
  final AppDatabase _db;

  PestControlNotifier(this._db) : super(null);

  Future<int> add(DateTime date, String cropName) async {
    return await _db.insertPestControl(
      PestControlsCompanion(
        date: Value(DateTime(date.year, date.month, date.day)),
        cropName: Value(cropName),
        needsSync: const Value(true),
      ),
    );
  }

  Future<void> update(PestControl entry) async {
    await _db.updatePestControl(entry.copyWith(needsSync: true));
  }

  Future<void> delete(int id) async {
    await _db.deletePestControl(id);
  }

  Future<void> softDelete(int id) async {
    await _db.softDeletePestControl(id);
  }
}

final pestControlNotifierProvider =
    StateNotifierProvider.family<PestControlNotifier, void, DateTime>(
  (ref, _) => PestControlNotifier(ref.watch(databaseProvider)),
);
