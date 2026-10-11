// ─── Data Models ───────────────────────────────────────────────────────────

/// A single question in the question bank
class Question {
  final int id;
  final String text;
  final List<String> options;   // exactly 4 options
  final int correctIndex;       // 0-3
  final String section;         // 'verbal' | 'nonverbal' | 'gk' | 'english' | 'math' | 'intelligence'
  final String category;        // sub-category e.g. 'analogy', 'series', 'matrix'
  final String? imagePath;      // for non-verbal image questions
  final String? explanation;

  const Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.section,
    required this.category,
    this.imagePath,
    this.explanation,
  });

  factory Question.fromMap(Map<String, dynamic> m) => Question(
        id: m['id'] as int,
        text: m['text'] as String,
        options: [m['opt_a'], m['opt_b'], m['opt_c'], m['opt_d']]
            .map((e) => e.toString())
            .toList(),
        correctIndex: m['correct_index'] as int,
        section: m['section'] as String,
        category: m['category'] as String,
        imagePath: m['image_path'] as String?,
        explanation: m['explanation'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'text': text,
        'opt_a': options[0],
        'opt_b': options[1],
        'opt_c': options[2],
        'opt_d': options[3],
        'correct_index': correctIndex,
        'section': section,
        'category': category,
        'image_path': imagePath,
        'explanation': explanation,
      };
}

/// A submitted answer during a paper attempt
class AnswerRecord {
  final int questionId;
  final int? selectedIndex; // null = skipped
  final bool isCorrect;

  const AnswerRecord({
    required this.questionId,
    required this.selectedIndex,
    required this.isCorrect,
  });
}

/// Result of a completed practice paper
class PaperResult {
  final int id;
  final String paperType;       // 'issb_intel' | 'pma_long' | 'pma_verbal' | 'pma_nonverbal' | 'pma_academic' | 'pma_full'
  final DateTime completedAt;
  final int totalQuestions;
  final int attempted;
  final int correct;
  final int wrong;
  final double score;           // marks obtained
  final double maxScore;
  final Map<String, double> sectionScores; // section -> score
  final int timeSpentSeconds;

  const PaperResult({
    required this.id,
    required this.paperType,
    required this.completedAt,
    required this.totalQuestions,
    required this.attempted,
    required this.correct,
    required this.wrong,
    required this.score,
    required this.maxScore,
    required this.sectionScores,
    this.timeSpentSeconds = 0,
  });

  /// Percentage out of total test questions
  double get percentage => maxScore > 0 ? (score / maxScore) * 100 : 0;

  /// Accuracy percentage out of questions actually attempted
  double get percentageAttempted =>
      attempted > 0 ? (correct / attempted) * 100 : 0;

  int get skipped => totalQuestions - attempted;

  /// Passing criteria set to 60% (hardened threshold for rigorous prep)
  bool get isPassed => percentage >= 60.0;

  /// PMA Long Course scoring: standard is +1 per correct, 0 for wrong,
  /// with optional negative marking of -0.25 for strict simulation.
  static double calculateScore({
    required int correct,
    required int wrong,
    bool negativeMarking = false,
  }) {
    final double base = correct.toDouble();
    final double penalty = negativeMarking ? wrong * 0.25 : 0;
    return (base - penalty).clamp(0, double.infinity);
  }
}

/// WAT (Word Association Test) session word
class WatWord {
  final int id;
  final String word;
  final List<String> positiveAssociations;

  const WatWord({
    required this.id,
    required this.word,
    required this.positiveAssociations,
  });
}

/// SRT (Situation Reaction Test) situation
class SrtSituation {
  final int id;
  final String situation;
  final String modelAnswer;

  const SrtSituation({
    required this.id,
    required this.situation,
    required this.modelAnswer,
  });
}

/// TAT/PPDT picture
class TatPicture {
  final int id;
  final String imagePath;
  final String hint;
  final String sampleStoryIdea;

  const TatPicture({
    required this.id,
    required this.imagePath,
    required this.hint,
    required this.sampleStoryIdea,
  });
}

/// GTO task description card
class GtoTask {
  final String name;
  final String description;
  final String tips;
  final String iconEmoji;

  const GtoTask({
    required this.name,
    required this.description,
    required this.tips,
    required this.iconEmoji,
  });
}

/// User progress summary
class UserProgress {
  final double overallAccuracy;
  final int totalPapersAttempted;
  final int streakDays;
  final Map<String, double> sectionAccuracy;
  final List<String> weakAreas;

  const UserProgress({
    required this.overallAccuracy,
    required this.totalPapersAttempted,
    required this.streakDays,
    required this.sectionAccuracy,
    required this.weakAreas,
  });
}
