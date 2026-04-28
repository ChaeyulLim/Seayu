import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/config.dart';
import '../../providers/connectivity_provider.dart';
import '../../providers/sheets_provider.dart';
import '../../providers/work_log_provider.dart';
import '../detail/material_tab.dart';
import '../detail/pest_tab.dart';
import '../detail/work_tab.dart';
import '../search/search_screen.dart';
import '../settings/settings_screen.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final _today = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime(_today.year, _today.month, _today.day);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initSync());
  }

  Future<void> _initSync() async {
    if (AppConfig.spreadsheetId == 'YOUR_SPREADSHEET_ID') return;
    final sheetsOk = await ref.read(sheetsInitProvider.future);
    if (!sheetsOk) return;
    if (!ref.read(isOnlineProvider)) return;
    await ref.read(syncStateProvider.notifier).fullSync();
    _refreshDates();
  }

  void _refreshDates() {
    ref.invalidate(eventDatesProvider(_focusedDay.year));
  }

  @override
  Widget build(BuildContext context) {
    final year = _focusedDay.year;
    final eventDatesAsync = ref.watch(eventDatesProvider(year));
    final isOnline = ref.watch(isOnlineProvider);
    final syncState = ref.watch(syncStateProvider);
    final selected = _selectedDay;

    ref.listen<AsyncValue<void>>(syncStateProvider, (prev, next) {
      if (prev?.isLoading == true && next.hasValue && !next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('동기화 완료'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    });

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('농장 작업일지'),
          actions: [
            if (!isOnline)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.cloud_off, color: Colors.orange),
              ),
            if (syncState.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: '검색',
              onPressed: () => _openSearch(context),
            ),
            IconButton(
              icon: const Icon(Icons.sync),
              tooltip: '수동 동기화',
              onPressed: isOnline ? _manualSync : null,
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ).then((_) => _refreshDates()),
            ),
          ],
        ),
        body: Column(
          children: [
            // ── 오류 배너 ────────────────────────────────────────────────
            if (syncState.hasError)
              MaterialBanner(
                content: Text(
                  '동기화 실패: ${syncState.error}',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red.shade700,
                actions: [
                  TextButton(
                    onPressed: () =>
                        ref.read(syncStateProvider.notifier).push(),
                    child: const Text('재시도',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),

            // ── 캘린더 ────────────────────────────────────────────────────
            eventDatesAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
              data: (eventDates) => TableCalendar(
                firstDay: DateTime(2020),
                lastDay: DateTime(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.monday,
                locale: 'ko_KR',
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onHeaderTapped: (_) => _showYearMonthPicker(context),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.green.shade200,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                eventLoader: (day) {
                  final d = DateTime(day.year, day.month, day.day);
                  return eventDates.contains(d) ? [true] : [];
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _refreshDates();
                },
                onPageChanged: (focusedDay) {
                  setState(() => _focusedDay = focusedDay);
                  ref.invalidate(eventDatesProvider(focusedDay.year));
                },
              ),
            ),

            const Divider(height: 1),

            // ── 선택된 날짜 ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    selected != null
                        ? DateFormat('yyyy년 M월 d일 (E)', 'ko_KR')
                            .format(selected)
                        : '날짜를 선택하세요',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // ── 탭 바 ─────────────────────────────────────────────────────
            const TabBar(
              tabs: [
                Tab(text: '작업'),
                Tab(text: '방제'),
                Tab(text: '자재'),
              ],
            ),

            // ── 탭 내용 ───────────────────────────────────────────────────
            Expanded(
              child: selected == null
                  ? const Center(child: Text('캘린더에서 날짜를 선택하세요'))
                  : TabBarView(
                      children: [
                        WorkTab(date: selected),
                        PestTab(date: selected),
                        MaterialTab(date: selected),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showYearMonthPicker(BuildContext context) async {
    int selectedYear = _focusedDay.year;
    int selectedMonth = _focusedDay.month;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('날짜 이동'),
          content: Row(
            children: [
              Expanded(
                child: DropdownButton<int>(
                  value: selectedYear,
                  isExpanded: true,
                  items: List.generate(11, (i) => 2020 + i)
                      .map((y) => DropdownMenuItem(
                            value: y,
                            child: Text('$y년'),
                          ))
                      .toList(),
                  onChanged: (y) {
                    if (y != null) setDialogState(() => selectedYear = y);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButton<int>(
                  value: selectedMonth,
                  isExpanded: true,
                  items: List.generate(12, (i) => i + 1)
                      .map((m) => DropdownMenuItem(
                            value: m,
                            child: Text('$m월'),
                          ))
                      .toList(),
                  onChanged: (m) {
                    if (m != null) setDialogState(() => selectedMonth = m);
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                final target = DateTime(selectedYear, selectedMonth);
                setState(() => _focusedDay = target);
                ref.invalidate(eventDatesProvider(selectedYear));
                Navigator.pop(ctx);
              },
              child: const Text('이동'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openSearch(BuildContext context) async {
    final result = await Navigator.push<SearchResult>(
      context,
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
    if (result == null) return;
    final date = DateTime(result.date.year, result.date.month, result.date.day);
    setState(() {
      _selectedDay = date;
      _focusedDay = date;
    });
    if (context.mounted) {
      DefaultTabController.of(context).animateTo(result.tabIndex);
    }
  }

  Future<void> _manualSync() async {
    final sheetsOk = await ref.read(sheetsInitProvider.future);
    if (!sheetsOk) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Sheets 인증에 실패했습니다.')),
      );
      return;
    }
    // 시트 → 앱 전체 동기화 (시트에서 직접 수정한 내용도 반영)
    await ref.read(syncStateProvider.notifier).fullSync();
    // 모든 연도의 캘린더 마커 갱신
    ref.invalidate(eventDatesProvider);
  }
}
