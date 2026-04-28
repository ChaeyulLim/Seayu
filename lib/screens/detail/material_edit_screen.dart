import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../providers/material_provider.dart';
import '../../providers/sheets_provider.dart';

class MaterialEditScreen extends ConsumerStatefulWidget {
  final MaterialItem entry;
  final DateTime date;

  const MaterialEditScreen({
    super.key,
    required this.entry,
    required this.date,
  });

  @override
  ConsumerState<MaterialEditScreen> createState() =>
      _MaterialEditScreenState();
}

class _MaterialEditScreenState extends ConsumerState<MaterialEditScreen> {
  late TextEditingController _contentCtrl;
  late TextEditingController _costCtrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _contentCtrl = TextEditingController(text: widget.entry.content);
    _costCtrl = TextEditingController(
        text: widget.entry.cost == 0 ? '' : widget.entry.cost.toString());
  }

  @override
  void dispose() {
    _contentCtrl.dispose();
    _costCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isSaving = true);
    try {
      final cost = double.tryParse(_costCtrl.text) ?? 0.0;
      await ref
          .read(materialItemNotifierProvider(widget.date).notifier)
          .update(widget.entry.copyWith(
            content: _contentCtrl.text,
            cost: cost,
          ));
      await ref.read(syncStateProvider.notifier).push();
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('자재 수정')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        children: [
          TextField(
            controller: _contentCtrl,
            decoration: const InputDecoration(
              labelText: '자재 내용',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _costCtrl,
            decoration: const InputDecoration(
              labelText: '비용',
              suffixText: '원',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
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
