import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'package:drift/drift.dart' show Value;

import '../../core/constants.dart';
import '../../core/exceptions.dart';
import '../local/database.dart';

class SheetsService {
  SheetsApi? _api;

  bool get isReady => _api != null;

  Future<void> initialize() async {
    try {
      final json =
          await rootBundle.loadString(AppConstants.serviceAccountAssetPath);
      final jsonMap = jsonDecode(json) as Map<String, dynamic>;

      if (jsonMap['private_key'] == 'YOUR_PRIVATE_KEY') {
        throw const AuthException('service_account.json이 설정되지 않았습니다.');
      }

      final credentials = ServiceAccountCredentials.fromJson(jsonMap);
      final client = await clientViaServiceAccount(
        credentials,
        [SheetsApi.spreadsheetsScope],
      );
      _api = SheetsApi(client);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('인증 실패: $e');
    }
  }

  // ── Year sheet ────────────────────────────────────────────────────────────

  /// 스프레드시트에서 연도 탭 목록 반환 (4자리 숫자 탭만)
  Future<List<int>> getAvailableYears(String spreadsheetId) async {
    _assertReady();
    try {
      final spreadsheet = await _api!.spreadsheets.get(spreadsheetId);
      final years = <int>[];
      for (final sheet in spreadsheet.sheets ?? []) {
        final title = sheet.properties?.title ?? '';
        final year = int.tryParse(title);
        if (year != null && year >= 2020 && year <= 2099) {
          years.add(year);
        }
      }
      years.sort();
      return years;
    } on DetailedApiRequestError catch (e) {
      _handleApiError(e);
    }
  }

  Future<void> ensureYearSheetExists(
    String spreadsheetId,
    int year,
  ) async {
    _assertReady();
    try {
      final spreadsheet = await _api!.spreadsheets.get(spreadsheetId);
      final exists = spreadsheet.sheets?.any(
            (s) => s.properties?.title == year.toString(),
          ) ??
          false;

      if (!exists) {
        await _api!.spreadsheets.batchUpdate(
          BatchUpdateSpreadsheetRequest(
            requests: [
              Request(
                addSheet: AddSheetRequest(
                  properties: SheetProperties(title: year.toString()),
                ),
              ),
            ],
          ),
          spreadsheetId,
        );

        // 4행 헤더 작성
        final headerRows = [
          ['작업일지', '', '', '', '', '', '', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', '', '', '', '', '', '', ''],
          ['날짜', '날씨', '작업', '', '', '', '', '방제', '', '', '', '', '자재', ''],
          ['날짜', '날씨', '작물명', '내용', '인원', '일비', '비고', '원인', '방법', '결과', '비용', '비고', '내용', '비용'],
        ];
        await _api!.spreadsheets.values.update(
          ValueRange(values: headerRows),
          spreadsheetId,
          '$year!A1',
          valueInputOption: 'RAW',
        );
      }
    } on DetailedApiRequestError catch (e) {
      throw SheetCreateException('연도 탭 생성 실패: ${e.message}');
    }
  }

  /// 해당 연도의 데이터 행 반환 (A2부터 읽어 날짜 파싱으로 헤더 자동 건너뜀)
  Future<List<List<String>>> fetchYearRows(
    String spreadsheetId,
    int year,
  ) async {
    _assertReady();
    try {
      final response = await _api!.spreadsheets.values.get(
        spreadsheetId,
        '$year!A2:N',
        valueRenderOption: 'UNFORMATTED_VALUE',
      );
      return (response.values ?? [])
          .map(
            (row) => List.generate(
              AppConstants.totalColumns,
              (i) => i < row.length ? row[i].toString() : '',
            ),
          )
          .toList();
    } on DetailedApiRequestError catch (e) {
      _handleApiError(e);
    }
  }

  /// 연도 탭 데이터 행만 덮어씀 (1~4행 헤더 유지, 5행부터 재기록)
  Future<void> rewriteYearSheet(
    String spreadsheetId,
    int year,
    List<List<Object>> rows,
  ) async {
    _assertReady();
    try {
      // 데이터 행만 클리어 (헤더 1~4행 보존)
      await _api!.spreadsheets.values.clear(
        ClearValuesRequest(),
        spreadsheetId,
        '$year!A5:N',
      );

      if (rows.isNotEmpty) {
        await _api!.spreadsheets.values.update(
          ValueRange(values: rows),
          spreadsheetId,
          '$year!A5',
          valueInputOption: 'RAW',
        );
      }
    } on DetailedApiRequestError catch (e) {
      _handleApiError(e);
    }
  }

  // ── Row parsing / building ─────────────────────────────────────────────────

  /// Sheet row → companion objects
  /// lastKnownDate: 날짜 셀이 비어있을 때 사용할 이전 행의 날짜
  static const _kDeleted = '[삭제]';

  static ({
    WorkLogsCompanion? work,
    PestControlsCompanion? pest,
    MaterialItemsCompanion? material,
    DateTime? parsedDate,
  }) parseRow(List<String> row, int year, {DateTime? lastKnownDate}) {
    if (row.length < AppConstants.totalColumns) {
      row = List.generate(
        AppConstants.totalColumns,
        (i) => i < row.length ? row[i] : '',
      );
    }

    final dateStr = row[AppConstants.colDate];
    DateTime? date;

    if (dateStr.isNotEmpty) {
      date = _parseSheetDate(dateStr, year);
    } else {
      date = lastKnownDate; // 날짜 없는 행 = 이전 행 날짜 이어받음
    }

    if (date == null) {
      return (work: null, pest: null, material: null, parsedDate: null);
    }

    WorkLogsCompanion? work;
    PestControlsCompanion? pest;
    MaterialItemsCompanion? material;

    final workNoteRaw = row[AppConstants.colWorkNote];
    final pestNoteRaw = row[AppConstants.colPestNote];
    final materialContentRaw = row[AppConstants.colMaterialContent];

    final workDeleted = workNoteRaw.startsWith(_kDeleted);
    final pestDeleted = pestNoteRaw.startsWith(_kDeleted);
    final materialDeleted = materialContentRaw.startsWith(_kDeleted);

    final hasWork = row[AppConstants.colWorkContent].isNotEmpty ||
        row[AppConstants.colWorkers].isNotEmpty ||
        workDeleted;
    final hasPest = row[AppConstants.colPestCause].isNotEmpty || pestDeleted;
    final hasMaterial = materialContentRaw.isNotEmpty;

    if (hasWork) {
      final workers =
          double.tryParse(row[AppConstants.colWorkers]) ?? 1.0;
      final wage = int.tryParse(row[AppConstants.colDailyWage]) ?? 0;
      final noteClean = workDeleted
          ? workNoteRaw.substring(_kDeleted.length).trim()
          : workNoteRaw;
      work = WorkLogsCompanion(
        date: Value(date),
        weather: Value(row[AppConstants.colWeather]),
        cropName: Value(row[AppConstants.colCropName]),
        workContent: Value(row[AppConstants.colWorkContent]),
        workers: Value(workers),
        dailyWage: Value(wage),
        workNote: Value(noteClean),
        isDeleted: Value(workDeleted),
        needsSync: const Value(false),
      );
    }

    if (hasPest) {
      final cost =
          double.tryParse(row[AppConstants.colPestCost]) ?? 0.0;
      final pCropName = row[AppConstants.colCropName];
      final rawCause = row[AppConstants.colPestCause];
      final cause = (pCropName.isNotEmpty && rawCause.startsWith('$pCropName·'))
          ? rawCause.substring(pCropName.length + 1)
          : rawCause;
      final pestNoteClean = pestDeleted
          ? pestNoteRaw.substring(_kDeleted.length).trim()
          : pestNoteRaw;
      pest = PestControlsCompanion(
        date: Value(date),
        cropName: Value(pCropName),
        cause: Value(cause),
        method: Value(row[AppConstants.colPestMethod]),
        result: Value(row[AppConstants.colPestResult]),
        cost: Value(cost),
        note: Value(pestNoteClean),
        isDeleted: Value(pestDeleted),
        needsSync: const Value(false),
      );
    }

    if (hasMaterial) {
      final cost =
          double.tryParse(row[AppConstants.colMaterialCost]) ?? 0.0;
      final contentClean = materialDeleted
          ? materialContentRaw.substring(_kDeleted.length).trim()
          : materialContentRaw;
      material = MaterialItemsCompanion(
        date: Value(date),
        content: Value(contentClean),
        cost: Value(cost),
        isDeleted: Value(materialDeleted),
        needsSync: const Value(false),
      );
    }

    return (work: work, pest: pest, material: material, parsedDate: date);
  }

  /// 로컬 records → sheet rows
  /// 날짜별로 작업(A-G) / 방제(H-L) / 자재(M-N) 를 index 기준으로 같은 행에 배치.
  /// 행 수 = max(작업 수, 방제 수, 자재 수). 첫 행만 날짜 표시.
  ///
  /// 예) 작업 2개, 방제 3개:
  ///   4/25 | 작업1 | 방제1 |
  ///        | 작업2 | 방제2 |
  ///        |       | 방제3 |
  static List<List<Object>> buildYearRows({
    required List workLogs,
    required List pestControls,
    required List materialItems,
  }) {
    // 날짜별로 그룹화
    final Map<String, Map<String, dynamic>> byDate = {};

    for (final w in workLogs) {
      final key = _toSheetDate(w.date);
      byDate.putIfAbsent(key, () => {'date': w.date, 'works': [], 'pests': [], 'materials': []});
      (byDate[key]!['works'] as List).add(w);
    }
    for (final p in pestControls) {
      final key = _toSheetDate(p.date);
      byDate.putIfAbsent(key, () => {'date': p.date, 'works': [], 'pests': [], 'materials': []});
      (byDate[key]!['pests'] as List).add(p);
    }
    for (final m in materialItems) {
      final key = _toSheetDate(m.date);
      byDate.putIfAbsent(key, () => {'date': m.date, 'works': [], 'pests': [], 'materials': []});
      (byDate[key]!['materials'] as List).add(m);
    }

    // 날짜 순 정렬
    final sortedDates = byDate.keys.toList()
      ..sort((a, b) {
        final da = _parseSheetDateStr(a) ?? DateTime(2000);
        final db = _parseSheetDateStr(b) ?? DateTime(2000);
        return da.compareTo(db);
      });

    final rows = <List<Object>>[];

    for (final dateStr in sortedDates) {
      final group = byDate[dateStr]!;
      final works = group['works'] as List;
      final pests = group['pests'] as List;
      final materials = group['materials'] as List;

      // 이 날짜의 행 수 = 세 그룹 중 가장 긴 것
      final rowCount = [works.length, pests.length, materials.length]
          .fold(0, (prev, curr) => curr > prev ? curr : prev);

      for (int i = 0; i < rowCount; i++) {
        final w = i < works.length ? works[i] : null;
        final p = i < pests.length ? pests[i] : null;
        final m = i < materials.length ? materials[i] : null;

        // 첫 행만 날짜, 이후 행은 빈칸
        final rowDate = i == 0 ? dateStr : '';
        // cropName: 작업 > 방제 순으로 우선
        final cropName = w?.cropName ?? p?.cropName ?? '';
        final weather = w?.weather ?? '';

        final workNote = w == null
            ? ''
            : w.isDeleted
                ? '$_kDeleted${w.workNote.isNotEmpty ? " ${w.workNote}" : ""}'
                : w.workNote;
        final pestNote = p == null
            ? ''
            : p.isDeleted
                ? '$_kDeleted${p.note.isNotEmpty ? " ${p.note}" : ""}'
                : p.note;
        final materialContent = m == null
            ? ''
            : m.isDeleted
                ? '$_kDeleted${m.content.isNotEmpty ? " ${m.content}" : ""}'
                : m.content;

        rows.add([
          rowDate,
          weather,
          cropName,
          w?.workContent ?? '',
          w != null ? w.workers as Object : '',
          w != null ? w.dailyWage as Object : '',
          workNote,
          p != null ? '${p.cropName.isNotEmpty ? "${p.cropName}·" : ""}${p.cause}' : '',
          p?.method ?? '',
          p?.result ?? '',
          p != null ? p.cost as Object : '',
          pestNote,
          materialContent,
          m != null ? m.cost as Object : '',
        ]);
      }
    }

    return rows;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static String _toSheetDate(DateTime d) => '${d.month}/${d.day}';

  static DateTime? _parseSheetDateStr(String s) {
    final parts = s.split('/');
    if (parts.length != 2) return null;
    final month = int.tryParse(parts[0]);
    final day = int.tryParse(parts[1]);
    if (month == null || day == null) return null;
    return DateTime(2000, month, day);
  }

  static DateTime? _parseSheetDate(String s, int year) {
    if (s.isEmpty) return null;

    // Date serial number (Google Sheets stores dates as days since 1899-12-30)
    final serial = int.tryParse(s);
    if (serial != null && serial > 1000) {
      final d = DateTime(1899, 12, 30).add(Duration(days: serial));
      return DateTime(d.year, d.month, d.day);
    }

    // "M/D" — our app's writing format
    final slashParts = s.split('/');
    if (slashParts.length == 2) {
      final month = int.tryParse(slashParts[0]);
      final day = int.tryParse(slashParts[1]);
      if (month != null && day != null) return DateTime(year, month, day);
    }

    // "YYYY. M. D" Korean locale format
    final koreanMatch =
        RegExp(r'^(\d{4})\.\s*(\d{1,2})\.\s*(\d{1,2})').firstMatch(s.trim());
    if (koreanMatch != null) {
      final y = int.tryParse(koreanMatch.group(1)!);
      final m = int.tryParse(koreanMatch.group(2)!);
      final d = int.tryParse(koreanMatch.group(3)!);
      if (y != null && m != null && d != null) return DateTime(y, m, d);
    }

    // "YYYY-MM-DD" or "YYYY/MM/DD"
    final isoMatch =
        RegExp(r'^(\d{4})[-/](\d{1,2})[-/](\d{1,2})').firstMatch(s.trim());
    if (isoMatch != null) {
      final m = int.tryParse(isoMatch.group(2)!);
      final d = int.tryParse(isoMatch.group(3)!);
      if (m != null && d != null) return DateTime(year, m, d);
    }

    return null;
  }

  void _assertReady() {
    if (_api == null) throw const AuthException('Sheets API가 초기화되지 않았습니다.');
  }

  Never _handleApiError(DetailedApiRequestError e) {
    if (e.status == 429) throw QuotaExceededException();
    throw SheetsException(e.message ?? 'Sheets API 오류 (${e.status})');
  }
}
