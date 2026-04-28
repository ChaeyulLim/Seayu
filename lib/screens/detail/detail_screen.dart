import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'material_tab.dart';
import 'pest_tab.dart';
import 'work_tab.dart';

class DetailScreen extends StatelessWidget {
  final DateTime date;

  const DetailScreen({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final title = DateFormat('yyyy년 M월 d일 (E)', 'ko_KR').format(date);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: const TabBar(
            tabs: [
              Tab(text: '작업'),
              Tab(text: '방제'),
              Tab(text: '자재'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            WorkTab(date: date),
            PestTab(date: date),
            MaterialTab(date: date),
          ],
        ),
      ),
    );
  }
}
