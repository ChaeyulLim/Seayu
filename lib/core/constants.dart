class AppConstants {
  static const String settingsSheet = '설정';
  static const String keyDailyWage = 'daily_wage';
  static const String keyCropNames = 'crop_names';
  static const String keySpreadsheetId = 'spreadsheet_id';

  static const int defaultDailyWage = 110000;
  static const List<String> defaultCropNames = ['방울토마토', '포도', '사과대추', '기타 작업'];

  static const List<String> weatherOptions = ['맑음', '흐림', '비', '눈', '바람', '기타'];

  // Sheet column indices (0-based, A~N)
  static const int colDate = 0;
  static const int colWeather = 1;
  static const int colCropName = 2;
  static const int colWorkContent = 3;
  static const int colWorkers = 4;
  static const int colDailyWage = 5;
  static const int colWorkNote = 6;
  static const int colPestCause = 7;
  static const int colPestMethod = 8;
  static const int colPestResult = 9;
  static const int colPestCost = 10;
  static const int colPestNote = 11;
  static const int colMaterialContent = 12;
  static const int colMaterialCost = 13;
  static const int totalColumns = 14;

  static const String serviceAccountAssetPath = 'assets/service_account.json';
}
