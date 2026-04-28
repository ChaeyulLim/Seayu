import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/database_provider.dart';

class SearchResult {
  final DateTime date;
  final int tabIndex;
  final String typeLabel;
  final String title;
  final String subtitle;

  const SearchResult({
    required this.date,
    required this.tabIndex,
    required this.typeLabel,
    required this.title,
    required this.subtitle,
  });
}

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _ctrl = TextEditingController();
  List<SearchResult> _results = [];
  bool _loading = false;
  bool _searched = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    final q = query.trim();
    if (q.isEmpty) {
      setState(() {
        _results = [];
        _searched = false;
      });
      return;
    }

    setState(() => _loading = true);
    final db = ref.read(databaseProvider);

    final works = await db.searchWorkLogs(q);
    final pests = await db.searchPestControls(q);
    final materials = await db.searchMaterialItems(q);

    final results = <SearchResult>[];

    for (final w in works) {
      final content = w.workContent.isNotEmpty ? w.workContent : '내용 없음';
      final weather = w.weather.isNotEmpty ? '${w.weather}  ' : '';
      results.add(SearchResult(
        date: w.date,
        tabIndex: 0,
        typeLabel: '작업',
        title: '$weather${w.cropName}  •  $content',
        subtitle: _fmtWorkers(w.workers, w.dailyWage),
      ));
    }

    for (final p in pests) {
      final cause = p.cause.isNotEmpty ? p.cause : '원인 미입력';
      results.add(SearchResult(
        date: p.date,
        tabIndex: 1,
        typeLabel: '방제',
        title: '${p.cropName}  •  $cause',
        subtitle: p.method.isNotEmpty ? p.method : '방법 미입력',
      ));
    }

    for (final m in materials) {
      final content = m.content.isNotEmpty ? m.content : '내용 없음';
      results.add(SearchResult(
        date: m.date,
        tabIndex: 2,
        typeLabel: '자재',
        title: content,
        subtitle: m.cost > 0 ? '비용 ${_fmtCost(m.cost)}원' : '비용 미입력',
      ));
    }

    results.sort((a, b) => b.date.compareTo(a.date));

    setState(() {
      _results = results;
      _loading = false;
      _searched = true;
    });
  }

  String _fmtWorkers(double workers, int wage) {
    final w = workers == workers.truncateToDouble()
        ? workers.toInt().toString()
        : workers.toString();
    final wageStr =
        wage.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return '인원 $w명  •  일비 $wageStr원';
  }

  String _fmtCost(double c) => c
      .toInt()
      .toString()
      .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '검색어를 입력하세요',
            border: InputBorder.none,
          ),
          onChanged: _search,
        ),
        actions: [
          if (_ctrl.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _ctrl.clear();
                _search('');
              },
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : !_searched
              ? const Center(
                  child: Text(
                    '검색어를 입력하세요',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : _results.isEmpty
                  ? const Center(
                      child: Text(
                        '검색 결과가 없습니다',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _results.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, indent: 16),
                      itemBuilder: (ctx, i) =>
                          _ResultTile(result: _results[i]),
                    ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final SearchResult result;
  const _ResultTile({required this.result});

  @override
  Widget build(BuildContext context) {
    final dateStr =
        DateFormat('yyyy년 M월 d일 (E)', 'ko_KR').format(result.date);
    final color = switch (result.tabIndex) {
      0 => Colors.blue,
      1 => Colors.orange,
      _ => Colors.green,
    };

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          result.typeLabel,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
      title: Text(
        result.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '$dateStr\n${result.subtitle}',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      isThreeLine: true,
      onTap: () => Navigator.pop(context, result),
    );
  }
}
