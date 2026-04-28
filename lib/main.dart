import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'screens/calendar/calendar_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR');
  runApp(const ProviderScope(child: SeayuApp()));
}

class SeayuApp extends StatelessWidget {
  const SeayuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '농장 작업일지',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          isDense: true,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
      home: const CalendarScreen(),
    );
  }
}
