import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../providers/database_provider.dart';
import '../../providers/pest_control_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/sheets_provider.dart';
import 'detail_helpers.dart';
import 'pest_edit_screen.dart';

class PestTab extends ConsumerWidget {
  final DateTime date;
  const PestTab({super.key, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pestsAsync = ref.watch(pestControlsForDateProvider(date));
    final settings = ref.watch(settingsProvider);

    return pestsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('오류: $e')),
      data: (pests) => Column(
        children: [
          AddTile(
            label: '방제 추가',
            onTap: () => _addAndNavigate(context, ref, settings),
          ),
          const Divider(height: 1),
          Expanded(
            child: pests.isEmpty
                ? const Center(
                    child: Text(
                      '방제 기록이 없습니다',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    itemCount: pests.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 16),
                    itemBuilder: (ctx, i) => _PestSummaryTile(
                      entry: pests[i],
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
        .read(pestControlNotifierProvider(date).notifier)
        .add(date, firstCrop);
    final db = ref.read(databaseProvider);
    final entry = await db.getPestControlById(id);
    if (entry == null || !context.mounted) return;
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => PestEditScreen(
          entry: entry,
          date: date,
          cropNames: settings.cropNames,
        ),
      ),
    );
    if (saved != true) {
      await ref.read(pestControlNotifierProvider(date).notifier).delete(id);
    }
  }
}

class _PestSummaryTile extends ConsumerWidget {
  final PestControl entry;
  final DateTime date;
  final SettingsState settings;

  const _PestSummaryTile({
    required this.entry,
    required this.date,
    required this.settings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cause = entry.cause.isNotEmpty ? entry.cause : '원인 미입력';
    final costStr = entry.cost > 0 ? '  •  ${_fmtCost(entry.cost)}원' : '';

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      title: Text(
        '${entry.cropName}  •  $cause',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text('${entry.method.isNotEmpty ? entry.method : '방법 미입력'}$costStr'),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        onPressed: () async {
          final ok = await confirmDelete(context);
          if (ok) {
            await ref
                .read(pestControlNotifierProvider(date).notifier)
                .softDelete(entry.id);
            await ref.read(syncStateProvider.notifier).push();
          }
        },
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PestEditScreen(
            entry: entry,
            date: date,
            cropNames: settings.cropNames,
          ),
        ),
      ),
    );
  }

  String _fmtCost(double c) => c
      .toInt()
      .toString()
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );
}

