import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/database.dart';
import 'database_provider.dart';

final materialItemsForDateProvider =
    StreamProvider.family<List<MaterialItem>, DateTime>((ref, date) {
  final db = ref.watch(databaseProvider);
  return db.watchMaterialItemsForDate(date);
});

class MaterialItemNotifier extends StateNotifier<void> {
  final AppDatabase _db;

  MaterialItemNotifier(this._db) : super(null);

  Future<int> add(DateTime date) async {
    return await _db.insertMaterialItem(
      MaterialItemsCompanion(
        date: Value(DateTime(date.year, date.month, date.day)),
        needsSync: const Value(true),
      ),
    );
  }

  Future<void> update(MaterialItem entry) async {
    await _db.updateMaterialItem(entry.copyWith(needsSync: true));
  }

  Future<void> delete(int id) async {
    await _db.deleteMaterialItem(id);
  }

  Future<void> softDelete(int id) async {
    await _db.softDeleteMaterialItem(id);
  }
}

final materialItemNotifierProvider =
    StateNotifierProvider.family<MaterialItemNotifier, void, DateTime>(
  (ref, _) => MaterialItemNotifier(ref.watch(databaseProvider)),
);
