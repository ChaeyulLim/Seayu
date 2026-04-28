import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../providers/sheets_provider.dart';
import '../../providers/work_log_provider.dart';

const _weatherPresets = ['맑음', '흐림', '비', '눈', '바람', '기타'];

class WorkEditScreen extends ConsumerStatefulWidget {
  final WorkLog log;
  final DateTime date;
  final List<String> cropNames;
  final int dailyWage;

  const WorkEditScreen({
    super.key,
    required this.log,
    required this.date,
    required this.cropNames,
    required this.dailyWage,
  });

  @override
  ConsumerState<WorkEditScreen> createState() => _WorkEditScreenState();
}

class _WorkEditScreenState extends ConsumerState<WorkEditScreen> {
  late String _weatherDropdown;
  late TextEditingController _weatherCustomCtrl;
  late TextEditingController _contentCtrl;
  late TextEditingController _workersCtrl;
  late TextEditingController _noteCtrl;
  late String _selectedCrop;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.log.weather;
    final isPreset = _weatherPresets.contains(existing) && existing != '기타';
    _weatherDropdown = isPreset ? existing : (existing.isEmpty ? '맑음' : '기타');
    _weatherCustomCtrl = TextEditingController(
      text: (!isPreset && existing.isNotEmpty) ? existing : '',
    );
    _contentCtrl = TextEditingController(text: widget.log.workContent);
    _workersCtrl = TextEditingController(text: _fmtNum(widget.log.workers));
    _noteCtrl = TextEditingController(text: widget.log.workNote);
    _selectedCrop = widget.log.cropName;
  }

  @override
  void dispose() {
    _weatherCustomCtrl.dispose();
    _contentCtrl.dispose();
    _workersCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  String _fmtNum(double v) =>
      v == v.truncateToDouble() ? v.toInt().toString() : v.toString();

  String get _weatherValue =>
      _weatherDropdown == '기타' ? _weatherCustomCtrl.text : _weatherDropdown;

  int get _computedWage {
    final w = double.tryParse(_workersCtrl.text) ?? 0.0;
    return (w * widget.dailyWage).round();
  }

  Future<void> _submit() async {
    final workers = double.tryParse(_workersCtrl.text) ?? 0.0;
    if (workers < 0) return;
    final wage = (workers * widget.dailyWage).round();
    setState(() => _isSaving = true);
    try {
      await ref.read(workLogNotifierProvider(widget.date).notifier).update(
            widget.log.copyWith(
              weather: _weatherValue,
              cropName: _selectedCrop,
              workContent: _contentCtrl.text,
              workers: workers,
              dailyWage: wage,
              workNote: _noteCtrl.text,
            ),
          );
      await ref.read(syncStateProvider.notifier).push();
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allCrops = <String>{...widget.cropNames, widget.log.cropName}.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('작업 수정')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        children: [
          // ── 날씨 ─────────────────────────────────────────────────────────
          if (_weatherDropdown == '기타')
            TextField(
              controller: _weatherCustomCtrl,
              decoration: InputDecoration(
                labelText: '날씨 (직접 입력)',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  tooltip: '목록으로',
                  onPressed: () => setState(() => _weatherDropdown = '맑음'),
                ),
              ),
            )
          else
            InputDecorator(
              decoration: const InputDecoration(
                labelText: '날씨',
                border: OutlineInputBorder(),
              ),
              child: DropdownButton<String>(
                value: _weatherDropdown,
                isExpanded: true,
                underline: const SizedBox(),
                items: _weatherPresets
                    .map((w) => DropdownMenuItem(value: w, child: Text(w)))
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => _weatherDropdown = v);
                },
              ),
            ),
          const SizedBox(height: 16),

          // ── 작물명 ────────────────────────────────────────────────────────
          InputDecorator(
            decoration: const InputDecoration(
              labelText: '작물명',
              border: OutlineInputBorder(),
            ),
            child: DropdownButton<String>(
              value: allCrops.contains(_selectedCrop) ? _selectedCrop : allCrops.first,
              isExpanded: true,
              underline: const SizedBox(),
              items: allCrops
                  .map((c) => DropdownMenuItem<String>(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _selectedCrop = v);
              },
            ),
          ),
          const SizedBox(height: 16),

          // ── 작업내용 ──────────────────────────────────────────────────────
          TextField(
            controller: _contentCtrl,
            decoration: const InputDecoration(
              labelText: '작업내용',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          // ── 인원 / 일비 ───────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _workersCtrl,
                  decoration: const InputDecoration(
                    labelText: '인원',
                    hintText: '0',
                    suffixText: '명',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: '일비 (자동계산)',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    '${_computedWage.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── 비고 ──────────────────────────────────────────────────────────
          TextField(
            controller: _noteCtrl,
            decoration: const InputDecoration(
              labelText: '비고',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: _isSaving ? null : _submit,
            child: _isSaving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('등록/수정'),
          ),
        ),
      ),
    );
  }
}
