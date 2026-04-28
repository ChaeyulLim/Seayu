# 세아유 (Seayu) — 농장 작업일지

유기농 농장을 위한 작업 기록 앱입니다.  
작업 · 방제 · 자재 내역을 날짜별로 관리하고, Google Sheets와 자동으로 동기화합니다.

---

## 주요 기능

| 기능 | 설명 |
|------|------|
| 📅 캘린더 | 월별 달력에서 작업 기록이 있는 날짜를 점(마커)으로 표시 |
| ✏️ 작업 기록 | 날씨 · 작물명 · 작업내용 · 인원 · 일비 · 비고 입력 |
| 🌿 방제 기록 | 작물명 · 원인 · 방법 · 결과 · 비용 · 비고 입력 |
| 📦 자재 기록 | 자재 내용 · 비용 입력 |
| 🔍 검색 | 전체 작업 · 방제 · 자재를 키워드로 검색, 결과 탭으로 날짜 이동 |
| ☁️ Google Sheets 동기화 | 앱 ↔ 스프레드시트 양방향 동기화, 연도별 탭 자동 생성 |
| 🗑️ 소프트 삭제 | 삭제 시 앱에서만 숨김 처리, 시트에는 `[삭제]` 마커로 표시 |
| ⚙️ 설정 | 일당 · 작물명 목록 관리 |

---

## 화면 구성

```
캘린더 화면
├── AppBar: 검색 / 동기화 / 설정
├── 월별 캘린더 (헤더 탭 → 연도·월 이동)
└── 선택 날짜
    ├── 작업 탭
    ├── 방제 탭
    └── 자재 탭
```

---

## 시작하기

### 1. 저장소 클론

```bash
git clone <repo-url>
cd seayu
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### 2. Google Sheets 연동 설정

**서비스 계정 키 파일 준비**

1. [Google Cloud Console](https://console.cloud.google.com) → IAM → 서비스 계정 → 키 생성 (JSON)
2. 다운로드한 파일을 `assets/service_account.json` 으로 저장  
   (`assets/service_account.json.example` 참고)
3. 해당 서비스 계정 이메일을 스프레드시트 **편집자**로 공유

**Spreadsheet ID 설정**

```dart
// lib/core/config.dart
class AppConfig {
  static const String spreadsheetId = '여기에_스프레드시트_ID_입력';
}
```

스프레드시트 URL에서 ID 확인:  
`https://docs.google.com/spreadsheets/d/<<여기>>/edit`

### 3. 빌드

```bash
# Android APK
flutter build apk

# 디버그 실행
flutter run
```

---

## 스프레드시트 형식

연도별 탭(예: `2024`, `2025`)이 자동 생성됩니다.

| 행 | 내용 |
|----|------|
| 1행 | 제목 (`작업일지`) |
| 2행 | 빈 행 |
| 3행 | 카테고리 헤더 |
| 4행 | 컬럼 헤더 |
| 5행~ | 데이터 |

**컬럼 구조 (A~N)**

```
A: 날짜   B: 날씨   C: 작물명   D: 작업내용   E: 인원   F: 일비   G: 비고
H: 방제원인   I: 방법   J: 결과   K: 비용   L: 비고
M: 자재내용   N: 비용
```

같은 날짜에 여러 항목이 있는 경우 작업/방제/자재를 index 기준으로 같은 행에 배치합니다.  
삭제된 항목은 비고 컬럼에 `[삭제]` 마커가 표시됩니다.

---

## 기술 스택

| 항목 | 내용 |
|------|------|
| Framework | Flutter (Dart SDK ^3.5.0) |
| 상태관리 | flutter_riverpod ^2.6.1 |
| 로컬 DB | drift ^2.20.3 (SQLite) |
| Google Sheets | googleapis ^13.2.0 + googleapis_auth ^1.6.0 |
| 캘린더 UI | table_calendar ^3.1.2 |
| 네트워크 감지 | connectivity_plus ^6.1.1 |

---

## 기본 설정값

| 항목 | 기본값 |
|------|--------|
| 일당 | 110,000원 |
| 작물명 | 방울토마토, 포도, 사과대추, 기타 작업 |
| 날씨 선택지 | 맑음, 흐림, 비, 눈, 바람, 기타 |


