import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../providers/database_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/sheets_provider.dart';
import '../../providers/work_log_provider.dart';
import 'detail_helpers.dart';
import 'work_edit_screen.dart';

class WorkTab extends ConsumerWidget {
  final DateTime date;
  const WorkTab({super.key, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(workLogsForDateProvider(date));
    final settings = ref.watch(settingsProvider);

    return logsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('오류: $e')),
      data: (logs) => Column(
        children: [
          AddTile(
            label: '작업 추가',
            onTap: () => _addAndNavigate(context, ref, settings),
          ),
          const Divider(height: 1),
          Expanded(
            child: logs.isEmpty
                ? const Center(
                    child: Text(
                      '작업 기록이 없습니다',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    itemCount: logs.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 16),
                    itemBuilder: (ctx, i) => _WorkSummaryTile(
                      log: logs[i],
                      date: date,
                      settings: settings,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _addAndNavigate(
    BuildContext context,
    WidgetRef ref,
    SettingsState settings,
  ) async {
    final firstCrop =
        settings.cropNames.isNotEmpty ? settings.cropNames.first : '미지정';
    final id = await ref
        .read(workLogNotifierProvider(date).notifier)
        .add(date, firstCrop);
    final db = ref.read(databaseProvider);
    final newLog = await db.getWorkLogById(id);
    if (newLog == null || !context.mounted) return;
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => WorkEditScreen(
          log: newLog,
          date: date,
          cropNames: settings.cropNames,
          dailyWage: settings.dailyWage,
        ),
      ),
    );
    if (saved != true) {
      await ref.read(workLogNotifierProvider(date).notifier).delete(id);
    }
  }
}

class _WorkSummaryTile extends ConsumerWidget {
  final WorkLog log;
  final DateTime date;
  final SettingsState settings;

  const _WorkSummaryTile({
    required this.log,
    required this.date,
    required this.settings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather =
        log.weather.isNotEmpty ? '${log.weather}  ' : '';
    final content = log.workContent.isNotEmpty ? log.workContent : '내용 없음';
    final workers = log.workers == log.workers.truncateToDouble()
        ? log.workers.toInt().toString()
        : log.workers.toString();
    final wage = _fmtWage(log.dailyWage);

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      title: Text(
        '$weather${log.cropName}  •  $content',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text('인원 $workers명  •  일비 $wage원'),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        onPressed: () async {
          final ok = await confirmDelete(context);
          if (ok) {
            await ref
                .read(workLogNotifierProvider(date).notifier)
                .softDelete(log.id);
            await ref.read(syncStateProvider.notifier).push();
          }
        },
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WorkEditScreen(
            log: log,
            date: date,
            cropNames: settings.cropNames,
            dailyWage: settings.dailyWage,
          ),
        ),
      ),
    );
  }

  String _fmtWage(int w) => w
      .toString()
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );
}

