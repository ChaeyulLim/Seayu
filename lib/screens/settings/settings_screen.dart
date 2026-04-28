import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _wageCtrl;
  late TextEditingController _cropCtrl;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);
    _wageCtrl = TextEditingController(text: settings.dailyWage.toString());
    _cropCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _wageCtrl.dispose();
    _cropCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── 일당 설정 ─────────────────────────────────────────────────────
          _SectionHeader('일당 설정'),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _wageCtrl,
                  decoration: const InputDecoration(
                    labelText: '일당 (원)',
                    suffixText: '원',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  final wage = int.tryParse(_wageCtrl.text);
                  if (wage == null || wage <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('올바른 금액을 입력하세요.')),
                    );
                    return;
                  }
                  ref.read(settingsProvider.notifier).setDailyWage(wage);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('일당이 저장되었습니다.')),
                  );
                },
                child: const Text('저장'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── 작물명 관리 ───────────────────────────────────────────────────
          _SectionHeader('작물명 관리'),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: settings.cropNames.map((crop) {
              return Chip(
                label: Text(crop),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () =>
                    ref.read(settingsProvider.notifier).removeCrop(crop),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _cropCtrl,
                  decoration: const InputDecoration(
                    labelText: '작물명 추가',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: _addCrop,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _addCrop(_cropCtrl.text),
                child: const Text('추가'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addCrop(String value) {
    final name = value.trim();
    if (name.isEmpty) return;
    ref.read(settingsProvider.notifier).addCrop(name);
    _cropCtrl.clear();
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
