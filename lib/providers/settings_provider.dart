import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';
import 'database_provider.dart';

class SettingsState {
  final int dailyWage;
  final List<String> cropNames;
  final bool isLoaded;

  const SettingsState({
    this.dailyWage = AppConstants.defaultDailyWage,
    this.cropNames = AppConstants.defaultCropNames,
    this.isLoaded = false,
  });

  SettingsState copyWith({
    int? dailyWage,
    List<String>? cropNames,
    bool? isLoaded,
  }) =>
      SettingsState(
        dailyWage: dailyWage ?? this.dailyWage,
        cropNames: cropNames ?? this.cropNames,
        isLoaded: isLoaded ?? this.isLoaded,
      );
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final Ref _ref;

  SettingsNotifier(this._ref) : super(const SettingsState()) {
    _load();
  }

  Future<void> _load() async {
    final db = _ref.read(databaseProvider);
    final all = await db.getAllSettings();

    final wageStr = all[AppConstants.keyDailyWage];
    final cropStr = all[AppConstants.keyCropNames];

    state = state.copyWith(
      dailyWage: wageStr != null
          ? (int.tryParse(wageStr) ?? AppConstants.defaultDailyWage)
          : AppConstants.defaultDailyWage,
      cropNames: cropStr != null && cropStr.isNotEmpty
          ? cropStr.split(',').where((s) => s.isNotEmpty).toList()
          : AppConstants.defaultCropNames,
      isLoaded: true,
    );
  }

  Future<void> setDailyWage(int wage) async {
    final db = _ref.read(databaseProvider);
    await db.setSetting(AppConstants.keyDailyWage, wage.toString());
    state = state.copyWith(dailyWage: wage);
  }

  Future<void> addCrop(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty || state.cropNames.contains(trimmed)) return;
    final updated = [...state.cropNames, trimmed];
    await _saveCropNames(updated);
    state = state.copyWith(cropNames: updated);
  }

  Future<void> removeCrop(String name) async {
    final updated = state.cropNames.where((c) => c != name).toList();
    await _saveCropNames(updated);
    state = state.copyWith(cropNames: updated);
  }

  Future<void> _saveCropNames(List<String> names) async {
    final db = _ref.read(databaseProvider);
    await db.setSetting(AppConstants.keyCropNames, names.join(','));
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(ref),
);
