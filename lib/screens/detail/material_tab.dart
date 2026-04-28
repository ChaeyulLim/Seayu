import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../providers/database_provider.dart';
import '../../providers/material_provider.dart';
import '../../providers/sheets_provider.dart';
import 'detail_helpers.dart';
import 'material_edit_screen.dart';

class MaterialTab extends ConsumerWidget {
  final DateTime date;
  const MaterialTab({super.key, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(materialItemsForDateProvider(date));

    return itemsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('오류: $e')),
      data: (items) => Column(
        children: [
          AddTile(
            label: '자재 추가',
            onTap: () => _addAndNavigate(context, ref),
          ),
          const Divider(height: 1),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text(
                      '자재 기록이 없습니다',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 16),
                    itemBuilder: (ctx, i) => _MaterialSummaryTile(
                      entry: items[i],
                      date: date,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _addAndNavigate(BuildContext context, WidgetRef ref) async {
    final id = await ref
        .read(materialItemNotifierProvider(date).notifier)
        .add(date);
    final db = ref.read(databaseProvider);
    final entry = await db.getMaterialItemById(id);
    if (entry == null || !context.mounted) return;
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => MaterialEditScreen(entry: entry, date: date),
      ),
    );
    if (saved != true) {
      await ref.read(materialItemNotifierProvider(date).notifier).delete(id);
    }
  }
}

class _MaterialSummaryTile extends ConsumerWidget {
  final MaterialItem entry;
  final DateTime date;

  const _MaterialSummaryTile({required this.entry, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = entry.content.isNotEmpty ? entry.content : '내용 없음';
    final costStr = entry.cost > 0
        ? '비용 ${_fmtCost(entry.cost)}원'
        : '비용 미입력';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      title: Text(
        content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(costStr),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        onPressed: () async {
          final ok = await confirmDelete(context);
          if (ok) {
            await ref
                .read(materialItemNotifierProvider(date).notifier)
                .softDelete(entry.id);
            await ref.read(syncStateProvider.notifier).push();
          }
        },
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MaterialEditScreen(entry: entry, date: date),
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
