import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/remote/sheets_service.dart';
import '../data/remote/sync_service.dart';
import 'database_provider.dart';

final sheetsServiceProvider = Provider<SheetsService>((ref) {
  return SheetsService();
});

final syncServiceProvider = Provider<SyncService>((ref) {
  final db = ref.watch(databaseProvider);
  final sheets = ref.watch(sheetsServiceProvider);
  return SyncService(db, sheets);
});

/// Sheets 초기화 (앱 시작 시 한 번)
final sheetsInitProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(sheetsServiceProvider);
  try {
    await service.initialize();
    return true;
  } catch (e, st) {
    // ignore: avoid_print
    print('[SheetsInit] 초기화 실패: $e\n$st');
    return false;
  }
});

/// 동기화 상태 (앱 바 로딩 인디케이터용)
class SyncStateNotifier extends StateNotifier<AsyncValue<void>> {
  final SyncService _sync;

  SyncStateNotifier(this._sync) : super(const AsyncValue.data(null));

  Future<void> fullSync() async {
    state = const AsyncValue.loading();
    try {
      await _sync.fullSync();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> push() async {
    state = const AsyncValue.loading();
    try {
      await _sync.pushLocalChanges();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final syncStateProvider =
    StateNotifierProvider<SyncStateNotifier, AsyncValue<void>>((ref) {
  final sync = ref.watch(syncServiceProvider);
  return SyncStateNotifier(sync);
});
