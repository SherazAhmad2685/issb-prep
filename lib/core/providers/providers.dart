import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_service.dart';
import '../models/models.dart';

// ── Progress Provider ────────────────────────────────────────────────────────

class ProgressProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  List<PaperResult> _results = [];
  bool _loading = false;

  List<PaperResult> get results => _results;
  bool get loading => _loading;

  List<PaperResult> get issbResults =>
      _results.where((r) => r.paperType == 'issb_intel').toList();

  List<PaperResult> get pmaResults =>
      _results.where((r) => r.paperType.startsWith('pma_')).toList();

  List<PaperResult> get pmaVerbalResults =>
      _results.where((r) => r.paperType == 'pma_verbal').toList();

  List<PaperResult> get pmaNonVerbalResults =>
      _results.where((r) => r.paperType == 'pma_nonverbal').toList();

  List<PaperResult> get pmaAcademicResults =>
      _results.where((r) => r.paperType == 'pma_academic').toList();

  List<PaperResult> get pmaFullResults =>
      _results.where((r) => r.paperType == 'pma_full' || r.paperType == 'pma_long').toList();

  double get overallAccuracy {
    if (_results.isEmpty) return 0;
    final avg = _results.map((r) => r.percentage).reduce((a, b) => a + b) /
        _results.length;
    return avg;
  }

  Map<String, double> get sectionAccuracy {
    final sections = <String, List<double>>{};
    for (final r in _results) {
      r.sectionScores.forEach((k, v) {
        sections.putIfAbsent(k, () => []).add(v);
      });
    }
    return sections.map((k, v) =>
        MapEntry(k, v.reduce((a, b) => a + b) / v.length));
  }

  List<String> get weakAreas {
    final acc = sectionAccuracy;
    return acc.entries
        .where((e) => e.value < 60)
        .map((e) => e.key)
        .toList();
  }

  int get streakDays {
    if (_results.isEmpty) return 0;
    final sortedDates = _results
        .map((r) => r.completedAt)
        .toList()
      ..sort((a, b) => b.compareTo(a));
    int streak = 1;
    for (int i = 0; i < sortedDates.length - 1; i++) {
      final diff = sortedDates[i].difference(sortedDates[i + 1]).inDays;
      if (diff == 1) {
        streak++;
      } else if (diff > 1) {
        break;
      }
    }
    return streak;
  }

  Future<void> loadResults() async {
    _loading = true;
    notifyListeners();
    _results = await _db.getPaperResults();
    _loading = false;
    notifyListeners();
  }

  Future<void> saveResult(PaperResult result, List<AnswerRecord> answers) async {
    await _db.savePaperResult(result, answers);
    await loadResults();
  }
}

// ── Paper Provider ────────────────────────────────────────────────────────────

class PaperProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  List<Question> _questions = [];
  Map<int, int?> _selectedAnswers = {}; // questionIndex -> selectedOptionIndex
  bool _loading = false;
  bool _submitted = false;
  String _paperType = 'issb_intel';
  bool _negativeMarking = false; // By default PMA computer test has NO negative marking

  List<Question> get questions => _questions;
  Map<int, int?> get selectedAnswers => _selectedAnswers;
  bool get loading => _loading;
  bool get submitted => _submitted;
  String get paperType => _paperType;
  bool get negativeMarking => _negativeMarking;

  int get totalQuestions => _questions.length;
  int get answered => _selectedAnswers.values.where((v) => v != null).length;
  int get remaining => totalQuestions - answered;

  bool isAnswered(int index) => _selectedAnswers[index] != null;

  void setNegativeMarking(bool val) {
    _negativeMarking = val;
    notifyListeners();
  }

  Future<void> loadIssbPaper() async {
    _loading = true;
    _submitted = false;
    _selectedAnswers = {};
    _paperType = 'issb_intel';
    notifyListeners();
    _questions = await _db.getIssbPaper();
    _loading = false;
    notifyListeners();
  }

  /// Load PMA Portion 1: Verbal Intelligence Test (84 Questions)
  Future<void> loadPmaVerbalPaper() async {
    _loading = true;
    _submitted = false;
    _selectedAnswers = {};
    _paperType = 'pma_verbal';
    notifyListeners();
    _questions = await _db.getPmaVerbalPaper(count: 84);
    _loading = false;
    notifyListeners();
  }

  /// Load PMA Portion 2: Non-Verbal Intelligence Test (64 Questions)
  Future<void> loadPmaNonVerbalPaper() async {
    _loading = true;
    _submitted = false;
    _selectedAnswers = {};
    _paperType = 'pma_nonverbal';
    notifyListeners();
    _questions = await _db.getPmaNonVerbalPaper(count: 64);
    _loading = false;
    notifyListeners();
  }

  /// Load PMA Portion 3: Academic Test (50 Questions)
  Future<void> loadPmaAcademicPaper() async {
    _loading = true;
    _submitted = false;
    _selectedAnswers = {};
    _paperType = 'pma_academic';
    notifyListeners();
    _questions = await _db.getPmaAcademicPaper(count: 50);
    _loading = false;
    notifyListeners();
  }

  /// Load Full PMA Long Course Simulation (198 Questions)
  Future<void> loadPmaFullPaper() async {
    _loading = true;
    _submitted = false;
    _selectedAnswers = {};
    _paperType = 'pma_full';
    notifyListeners();
    _questions = await _db.getPmaFullPaper();
    _loading = false;
    notifyListeners();
  }

  /// Alias for backward compatibility
  Future<void> loadPmaLongCoursePaper() => loadPmaFullPaper();

  void selectAnswer(int questionIndex, int optionIndex) {
    if (_submitted) return;
    _selectedAnswers[questionIndex] = optionIndex;
    notifyListeners();
  }

  void clearAnswer(int questionIndex) {
    if (_submitted) return;
    _selectedAnswers[questionIndex] = null;
    notifyListeners();
  }

  PaperResult submitPaper({int timeSpentSeconds = 0}) {
    _submitted = true;
    int correct = 0, wrong = 0;
    final answers = <AnswerRecord>[];
    final sectionCorrect = <String, int>{};
    final sectionTotal = <String, int>{};

    for (int i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      final selected = _selectedAnswers[i];
      sectionTotal[q.section] = (sectionTotal[q.section] ?? 0) + 1;

      if (selected == null) {
        answers.add(AnswerRecord(
            questionId: q.id, selectedIndex: null, isCorrect: false));
      } else if (selected == q.correctIndex) {
        correct++;
        sectionCorrect[q.section] = (sectionCorrect[q.section] ?? 0) + 1;
        answers.add(AnswerRecord(
            questionId: q.id, selectedIndex: selected, isCorrect: true));
      } else {
        wrong++;
        answers.add(AnswerRecord(
            questionId: q.id, selectedIndex: selected, isCorrect: false));
      }
    }

    final double maxScore = totalQuestions.toDouble();
    final double score = PaperResult.calculateScore(
      correct: correct,
      wrong: wrong,
      negativeMarking: _negativeMarking,
    );

    final sectionScores = sectionTotal.map((section, total) {
      final c = sectionCorrect[section] ?? 0;
      return MapEntry(section, total > 0 ? (c / total) * 100 : 0.0);
    });

    notifyListeners();
    return PaperResult(
      id: 0,
      paperType: _paperType,
      completedAt: DateTime.now(),
      totalQuestions: totalQuestions,
      attempted: correct + wrong,
      correct: correct,
      wrong: wrong,
      score: score,
      maxScore: maxScore,
      sectionScores: sectionScores,
      timeSpentSeconds: timeSpentSeconds,
    );
  }

  List<AnswerRecord> getAnswerRecords() {
    final records = <AnswerRecord>[];
    for (int i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      final selected = _selectedAnswers[i];
      records.add(AnswerRecord(
        questionId: q.id,
        selectedIndex: selected,
        isCorrect: selected != null && selected == q.correctIndex,
      ));
    }
    return records;
  }

  void reset() {
    _questions = [];
    _selectedAnswers = {};
    _submitted = false;
    notifyListeners();
  }
}

// ── Drill Provider (WAT / SRT) ────────────────────────────────────────────────

class DrillProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  List<WatWord> _watWords = [];
  List<SrtSituation> _srtSituations = [];
  int _currentIndex = 0;
  bool _loading = false;
  bool _drillComplete = false;

  List<WatWord> get watWords => _watWords;
  List<SrtSituation> get srtSituations => _srtSituations;
  int get currentIndex => _currentIndex;
  bool get loading => _loading;
  bool get drillComplete => _drillComplete;

  WatWord? get currentWat =>
      _watWords.isNotEmpty && _currentIndex < _watWords.length
          ? _watWords[_currentIndex]
          : null;

  SrtSituation? get currentSrt =>
      _srtSituations.isNotEmpty && _currentIndex < _srtSituations.length
          ? _srtSituations[_currentIndex]
          : null;

  Future<void> loadWatDrill({int count = 25}) async {
    _loading = true;
    _currentIndex = 0;
    _drillComplete = false;
    notifyListeners();
    _watWords = await _db.getWatWords(count);
    _loading = false;
    notifyListeners();
  }

  Future<void> loadSrtDrill({int count = 15}) async {
    _loading = true;
    _currentIndex = 0;
    _drillComplete = false;
    notifyListeners();
    _srtSituations = await _db.getSrtSituations(count);
    _loading = false;
    notifyListeners();
  }

  void advance() {
    final total = _watWords.isNotEmpty
        ? _watWords.length
        : _srtSituations.length;
    if (_currentIndex < total - 1) {
      _currentIndex++;
    } else {
      _drillComplete = true;
    }
    notifyListeners();
  }

  void reset() {
    _currentIndex = 0;
    _drillComplete = false;
    _watWords = [];
    _srtSituations = [];
    notifyListeners();
  }
}

// ── Preferences Provider ──────────────────────────────────────────────────────

class PreferencesProvider extends ChangeNotifier {
  bool _negativeMarkingDefault = true;
  int _streakDays = 0;
  String _lastPracticeDate = '';

  bool get negativeMarkingDefault => _negativeMarkingDefault;
  int get streakDays => _streakDays;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _negativeMarkingDefault = prefs.getBool('negative_marking') ?? true;
    _streakDays = prefs.getInt('streak_days') ?? 0;
    _lastPracticeDate = prefs.getString('last_practice_date') ?? '';

    // Update streak
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (_lastPracticeDate == today) {
      // already counted today
    } else if (_lastPracticeDate ==
        DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String()
            .substring(0, 10)) {
      _streakDays++;
      await prefs.setInt('streak_days', _streakDays);
      await prefs.setString('last_practice_date', today);
    } else if (_lastPracticeDate != today) {
      _streakDays = 1;
      await prefs.setInt('streak_days', _streakDays);
      await prefs.setString('last_practice_date', today);
    }
    notifyListeners();
  }

  Future<void> setNegativeMarking(bool val) async {
    _negativeMarkingDefault = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('negative_marking', val);
    notifyListeners();
  }
}
