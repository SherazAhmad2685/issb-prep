import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/models.dart';

class AnswerReviewScreen extends StatefulWidget {
  final PaperResult result;
  final List<Question> questions;
  final List<AnswerRecord> answers;

  const AnswerReviewScreen({
    super.key,
    required this.result,
    required this.questions,
    required this.answers,
  });

  @override
  State<AnswerReviewScreen> createState() => _AnswerReviewScreenState();
}

class _AnswerReviewScreenState extends State<AnswerReviewScreen> {
  String _filter = 'all'; // 'all', 'correct', 'wrong', 'skipped'

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final pctTotal = result.percentage;
    final pctAttempted = result.percentageAttempted;
    final isPassed = result.isPassed; // Hardened 60% threshold

    final statusColor = isPassed ? AppTheme.success : AppTheme.error;
    final statusLabel = isPassed ? 'PASSED — QUALIFIED' : 'FAILED — BELOW 60%';

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'Official Test Result Review',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        backgroundColor: AppTheme.background,
        leading: IconButton(
          onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
          icon: const Icon(Icons.home_rounded),
          tooltip: 'Back to Home',
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              // ── Main Score Card ───────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      statusColor.withValues(alpha: 0.18),
                      AppTheme.surface,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withValues(alpha: 0.45)),
                ),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      children: [
                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: statusColor.withValues(alpha: 0.6)),
                          ),
                          child: Text(
                            statusLabel,
                            style: GoogleFonts.poppins(
                              color: statusColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Dual Percentage Gauges (Total Questions vs Attempted Questions)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // 1. Marks from Total Questions
                            _buildScoreCircle(
                              label: 'Score from Total',
                              percentage: pctTotal,
                              marksString: '${result.score.toStringAsFixed(1)} / ${result.totalQuestions}',
                              color: statusColor,
                            ),

                            // 2. Marks from Attempted Questions (Accuracy)
                            _buildScoreCircle(
                              label: 'Accuracy (Attempted)',
                              percentage: pctAttempted,
                              marksString: '${result.correct} / ${result.attempted}',
                              color: pctAttempted >= 60 ? AppTheme.accent : AppTheme.warning,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Criteria Notice
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            isPassed
                                ? '🎉 Congratulations! You achieved ${pctTotal.toStringAsFixed(1)}%, exceeding the official 60% requirement.'
                                : '⚠️ You achieved ${pctTotal.toStringAsFixed(1)}%. Minimum passing threshold is 60.0% to advance.',
                            style: GoogleFonts.poppins(
                              color: isPassed ? AppTheme.success : AppTheme.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Detailed Stat Chips Row
                        Wrap(
                          spacing: 12,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            _statChip('Total Qs', '${result.totalQuestions}', AppTheme.textPrimary),
                            _statChip('Attempted', '${result.attempted}', AppTheme.accent),
                            _statChip('Skipped', '${result.skipped}', AppTheme.textSecondary),
                            _statChip('Correct', '${result.correct}', AppTheme.success),
                            _statChip('Wrong', '${result.wrong}', AppTheme.error),
                            if (result.timeSpentSeconds > 0)
                              _statChip(
                                'Time Taken',
                                '${result.timeSpentSeconds ~/ 60}m ${result.timeSpentSeconds % 60}s',
                                AppTheme.info,
                              ),
                          ],
                        ),
                      ],
                    ),

                    if (isPassed)
                      Positioned(
                        top: 10,
                        child: IgnorePointer(
                          child: Lottie.asset(
                            'assets/lottie/celebrate.json',
                            width: 220,
                            height: 220,
                            repeat: false,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Section Breakdown ─────────────────────────────────────
              if (result.sectionScores.isNotEmpty) ...[
                Text(
                  'Section Breakdown (60% Benchmark)',
                  style: GoogleFonts.poppins(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 12),
                ...result.sectionScores.entries.map((e) => _sectionBar(e.key, e.value)),
                const SizedBox(height: 24),
              ],

              // ── Question Review Header & Filters ───────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question-by-Question Review',
                    style: GoogleFonts.poppins(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Filter Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterChip('all', 'All (${widget.questions.length})'),
                    const SizedBox(width: 8),
                    _filterChip('correct', 'Correct (${result.correct})', color: AppTheme.success),
                    const SizedBox(width: 8),
                    _filterChip('wrong', 'Wrong (${result.wrong})', color: AppTheme.error),
                    const SizedBox(width: 8),
                    _filterChip('skipped', 'Skipped (${result.skipped})', color: AppTheme.textSecondary),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ── Questions List ────────────────────────────────────────
              ..._buildFilteredQuestionsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCircle({
    required String label,
    required double percentage,
    required String marksString,
    required Color color,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 105,
              height: 105,
              child: CircularProgressIndicator(
                value: (percentage / 100).clamp(0.0, 1.0),
                strokeWidth: 9,
                backgroundColor: AppTheme.border,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: GoogleFonts.poppins(
                    color: color,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  marksString,
                  style: GoogleFonts.poppins(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppTheme.textPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _statChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.w700, fontSize: 15),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(color: AppTheme.textSecondary, fontSize: 9),
          ),
        ],
      ),
    );
  }

  Widget _sectionBar(String section, double pct) {
    final color = pct >= 60 ? AppTheme.success : AppTheme.error;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _sectionLabel(section),
                  style: GoogleFonts.poppins(color: AppTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                '${pct.toStringAsFixed(0)}%  ${pct >= 60 ? "✓" : "✗"}',
                style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.w700, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: (pct / 100).clamp(0.0, 1.0),
            backgroundColor: AppTheme.border,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String filterKey, String label, {Color? color}) {
    final isSelected = _filter == filterKey;
    final activeColor = color ?? AppTheme.accent;

    return ChoiceChip(
      selected: isSelected,
      onSelected: (_) => setState(() => _filter = filterKey),
      label: Text(
        label,
        style: GoogleFonts.poppins(
          color: isSelected ? Colors.black : AppTheme.textSecondary,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 11,
        ),
      ),
      selectedColor: activeColor,
      backgroundColor: AppTheme.surface,
      side: BorderSide(color: isSelected ? activeColor : AppTheme.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  List<Widget> _buildFilteredQuestionsList() {
    final list = <Widget>[];

    for (int i = 0; i < widget.questions.length; i++) {
      final q = widget.questions[i];
      final a = widget.answers[i];

      final isSkipped = a.selectedIndex == null;
      final isCorrect = a.isCorrect;

      if (_filter == 'correct' && !isCorrect) continue;
      if (_filter == 'wrong' && (isCorrect || isSkipped)) continue;
      if (_filter == 'skipped' && !isSkipped) continue;

      list.add(_answerTile(q, a, i));
    }

    if (list.isEmpty) {
      list.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Text(
              'No questions in this filter.',
              style: GoogleFonts.poppins(color: AppTheme.textMuted, fontSize: 13),
            ),
          ),
        ),
      );
    }

    return list;
  }

  Widget _answerTile(Question q, AnswerRecord a, int index) {
    final isCorrect = a.isCorrect;
    final isSkipped = a.selectedIndex == null;
    final color = isSkipped
        ? AppTheme.textMuted
        : isCorrect
            ? AppTheme.success
            : AppTheme.error;
    final icon = isSkipped
        ? Icons.remove_circle_outline_rounded
        : isCorrect
            ? Icons.check_circle_rounded
            : Icons.cancel_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                'Q${index + 1}',
                style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.w700, fontSize: 12),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _sectionColor(q.section).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _sectionLabel(q.section),
                  style: GoogleFonts.poppins(
                    color: _sectionColor(q.section),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            q.text,
            style: GoogleFonts.poppins(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            '✓ Correct Answer: ${q.options[q.correctIndex]}',
            style: GoogleFonts.poppins(color: AppTheme.success, fontSize: 12, fontWeight: FontWeight.w600),
          ),
          if (!isSkipped && !isCorrect)
            Text(
              '✗ Your Answer: ${q.options[a.selectedIndex!]}',
              style: GoogleFonts.poppins(color: AppTheme.error, fontSize: 12),
            ),
          if (isSkipped)
            Text(
              '⚪ Skipped / Unattempted',
              style: GoogleFonts.poppins(color: AppTheme.textMuted, fontSize: 11),
            ),
          if (q.explanation != null && q.explanation!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              '💡 Explanation: ${q.explanation}',
              style: GoogleFonts.poppins(color: AppTheme.accent, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }

  Color _sectionColor(String section) {
    switch (section.toLowerCase()) {
      case 'verbal':
        return AppTheme.verbalColor;
      case 'nonverbal':
        return AppTheme.nonVerbalColor;
      case 'gk':
        return AppTheme.gkColor;
      case 'english':
        return AppTheme.info;
      case 'math':
        return AppTheme.accent;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _sectionLabel(String section) {
    switch (section.toLowerCase()) {
      case 'verbal':
        return 'VERBAL';
      case 'nonverbal':
        return 'NON-VERBAL';
      case 'gk':
        return 'ACADEMIC / GK';
      case 'english':
        return 'ENGLISH';
      case 'math':
        return 'MATHS';
      default:
        return section.toUpperCase();
    }
  }
}
