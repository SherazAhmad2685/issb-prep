import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/models.dart';
import 'question_bank_expansion.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static Database? _db;

  // Web in-memory storage fallback
  List<Question>? _webQuestionsCache;
  final List<PaperResult> _webResultsCache = [];
  final Map<int, List<AnswerRecord>> _webAnswersCache = {};
  final Map<String, String> _webStats = {};

  DatabaseService._();
  factory DatabaseService() => _instance ??= DatabaseService._();

  List<Question> _getWebQuestions() {
    if (_webQuestionsCache != null) return _webQuestionsCache!;
    final maps = _buildQuestionBank();
    _webQuestionsCache = maps.map(Question.fromMap).toList();
    return _webQuestionsCache!;
  }

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    if (kIsWeb) {
      throw UnsupportedError('SQLite is not directly used on web, in-memory fallback active.');
    }
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'issb_prep.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY,
        text TEXT NOT NULL,
        opt_a TEXT NOT NULL,
        opt_b TEXT NOT NULL,
        opt_c TEXT NOT NULL,
        opt_d TEXT NOT NULL,
        correct_index INTEGER NOT NULL,
        section TEXT NOT NULL,
        category TEXT NOT NULL,
        image_path TEXT,
        explanation TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE paper_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        paper_type TEXT NOT NULL,
        completed_at TEXT NOT NULL,
        total_questions INTEGER NOT NULL,
        attempted INTEGER NOT NULL,
        correct INTEGER NOT NULL,
        wrong INTEGER NOT NULL,
        score REAL NOT NULL,
        max_score REAL NOT NULL,
        section_scores TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE answer_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        result_id INTEGER NOT NULL,
        question_id INTEGER NOT NULL,
        selected_index INTEGER,
        is_correct INTEGER NOT NULL,
        FOREIGN KEY (result_id) REFERENCES paper_results(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE user_stats (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE wat_words (
        id INTEGER PRIMARY KEY,
        word TEXT NOT NULL,
        positive_associations TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE srt_situations (
        id INTEGER PRIMARY KEY,
        situation TEXT NOT NULL,
        model_answer TEXT NOT NULL
      )
    ''');

    // Seed question bank
    await _seedQuestions(db);
    await _seedWat(db);
    await _seedSrt(db);
  }

  // ── Seed Data ────────────────────────────────────────────────────────────

  Future<void> _seedQuestions(Database db) async {
    final List<Map<String, dynamic>> questions = _buildQuestionBank();
    final batch = db.batch();
    for (final q in questions) {
      batch.insert('questions', q);
    }
    await batch.commit(noResult: true);
  }

  Future<void> _seedWat(Database db) async {
    final words = _buildWatWords();
    final batch = db.batch();
    for (final w in words) {
      batch.insert('wat_words', w);
    }
    await batch.commit(noResult: true);
  }

  Future<void> _seedSrt(Database db) async {
    final situations = _buildSrtSituations();
    final batch = db.batch();
    for (final s in situations) {
      batch.insert('srt_situations', s);
    }
    await batch.commit(noResult: true);
  }

  // ── Queries ──────────────────────────────────────────────────────────────

  Future<List<Question>> getQuestionsBySection(String section, int limit) async {
    if (kIsWeb) {
      final all = _getWebQuestions()
          .where((q) => q.section.toLowerCase() == section.toLowerCase())
          .toList()
        ..shuffle();
      return all.take(limit).toList();
    }
    final db = await database;
    final rows = await db.query(
      'questions',
      where: 'section = ?',
      whereArgs: [section],
      orderBy: 'RANDOM()',
      limit: limit,
    );
    return rows.map(Question.fromMap).toList();
  }

  /// PMA Long Course - Portion 1: Verbal Intelligence Test (84 Questions)
  Future<List<Question>> getPmaVerbalPaper({int count = 84}) async {
    final list = await getQuestionsBySection('verbal', count);
    if (list.length < count && kIsWeb) {
      // If bank has fewer unique, repeat/cycle with distinct IDs so candidate gets 84 questions
      final result = <Question>[...list];
      int i = 0;
      while (result.length < count && list.isNotEmpty) {
        final orig = list[i % list.length];
        result.add(Question(
          id: 10000 + result.length,
          text: orig.text,
          options: orig.options,
          correctIndex: orig.correctIndex,
          section: orig.section,
          category: orig.category,
          explanation: orig.explanation,
        ));
        i++;
      }
      return result;
    }
    return list;
  }

  /// PMA Long Course - Portion 2: Non-Verbal Intelligence Test (64 Questions)
  Future<List<Question>> getPmaNonVerbalPaper({int count = 64}) async {
    final list = await getQuestionsBySection('nonverbal', count);
    if (list.length < count) {
      final result = <Question>[...list];
      int i = 0;
      while (result.length < count && list.isNotEmpty) {
        final orig = list[i % list.length];
        result.add(Question(
          id: 20000 + result.length,
          text: orig.text,
          options: orig.options,
          correctIndex: orig.correctIndex,
          section: orig.section,
          category: orig.category,
          explanation: orig.explanation,
        ));
        i++;
      }
      return result;
    }
    return list;
  }

  /// PMA Long Course - Portion 3: Academic & General Knowledge Test (50 Questions)
  /// Breakdown: Pak Studies (~15 Qs), Islamic Studies (~10 Qs), World GK (~10 Qs), English (~8 Qs), Maths (~7 Qs)
  Future<List<Question>> getPmaAcademicPaper({int count = 50}) async {
    final gk = await getQuestionsBySection('gk', 35);
    final english = await getQuestionsBySection('english', 8);
    final math = await getQuestionsBySection('math', 7);
    final all = [...gk, ...english, ...math];
    all.shuffle();
    if (all.length < count) {
      final extra = await getQuestionsBySection('gk', count - all.length);
      all.addAll(extra);
    }
    return all.take(count).toList();
  }

  /// PMA Long Course - Full Official Exam Simulation (198 Questions total)
  /// Sequenced exactly like AS&RC computer tests:
  /// 1. Verbal (84 Qs)
  /// 2. Non-Verbal (64 Qs)
  /// 3. Academic (50 Qs)
  Future<List<Question>> getPmaFullPaper() async {
    final verbal = await getPmaVerbalPaper(count: 84);
    final nonVerbal = await getPmaNonVerbalPaper(count: 64);
    final academic = await getPmaAcademicPaper(count: 50);
    return [...verbal, ...nonVerbal, ...academic];
  }

  /// Legacy alias
  Future<List<Question>> getPmaLongCoursePaper() => getPmaFullPaper();

  /// Returns a mixed paper: verbalCount verbal, nonVerbalCount non-verbal, gkCount GK
  Future<List<Question>> getIssbPaper({
    int verbalCount = 100,
    int nonVerbalCount = 50,
    int gkCount = 50,
  }) async {
    final verbal = await getQuestionsBySection('verbal', verbalCount);
    final nonVerbal = await getQuestionsBySection('nonverbal', nonVerbalCount);
    final gk = await getQuestionsBySection('gk', gkCount);
    final all = [...verbal, ...nonVerbal, ...gk];
    all.shuffle();
    return all;
  }

  Future<int> savePaperResult(PaperResult r, List<AnswerRecord> answers) async {
    if (kIsWeb) {
      final id = _webResultsCache.length + 1;
      final saved = PaperResult(
        id: id,
        paperType: r.paperType,
        completedAt: r.completedAt,
        totalQuestions: r.totalQuestions,
        attempted: r.attempted,
        correct: r.correct,
        wrong: r.wrong,
        score: r.score,
        maxScore: r.maxScore,
        sectionScores: r.sectionScores,
        timeSpentSeconds: r.timeSpentSeconds,
      );
      _webResultsCache.insert(0, saved);
      _webAnswersCache[id] = answers;
      return id;
    }

    final db = await database;
    final resultId = await db.insert('paper_results', {
      'paper_type': r.paperType,
      'completed_at': r.completedAt.toIso8601String(),
      'total_questions': r.totalQuestions,
      'attempted': r.attempted,
      'correct': r.correct,
      'wrong': r.wrong,
      'score': r.score,
      'max_score': r.maxScore,
      'section_scores': r.sectionScores.entries
          .map((e) => '${e.key}:${e.value}')
          .join(','),
    });
    final batch = db.batch();
    for (final a in answers) {
      batch.insert('answer_log', {
        'result_id': resultId,
        'question_id': a.questionId,
        'selected_index': a.selectedIndex,
        'is_correct': a.isCorrect ? 1 : 0,
      });
    }
    await batch.commit(noResult: true);
    return resultId;
  }

  Future<List<PaperResult>> getPaperResults({String? paperType}) async {
    if (kIsWeb) {
      if (paperType == null) return List.from(_webResultsCache);
      return _webResultsCache.where((r) => r.paperType == paperType).toList();
    }

    final db = await database;
    final rows = await db.query(
      'paper_results',
      where: paperType != null ? 'paper_type = ?' : null,
      whereArgs: paperType != null ? [paperType] : null,
      orderBy: 'completed_at DESC',
    );
    return rows.map((m) {
      final sectionScoresStr = m['section_scores'] as String;
      final sectionScores = <String, double>{};
      if (sectionScoresStr.isNotEmpty) {
        for (final part in sectionScoresStr.split(',')) {
          final kv = part.split(':');
          if (kv.length == 2) {
            sectionScores[kv[0]] = double.tryParse(kv[1]) ?? 0;
          }
        }
      }
      return PaperResult(
        id: m['id'] as int,
        paperType: m['paper_type'] as String,
        completedAt: DateTime.parse(m['completed_at'] as String),
        totalQuestions: m['total_questions'] as int,
        attempted: m['attempted'] as int,
        correct: m['correct'] as int,
        wrong: m['wrong'] as int,
        score: (m['score'] as num).toDouble(),
        maxScore: (m['max_score'] as num).toDouble(),
        sectionScores: sectionScores,
      );
    }).toList();
  }

  Future<List<WatWord>> getWatWords(int count) async {
    if (kIsWeb) {
      final list = _buildWatWords();
      list.shuffle();
      return list.take(count).map((m) => WatWord(
        id: m['id'] as int,
        word: m['word'] as String,
        positiveAssociations: (m['positive_associations'] as String).split('|'),
      )).toList();
    }
    final db = await database;
    final rows = await db.query('wat_words', orderBy: 'RANDOM()', limit: count);
    return rows.map((m) => WatWord(
          id: m['id'] as int,
          word: m['word'] as String,
          positiveAssociations:
              (m['positive_associations'] as String).split('|'),
        )).toList();
  }

  Future<List<SrtSituation>> getSrtSituations(int count) async {
    if (kIsWeb) {
      final list = _buildSrtSituations();
      list.shuffle();
      return list.take(count).map((m) => SrtSituation(
        id: m['id'] as int,
        situation: m['situation'] as String,
        modelAnswer: m['model_answer'] as String,
      )).toList();
    }
    final db = await database;
    final rows =
        await db.query('srt_situations', orderBy: 'RANDOM()', limit: count);
    return rows.map((m) => SrtSituation(
          id: m['id'] as int,
          situation: m['situation'] as String,
          modelAnswer: m['model_answer'] as String,
        )).toList();
  }

  Future<String?> getStat(String key) async {
    if (kIsWeb) return _webStats[key];
    final db = await database;
    final rows =
        await db.query('user_stats', where: 'key = ?', whereArgs: [key]);
    return rows.isEmpty ? null : rows.first['value'] as String;
  }

  Future<void> setStat(String key, String value) async {
    if (kIsWeb) {
      _webStats[key] = value;
      return;
    }
    final db = await database;
    await db.insert(
      'user_stats',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ── Question Bank Seed ───────────────────────────────────────────────────

  List<Map<String, dynamic>> _buildQuestionBank() {
    int id = 1;
    final List<Map<String, dynamic>> qs = [];

    // ── VERBAL (300) ──────────────────────────────────────────────────────
    final verbal = [
      // Analogies
      ['Book : Library :: Painting : ?', 'Museum', 'School', 'Theatre', 'Garden', 0, 'verbal', 'analogy'],
      ['Doctor : Patient :: Teacher : ?', 'Hospital', 'Student', 'School', 'Book', 1, 'verbal', 'analogy'],
      ['Pen : Write :: Knife : ?', 'Cut', 'Cook', 'Carve', 'Stab', 0, 'verbal', 'analogy'],
      ['Fish : Water :: Bird : ?', 'Tree', 'Air', 'Sky', 'Nest', 2, 'verbal', 'analogy'],
      ['Sun : Day :: Moon : ?', 'Night', 'Star', 'Light', 'Dark', 0, 'verbal', 'analogy'],
      ['Car : Road :: Boat : ?', 'Water', 'River', 'Sea', 'Lake', 0, 'verbal', 'analogy'],
      ['Eye : See :: Ear : ?', 'Listen', 'Hear', 'Sound', 'Noise', 1, 'verbal', 'analogy'],
      ['King : Palace :: President : ?', 'House', 'Castle', 'White House', 'Office', 2, 'verbal', 'analogy'],
      ['Wheat : Flour :: Grape : ?', 'Wine', 'Juice', 'Raisin', 'Fruit', 0, 'verbal', 'analogy'],
      ['Barber : Scissors :: Carpenter : ?', 'Saw', 'Knife', 'Hammer', 'Drill', 0, 'verbal', 'analogy'],
      ['Brick : Wall :: Word : ?', 'Sentence', 'Letter', 'Essay', 'Book', 0, 'verbal', 'analogy'],
      ['Cow : Calf :: Horse : ?', 'Foal', 'Pup', 'Cub', 'Kid', 0, 'verbal', 'analogy'],
      ['Writer : Pen :: Painter : ?', 'Canvas', 'Brush', 'Paint', 'Colour', 1, 'verbal', 'analogy'],
      ['Iron : Metal :: Diamond : ?', 'Stone', 'Carbon', 'Gem', 'Crystal', 1, 'verbal', 'analogy'],
      ['Mountain : Hill :: Ocean : ?', 'Sea', 'River', 'Lake', 'Pond', 0, 'verbal', 'analogy'],
      // Series
      ['2, 4, 8, 16, ?', '24', '30', '32', '36', 2, 'verbal', 'series'],
      ['1, 4, 9, 16, ?', '20', '25', '24', '36', 1, 'verbal', 'series'],
      ['3, 6, 12, 24, ?', '36', '42', '48', '60', 2, 'verbal', 'series'],
      ['5, 10, 20, 40, ?', '60', '75', '80', '100', 2, 'verbal', 'series'],
      ['1, 2, 4, 7, 11, ?', '14', '16', '15', '18', 1, 'verbal', 'series'],
      ['100, 50, 25, ?', '10', '12', '12.5', '15', 2, 'verbal', 'series'],
      ['Z, Y, X, W, ?', 'U', 'V', 'T', 'S', 1, 'verbal', 'series'],
      ['A, C, E, G, ?', 'H', 'I', 'J', 'K', 1, 'verbal', 'series'],
      ['B, D, G, K, ?', 'N', 'O', 'P', 'Q', 2, 'verbal', 'series'],
      ['2, 6, 12, 20, 30, ?', '40', '42', '44', '50', 1, 'verbal', 'series'],
      // Coding-Decoding
      ['If CAT = 3120, what is DOG?', '4157', '4167', '4015', '4175', 1, 'verbal', 'coding'],
      ['If ARMY = BSNZ, what is NAVY?', 'OBWZ', 'OCWZ', 'OBXZ', 'OAWZ', 0, 'verbal', 'coding'],
      ['If SOLDIER = 1234567, what is SLIDE?', '12345', '12456', '12354', '12346', 2, 'verbal', 'coding'],
      ['If SWORD = TXPSE, what is SHIELD?', 'TIJFME', 'TIJGME', 'TIJFMD', 'TKJFME', 0, 'verbal', 'coding'],
      ['If MEDAL = 13-5-4-1-12, what is BADGE?', '2-1-4-7-5', '2-1-4-8-5', '3-1-4-7-5', '2-2-4-7-5', 0, 'verbal', 'coding'],
      // Synonyms
      ['BRAVE', 'Timid', 'Courageous', 'Weak', 'Fearful', 1, 'verbal', 'synonym'],
      ['PROFICIENT', 'Skilled', 'Novice', 'Amateur', 'Clumsy', 0, 'verbal', 'synonym'],
      ['DILIGENT', 'Lazy', 'Careless', 'Hardworking', 'Slow', 2, 'verbal', 'synonym'],
      ['GALLANT', 'Cowardly', 'Brave', 'Timid', 'Afraid', 1, 'verbal', 'synonym'],
      ['ASTUTE', 'Dull', 'Clever', 'Ignorant', 'Naive', 1, 'verbal', 'synonym'],
      ['VIGILANT', 'Careless', 'Watchful', 'Sleeping', 'Slow', 1, 'verbal', 'synonym'],
      ['TENACIOUS', 'Giving up', 'Persistent', 'Weak', 'Fragile', 1, 'verbal', 'synonym'],
      ['ELOQUENT', 'Silent', 'Fluent in speech', 'Dumb', 'Shy', 1, 'verbal', 'synonym'],
      ['INTREPID', 'Fearful', 'Bold', 'Hesitant', 'Timid', 1, 'verbal', 'synonym'],
      ['CANDID', 'Dishonest', 'Frank', 'Secretive', 'Shy', 1, 'verbal', 'synonym'],
      // Antonyms
      ['VICTORY', 'Success', 'Win', 'Defeat', 'Glory', 2, 'verbal', 'antonym'],
      ['ADVANCE', 'Progress', 'Retreat', 'Move', 'Forward', 1, 'verbal', 'antonym'],
      ['LOYALTY', 'Faithfulness', 'Devotion', 'Betrayal', 'Allegiance', 2, 'verbal', 'antonym'],
      ['COURAGE', 'Bravery', 'Cowardice', 'Boldness', 'Valor', 1, 'verbal', 'antonym'],
      ['DISCIPLINE', 'Order', 'Structure', 'Chaos', 'Regulation', 2, 'verbal', 'antonym'],
      ['UNITY', 'Togetherness', 'Harmony', 'Division', 'Solidarity', 2, 'verbal', 'antonym'],
      ['STRENGTH', 'Power', 'Weakness', 'Force', 'Might', 1, 'verbal', 'antonym'],
      ['HONOR', 'Pride', 'Shame', 'Glory', 'Respect', 1, 'verbal', 'antonym'],
      ['ATTACK', 'Offense', 'Assault', 'Defense', 'Strike', 2, 'verbal', 'antonym'],
      ['ORDER', 'Command', 'Chaos', 'Direction', 'Rule', 1, 'verbal', 'antonym'],
      // Classification / Odd one out (verbal)
      ['Which does NOT belong: MAJOR, COLONEL, MINISTER, GENERAL', 'Major', 'Colonel', 'Minister', 'General', 2, 'verbal', 'classification'],
      ['Which does NOT belong: SWORD, RIFLE, SPEAR, SHIELD', 'Sword', 'Rifle', 'Spear', 'Shield', 3, 'verbal', 'classification'],
      ['Which does NOT belong: EAGLE, FALCON, HAWK, SHARK', 'Eagle', 'Falcon', 'Hawk', 'Shark', 3, 'verbal', 'classification'],
      ['Which does NOT belong: DIESEL, PETROL, KEROSENE, IRON', 'Diesel', 'Petrol', 'Kerosene', 'Iron', 3, 'verbal', 'classification'],
      ['Which does NOT belong: PLATOON, COMPANY, BRIGADE, APARTMENT', 'Platoon', 'Company', 'Brigade', 'Apartment', 3, 'verbal', 'classification'],
    ];

    for (final v in verbal) {
      qs.add({
        'id': id++,
        'text': v[0],
        'opt_a': v[1],
        'opt_b': v[2],
        'opt_c': v[3],
        'opt_d': v[4],
        'correct_index': v[5],
        'section': v[6],
        'category': v[7],
        'image_path': null,
        'explanation': null,
      });
    }

    // Add more verbal questions to reach ~150 unique verbal seed questions
    // (The remaining 150+ will be generated by pattern in a real app)
    final moreVerbal = [
      ['Find the odd one out: Triangle, Square, Pentagon, Circle', 'Triangle', 'Square', 'Pentagon', 'Circle', 3, 'verbal', 'classification'],
      ['Complete: AZ, BY, CX, ?', 'DV', 'DW', 'EV', 'DX', 1, 'verbal', 'series'],
      ['If FIRE = 6-9-18-5, then WATER = ?', '23-1-20-5-18', '22-1-20-5-18', '23-2-20-5-18', '23-1-21-5-18', 0, 'verbal', 'coding'],
      ['OBEDIENT is to DISCIPLINE as BRAVE is to ?', 'Fear', 'Order', 'Courage', 'Peace', 2, 'verbal', 'analogy'],
      ['Pakistan : Islamabad :: China : ?', 'Shanghai', 'Beijing', 'Hong Kong', 'Chengdu', 1, 'verbal', 'analogy'],
      ['4, 9, 25, 49, ?', '81', '100', '121', '64', 2, 'verbal', 'series'],
      ['MAGNANIMOUS means?', 'Selfish', 'Generous', 'Angry', 'Weak', 1, 'verbal', 'synonym'],
      ['Antonym of TRANQUIL?', 'Calm', 'Peaceful', 'Turbulent', 'Placid', 2, 'verbal', 'antonym'],
      ['ACE, BDF, CEG, ?', 'DEH', 'DFH', 'DFG', 'EFH', 1, 'verbal', 'series'],
      ['DEMOCRACY : VOTING :: JUSTICE : ?', 'Crime', 'Law', 'Police', 'Court', 1, 'verbal', 'analogy'],
    ];

    for (final v in moreVerbal) {
      qs.add({
        'id': id++,
        'text': v[0],
        'opt_a': v[1],
        'opt_b': v[2],
        'opt_c': v[3],
        'opt_d': v[4],
        'correct_index': v[5],
        'section': v[6],
        'category': v[7],
        'image_path': null,
        'explanation': null,
      });
    }

    // ── NON-VERBAL (100) ──────────────────────────────────────────────────
    // Text-described non-verbal (images will be added later)
    final nonVerbal = [
      ['Which shape has MORE sides: Pentagon or Hexagon?', 'Pentagon (5)', 'Hexagon (6)', 'Both equal', 'Neither', 1, 'nonverbal', 'geometry'],
      ['A square is rotated 90°. What does it look like?', 'Rectangle', 'Square (same)', 'Diamond', 'Triangle', 1, 'nonverbal', 'rotation'],
      ['How many triangles in a regular hexagon divided by diagonals?', '4', '6', '8', '12', 1, 'nonverbal', 'counting'],
      ['Mirror image of "b" is?', 'd', 'p', 'q', 'b', 1, 'nonverbal', 'mirror'],
      ['Water image of "A" is?', 'V', 'A (upside down)', 'A (same)', 'Λ', 1, 'nonverbal', 'mirror'],
      ['If a clock shows 3:00, what does its mirror image show?', '9:00', '6:00', '3:00', '12:00', 0, 'nonverbal', 'mirror'],
      ['A cube has how many faces?', '4', '6', '8', '12', 1, 'nonverbal', 'cube'],
      ['A cube has how many edges?', '8', '10', '12', '16', 2, 'nonverbal', 'cube'],
      ['A cube has how many vertices?', '6', '8', '10', '12', 1, 'nonverbal', 'cube'],
      ['Pattern: ○ △ ○ △ ○ ?', '○', '△', '□', '◇', 1, 'nonverbal', 'pattern'],
      ['What shape comes next: □ □□ □□□ ?', '□', '□□□□', '□□', '□□□□□', 1, 'nonverbal', 'pattern'],
      ['Number of squares in a 3×3 grid?', '9', '12', '14', '16', 2, 'nonverbal', 'counting'],
      ['A right triangle has angles of 90° and 45°. What is the third?', '30°', '45°', '60°', '35°', 1, 'nonverbal', 'geometry'],
      ['If you fold a paper in half twice, how many layers?', '2', '4', '6', '8', 1, 'nonverbal', 'folding'],
      ['Odd one out by shape: Circle, Sphere, Oval, Hexagon', 'Circle', 'Sphere', 'Oval', 'Hexagon', 1, 'nonverbal', 'classification'],
      ['Which has the most sides: Octagon, Heptagon, Nonagon, Hexagon?', 'Octagon', 'Heptagon', 'Nonagon', 'Hexagon', 2, 'nonverbal', 'geometry'],
      ['A pattern repeats every 4 shapes. Shape 17 is position?', '1', '2', '3', '4', 0, 'nonverbal', 'pattern'],
      ['How many small cubes form a 2×2×2 large cube?', '4', '6', '8', '12', 2, 'nonverbal', 'cube'],
      ['How many small cubes in a 3×3×3?', '9', '18', '27', '36', 2, 'nonverbal', 'cube'],
      ['Embedded figure: A triangle hidden in a pentagon is?', 'Always visible', 'Never there', 'Present inside', 'Impossible', 2, 'nonverbal', 'embedded'],
    ];

    for (final v in nonVerbal) {
      qs.add({
        'id': id++,
        'text': v[0],
        'opt_a': v[1],
        'opt_b': v[2],
        'opt_c': v[3],
        'opt_d': v[4],
        'correct_index': v[5],
        'section': v[6],
        'category': v[7],
        'image_path': null,
        'explanation': null,
      });
    }

    // ── GENERAL KNOWLEDGE (120) ──────────────────────────────────────────
    final gk = [
      // Pakistan & Armed Forces
      ['Who is the founder of Pakistan?', 'Liaquat Ali Khan', 'Quaid-e-Azam Muhammad Ali Jinnah', 'Allama Iqbal', 'Sir Syed Ahmad Khan', 1, 'gk', 'pakistan'],
      ['Pakistan achieved independence on?', 'August 14, 1947', 'August 15, 1947', 'August 14, 1948', 'July 14, 1947', 0, 'gk', 'pakistan'],
      ['Capital of Pakistan?', 'Lahore', 'Karachi', 'Islamabad', 'Rawalpindi', 2, 'gk', 'pakistan'],
      ['National language of Pakistan?', 'Punjabi', 'Sindhi', 'Urdu', 'Pashto', 2, 'gk', 'pakistan'],
      ['Pakistan Military Academy (PMA) is located in?', 'Rawalpindi', 'Abbottabad', 'Kakul', 'Murree', 2, 'gk', 'military'],
      ['Who is the Chief of Army Staff (COAS) of Pakistan in recent years?', 'General Qamar Bajwa', 'General Asim Munir', 'General Raheel Sharif', 'General Ashfaq Kayani', 1, 'gk', 'military'],
      ['Pakistan Navy Headquarters is in?', 'Karachi', 'Islamabad', 'Rawalpindi', 'Lahore', 0, 'gk', 'military'],
      ['PAF (Pakistan Air Force) training academy is in?', 'Karachi', 'Risalpur', 'Lahore', 'Quetta', 1, 'gk', 'military'],
      ['National animal of Pakistan?', 'Snow Leopard', 'Markhor', 'Lion', 'Tiger', 1, 'gk', 'pakistan'],
      ['National bird of Pakistan?', 'Eagle', 'Sparrow', 'Shaheen (Peregrine Falcon)', 'Peacock', 2, 'gk', 'pakistan'],
      // Geography
      ['Highest mountain in Pakistan?', 'Nanga Parbat', 'Tirich Mir', 'K-2', 'Rakaposhi', 2, 'gk', 'geography'],
      ['Longest river in Pakistan?', 'Chenab', 'Jhelum', 'Indus', 'Ravi', 2, 'gk', 'geography'],
      ['Pakistan shares the longest border with?', 'India', 'Afghanistan', 'Iran', 'China', 1, 'gk', 'geography'],
      ['Which province has the largest area in Pakistan?', 'Punjab', 'Sindh', 'Balochistan', 'KPK', 2, 'gk', 'geography'],
      ['Which province has the highest population?', 'Sindh', 'Punjab', 'Balochistan', 'KPK', 1, 'gk', 'geography'],
      // Islamic Studies
      ['The Holy Quran was revealed in?', 'Makkah', 'Madinah', 'Both Makkah and Madinah', 'Jerusalem', 2, 'gk', 'islamic'],
      ['How many Surahs are in the Holy Quran?', '110', '112', '114', '116', 2, 'gk', 'islamic'],
      ['The first Revelation was sent to the Prophet (PBUH) in?', 'Cave Thawr', 'Cave Hira', 'Masjid Al-Haram', 'Madinah', 1, 'gk', 'islamic'],
      ['Hijri year starts from?', 'Birth of Prophet (PBUH)', 'Migration to Madinah (Hijrat)', 'Battle of Badr', 'Conquest of Makkah', 1, 'gk', 'islamic'],
      ['Zakat is compulsory on Muslims with Nisab held for?', '6 months', '1 year (lunar)', '2 years', '3 months', 1, 'gk', 'islamic'],
      // Current Affairs & World
      ['United Nations was founded in?', '1944', '1945', '1946', '1947', 1, 'gk', 'world'],
      ['UN headquarters is in?', 'Washington DC', 'Geneva', 'New York', 'London', 2, 'gk', 'world'],
      ['SCO stands for?', 'South Cooperation Organization', 'Shanghai Cooperation Organisation', 'Security Council Order', 'Sino-Central Order', 1, 'gk', 'world'],
      ['CPEC stands for?', 'China Pakistan Energy Corridor', 'China Pakistan Economic Corridor', 'Central Pakistan Economic Council', 'China Pakistan Export Corridor', 1, 'gk', 'pakistan'],
      ['Pakistan\'s nuclear tests (Chagai) took place in?', '1995', '1996', '1997', '1998', 3, 'gk', 'pakistan'],
      // Science & General
      ['Speed of light is approximately?', '3×10⁶ m/s', '3×10⁸ m/s', '3×10¹⁰ m/s', '3×10⁴ m/s', 1, 'gk', 'science'],
      ['Water boils at ___ degrees Celsius at sea level?', '90', '95', '100', '105', 2, 'gk', 'science'],
      ['DNA stands for?', 'Deoxyribonucleic Acid', 'Diribonucleic Acid', 'Dioxynucleic Acid', 'Deoxyribose Nucleic Arrangement', 0, 'gk', 'science'],
      ['The largest planet in the Solar System?', 'Saturn', 'Neptune', 'Jupiter', 'Uranus', 2, 'gk', 'science'],
      ['Islamabad was made the capital of Pakistan in?', '1959', '1962', '1966', '1969', 2, 'gk', 'pakistan'],
    ];

    for (final v in gk) {
      qs.add({
        'id': id++,
        'text': v[0],
        'opt_a': v[1],
        'opt_b': v[2],
        'opt_c': v[3],
        'opt_d': v[4],
        'correct_index': v[5],
        'section': v[6],
        'category': v[7],
        'image_path': null,
        'explanation': null,
      });
    }

    // ── ENGLISH (80) ─────────────────────────────────────────────────────
    final english = [
      ['Choose the correctly spelled word:', 'Recieve', 'Receive', 'Receve', 'Receeve', 1, 'english', 'spelling'],
      ['Choose the correctly spelled word:', 'Commitee', 'Committee', 'Comittee', 'Committte', 1, 'english', 'spelling'],
      ['Fill in the blank: He is __ honest man.', 'a', 'an', 'the', 'no article', 1, 'english', 'grammar'],
      ['Fill in the blank: She __ to school every day.', 'go', 'goes', 'going', 'gone', 1, 'english', 'grammar'],
      ['Fill in the blank: They __ playing football now.', 'is', 'are', 'was', 'were', 1, 'english', 'grammar'],
      ['The soldier fought __ bravely.', 'more', 'very', 'quite', 'much', 1, 'english', 'grammar'],
      ['Plural of "Analysis"?', 'Analysises', 'Analyzes', 'Analyses', 'Analysis', 2, 'english', 'grammar'],
      ['Plural of "Criterion"?', 'Criterions', 'Criteria', 'Criterias', 'Criterion', 1, 'english', 'grammar'],
      ['Passive voice: "The general commanded the troops."', 'The troops were commanded by the general.', 'The troops are commanded by the general.', 'The troops commanded the general.', 'The general was commanded the troops.', 0, 'english', 'grammar'],
      ['Choose the correct sentence:', 'He don\'t know the answer.', 'He doesn\'t knows the answer.', 'He doesn\'t know the answer.', 'He not know the answer.', 2, 'english', 'grammar'],
      ['Synonym of "Diligent"?', 'Lazy', 'Hardworking', 'Careless', 'Slow', 1, 'english', 'vocabulary'],
      ['Antonym of "Cowardice"?', 'Fear', 'Weakness', 'Bravery', 'Timidity', 2, 'english', 'vocabulary'],
      ['"She ran __ the field." — correct preposition:', 'into', 'across', 'under', 'between', 1, 'english', 'grammar'],
      ['Identify the adjective: "The brave soldier won a medal."', 'soldier', 'won', 'brave', 'medal', 2, 'english', 'grammar'],
      ['Which is a compound sentence?', 'She sang.', 'He ran fast.', 'She sang and he played.', 'Because it was raining.', 2, 'english', 'grammar'],
    ];

    for (final v in english) {
      qs.add({
        'id': id++,
        'text': v[0],
        'opt_a': v[1],
        'opt_b': v[2],
        'opt_c': v[3],
        'opt_d': v[4],
        'correct_index': v[5],
        'section': v[6],
        'category': v[7],
        'image_path': null,
        'explanation': null,
      });
    }

    // ── MATHEMATICS (80) ──────────────────────────────────────────────────
    final math = [
      ['What is 15% of 200?', '25', '30', '35', '40', 1, 'math', 'percentage'],
      ['If 3x + 7 = 22, then x = ?', '4', '5', '6', '7', 1, 'math', 'algebra'],
      ['Area of a rectangle 8m × 5m?', '35 m²', '40 m²', '45 m²', '50 m²', 1, 'math', 'geometry'],
      ['A train travels 120 km in 2 hours. Speed?', '50 km/h', '55 km/h', '60 km/h', '65 km/h', 2, 'math', 'speed'],
      ['LCM of 12 and 18?', '24', '30', '36', '48', 2, 'math', 'numbers'],
      ['HCF of 24 and 36?', '6', '8', '12', '18', 2, 'math', 'numbers'],
      ['√144 = ?', '11', '12', '13', '14', 1, 'math', 'numbers'],
      ['2³ × 2² = ?', '2⁴', '2⁵', '2⁶', '2⁷', 1, 'math', 'algebra'],
      ['If a:b = 3:5 and b = 25, then a = ?', '12', '13', '15', '18', 2, 'math', 'ratio'],
      ['Perimeter of a square with side 7 cm?', '21 cm', '28 cm', '35 cm', '42 cm', 1, 'math', 'geometry'],
      ['A man buys at Rs. 80 and sells at Rs. 100. Profit %?', '20%', '25%', '30%', '40%', 1, 'math', 'profit'],
      ['Average of 10, 20, 30, 40, 50?', '25', '30', '35', '40', 1, 'math', 'statistics'],
      ['If x/4 = 8, then x = ?', '24', '28', '32', '36', 2, 'math', 'algebra'],
      ['Volume of a cube with side 3 cm?', '9 cm³', '18 cm³', '27 cm³', '36 cm³', 2, 'math', 'geometry'],
      ['A can do work in 10 days, B in 15 days. Together?', '4 days', '5 days', '6 days', '7 days', 2, 'math', 'work'],
    ];

    for (final v in math) {
      qs.add({
        'id': id++,
        'text': v[0],
        'opt_a': v[1],
        'opt_b': v[2],
        'opt_c': v[3],
        'opt_d': v[4],
        'correct_index': v[5],
        'section': v[6],
        'category': v[7],
        'image_path': null,
        'explanation': null,
      });
    }

    // Add expanded questions from all categories
    final expansionQs = [
      ...QuestionBankExpansion.verbalQuestions(),
      ...QuestionBankExpansion.gkQuestions(),
      ...QuestionBankExpansion.englishQuestions(),
      ...QuestionBankExpansion.mathQuestions(),
      ...QuestionBankExpansion.nonVerbalQuestions(),
    ];
    for (final eq in expansionQs) {
      final map = eq.toMap();
      map['id'] = id++;
      qs.add(map);
    }

    return qs;
  }

  List<Map<String, dynamic>> _buildWatWords() {
    final words = [
      ['Leadership', 'Guidance|Responsibility|Vision|Command|Direction'],
      ['Courage', 'Bravery|Boldness|Valor|Fearlessness|Strength'],
      ['Discipline', 'Order|Control|Punctuality|Obedience|Structure'],
      ['Honesty', 'Integrity|Truth|Sincerity|Transparency|Trust'],
      ['Teamwork', 'Cooperation|Unity|Collaboration|Support|Together'],
      ['Challenge', 'Opportunity|Growth|Test|Overcome|Strength'],
      ['Fear', 'Overcome|Conquer|Face|Challenge|Courage'],
      ['Failure', 'Learn|Overcome|Rebuild|Lesson|Grow'],
      ['Conflict', 'Resolve|Negotiate|Peace|Mediate|Solution'],
      ['Risk', 'Calculated|Manage|Assess|Overcome|Strategic'],
      ['Loyalty', 'Devotion|Commitment|Allegiance|Faithfulness|Support'],
      ['Initiative', 'Lead|Proactive|Action|Creative|Drive'],
      ['Responsibility', 'Duty|Accountability|Commitment|Obligation|Trust'],
      ['Pakistan', 'Pride|Service|Nation|Army|Patriotism'],
      ['Death', 'Sacrifice|Duty|Honor|Martyrdom|Service'],
      ['War', 'Defence|Strategy|Protect|Victory|Nation'],
      ['Problem', 'Solution|Analyze|Overcome|Creative|Think'],
      ['Pressure', 'Perform|Calm|Focus|Overcome|Handle'],
      ['Success', 'Hard work|Achievement|Goal|Dedication|Effort'],
      ['Duty', 'Honor|Responsibility|Nation|Service|Commitment'],
      ['Anger', 'Control|Manage|Calm|Channel|Patience'],
      ['Weakness', 'Improve|Overcome|Identify|Work|Strength'],
      ['Enemy', 'Defend|Strategy|Protect|Overcome|Defeat'],
      ['Sacrifice', 'Honor|Duty|Country|Courage|Service'],
      ['Mission', 'Accomplish|Plan|Execute|Complete|Succeed'],
    ];
    return words.asMap().entries.map((e) => {
      'id': e.key + 1,
      'word': e.value[0],
      'positive_associations': e.value[1],
    }).toList();
  }

  List<Map<String, dynamic>> _buildSrtSituations() {
    final situations = [
      ['You are on patrol and find a wounded civilian. Your mission is time-sensitive.',
       'Provide immediate first aid, radio for medical support, assign one soldier to stay, and continue mission with remaining team.'],
      ['Your section commander is absent. A fire breaks out in the camp.',
       'Take charge immediately, sound the alarm, organize fire-fighting parties, evacuate personnel, and report to senior officer.'],
      ['A junior soldier refuses to follow your order during an exercise.',
       'Calmly explain the reason, motivate through leadership, and if persistent, take formal disciplinary action.'],
      ['You discover a fellow cadet cheating during an important test.',
       'Report it to the invigilator/authority promptly and honestly, maintaining integrity.'],
      ['Your team is exhausted mid-hike but the destination must be reached by night.',
       'Motivate the team, redistribute loads, set short achievable milestones, maintain pace.'],
      ['You are lost in jungle terrain with limited supplies.',
       'Stay calm, assess resources, identify natural landmarks, conserve energy, signal for help.'],
      ['Two subordinates are fighting physically in the barracks.',
       'Intervene immediately to separate them, address root cause, counsel both parties, report if serious.'],
      ['You receive orders you believe are tactically wrong.',
       'Execute the order, then respectfully present your concerns to the commander through proper channel.'],
      ['Your vehicle breaks down on a critical supply route.',
       'Organize local security, attempt repairs, radio for support, and explore alternate routes.'],
      ['A civilian approaches your post in restricted area at night.',
       'Challenge per procedure, verify identity, detain if suspicious, report to officer immediately.'],
      ['Flood hits a village near your deployment area.',
       'Request permission to assist, organize rescue teams, prioritize women/children/elderly.'],
      ['You find ammunition missing from the armory during inspection.',
       'Report immediately to commander, secure the area, initiate investigation, document everything.'],
      ['A senior cadet bullies a junior during training.',
       'Confront the bully calmly, support the junior, report to course officer.'],
      ['Your group has a disagreement on the best route during a GPE.',
       'Listen to all views, analyze pros/cons, take decision, move forward with group consensus.'],
      ['You witness a fellow soldier accepting a bribe.',
       'Immediately report to superior officer. Maintain integrity of the unit.'],
    ];
    return situations.asMap().entries.map((e) => {
      'id': e.key + 1,
      'situation': e.value[0],
      'model_answer': e.value[1],
    }).toList();
  }
}
