import '../../core/config.dart';
import '../local/database.dart';
import 'sheets_service.dart';

class SyncService {
  final AppDatabase _db;
  final SheetsService _sheets;

  SyncService(this._db, this._sheets);

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  bool get _isConfigured =>
      AppConfig.spreadsheetId.isNotEmpty &&
      AppConfig.spreadsheetId != 'YOUR_SPREADSHEET_ID';

  /// 앱 시작 시 Sheets → 로컬 전체 동기화 (모든 연도)
  Future<void> fullSync() async {
    if (!_sheets.isReady || !_isConfigured) return;
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final id = AppConfig.spreadsheetId;
      final currentYear = DateTime.now().year;

      // 현재 연도 탭 없으면 자동 생성
      await _sheets.ensureYearSheetExists(id, currentYear);

      // 스프레드시트에 있는 모든 연도 탭 읽기
      final years = await _sheets.getAvailableYears(id);

      final workLogs = <WorkLogsCompanion>[];
      final pestControls = <PestControlsCompanion>[];
      final materials = <MaterialItemsCompanion>[];

      for (final year in years) {
        final rows = await _sheets.fetchYearRows(id, year);
        DateTime? lastDate; // 연도별로 초기화: 빈 날짜 행 처리용
        for (final row in rows) {
          final parsed = SheetsService.parseRow(row, year, lastKnownDate: lastDate);
          if (parsed.parsedDate != null) lastDate = parsed.parsedDate;
          if (parsed.work != null) workLogs.add(parsed.work!);
          if (parsed.pest != null) pestControls.add(parsed.pest!);
          if (parsed.material != null) materials.add(parsed.material!);
        }
      }

      await _db.replaceAllData(
        workLogEntries: workLogs,
        pestControlEntries: pestControls,
        materialEntries: materials,
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// 로컬 → Sheets 재기록 (미동기화 항목이 있는 모든 연도, 탭 없으면 자동 생성)
  Future<void> pushLocalChanges() async {
    if (!_sheets.isReady || !_isConfigured) return;
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final id = AppConfig.spreadsheetId;

      // 미동기화 레코드에서 영향받는 연도 수집
      final unsyncedWork = await _db.getUnsyncedWorkLogs();
      final unsyncedPest = await _db.getUnsyncedPestControls();
      final unsyncedMaterial = await _db.getUnsyncedMaterialItems();

      final yearsToSync = <int>{};
      for (final w in unsyncedWork) { yearsToSync.add(w.date.year); }
      for (final p in unsyncedPest) { yearsToSync.add(p.date.year); }
      for (final m in unsyncedMaterial) { yearsToSync.add(m.date.year); }

      if (yearsToSync.isEmpty) return;

      for (final year in yearsToSync.toList()..sort()) {
        // 시트 탭 없으면 자동 생성
        await _sheets.ensureYearSheetExists(id, year);

        final workLogs = await _db.getWorkLogsForYear(year);
        final pestControls = await _db.getPestControlsForYear(year);
        final materialItems = await _db.getMaterialItemsForYear(year);

        final rows = SheetsService.buildYearRows(
          workLogs: workLogs,
          pestControls: pestControls,
          materialItems: materialItems,
        );

        await _sheets.rewriteYearSheet(id, year, rows);
        await _db.markWorkLogsSynced(workLogs.map((w) => w.id).toList());
        await _db.markPestControlsSynced(pestControls.map((p) => p.id).toList());
        await _db.markMaterialItemsSynced(materialItems.map((m) => m.id).toList());
      }
    } finally {
      _isSyncing = false;
    }
  }

  Future<bool> hasUnsyncedData() async {
    final w = await _db.getUnsyncedWorkLogs();
    if (w.isNotEmpty) return true;
    final p = await _db.getUnsyncedPestControls();
    if (p.isNotEmpty) return true;
    final m = await _db.getUnsyncedMaterialItems();
    return m.isNotEmpty;
  }
}
