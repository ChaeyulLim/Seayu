import 'package:flutter/material.dart';

class AddTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const AddTile({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.add_circle_outline, color: Colors.green),
      title: Text(
        label,
        style: const TextStyle(
            color: Colors.green, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }
}

Future<bool> confirmDelete(BuildContext context) async =>
    await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('삭제'),
        content: const Text('이 항목을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ??
    false;
