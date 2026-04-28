import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../providers/pest_control_provider.dart';
import '../../providers/sheets_provider.dart';

class PestEditScreen extends ConsumerStatefulWidget {
  final PestControl entry;
  final DateTime date;
  final List<String> cropNames;

  const PestEditScreen({
    super.key,
    required this.entry,
    required this.date,
    required this.cropNames,
  });

  @override
  ConsumerState<PestEditScreen> createState() => _PestEditScreenState();
}

class _PestEditScreenState extends ConsumerState<PestEditScreen> {
  late TextEditingController _causeCtrl;
  late TextEditingController _methodCtrl;
  late TextEditingController _resultCtrl;
  late TextEditingController _costCtrl;
  late TextEditingController _noteCtrl;
  late String _selectedCrop;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _causeCtrl = TextEditingController(text: widget.entry.cause);
    _methodCtrl = TextEditingController(text: widget.entry.method);
    _resultCtrl = TextEditingController(text: widget.entry.result);
    _costCtrl = TextEditingController(
        text: widget.entry.cost == 0 ? '' : widget.entry.cost.toString());
    _noteCtrl = TextEditingController(text: widget.entry.note);
    _selectedCrop = widget.entry.cropName;
  }

  @override
  void dispose() {
    _causeCtrl.dispose();
    _methodCtrl.dispose();
    _resultCtrl.dispose();
    _costCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isSaving = true);
    try {
      final cost = double.tryParse(_costCtrl.text) ?? 0.0;
      await ref
          .read(pestControlNotifierProvider(widget.date).notifier)
          .update(widget.entry.copyWith(
            cropName: _selectedCrop,
            cause: _causeCtrl.text,
            method: _methodCtrl.text,
            result: _resultCtrl.text,
            cost: cost,
            note: _noteCtrl.text,
          ));
      await ref.read(syncStateProvider.notifier).push();
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allCrops =
        <String>{...widget.cropNames, widget.entry.cropName}.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('방제 수정')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        children: [
          InputDecorator(
            decoration: const InputDecoration(
              labelText: '작물명',
              border: OutlineInputBorder(),
            ),
            child: DropdownButton<String>(
              value: allCrops.contains(_selectedCrop)
                  ? _selectedCrop
                  : allCrops.first,
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

          TextField(
            controller: _causeCtrl,
            decoration: const InputDecoration(
              labelText: '방제 원인',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _methodCtrl,
            decoration: const InputDecoration(
              labelText: '방제 방법',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _resultCtrl,
            decoration: const InputDecoration(
              labelText: '방제 결과',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _costCtrl,
                  decoration: const InputDecoration(
                    labelText: '비용',
                    suffixText: '원',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,1}')),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _noteCtrl,
                  decoration: const InputDecoration(
                    labelText: '비고',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
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
