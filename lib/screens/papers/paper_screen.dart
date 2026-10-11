import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/providers.dart';
import '../../core/models/models.dart';
import '../../widgets/non_verbal_figure_widget.dart';
import 'answer_review_screen.dart';

class PaperScreen extends StatefulWidget {
  final String title;
  final int totalMinutes;
  final bool isExamMode;
  final String portionType; // 'pma_verbal', 'pma_nonverbal', 'pma_academic', 'pma_full', etc.

  const PaperScreen({
    super.key,
    required this.title,
    required this.totalMinutes,
    this.isExamMode = false,
    this.portionType = 'pma_verbal',
  });

  @override
  State<PaperScreen> createState() => _PaperScreenState();
}

class _PaperScreenState extends State<PaperScreen> {
  late Timer _timer;
  int _secondsRemaining = 0;
  int _initialSeconds = 0;
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final FocusNode _keyboardFocusNode = FocusNode();

  // Backward navigation tracking
  String? _penaltyToast;
  Timer? _penaltyTimer;

  @override
  void initState() {
    super.initState();
    _initialSeconds = widget.totalMinutes * 60;
    _secondsRemaining = _initialSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining <= 0) {
        t.cancel();
        _submitPaper();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  String get _timeString {
    final m = _secondsRemaining ~/ 60;
    final s = _secondsRemaining % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Color get _timerColor {
    if (_secondsRemaining > 300) return AppTheme.success;
    if (_secondsRemaining > 60) return AppTheme.warning;
    return AppTheme.error;
  }

  /// Navigates to a target question index.
  /// If going backwards, deducts 5 seconds per question as requested!
  void _navigateToQuestion(int targetIndex, int totalQuestions) {
    if (targetIndex < 0 || targetIndex >= totalQuestions) return;

    if (targetIndex < _currentIndex) {
      final stepsBack = _currentIndex - targetIndex;
      final penalty = stepsBack * 5;
      setState(() {
        _secondsRemaining = math.max(0, _secondsRemaining - penalty);
        _penaltyToast = '⚠️ -$penalty sec deducted for going back!';
      });

      _penaltyTimer?.cancel();
      _penaltyTimer = Timer(const Duration(milliseconds: 2500), () {
        if (mounted) setState(() => _penaltyToast = null);
      });

      if (_secondsRemaining <= 0) {
        _submitPaper();
        return;
      }
    }

    setState(() => _currentIndex = targetIndex);
    _pageController.animateToPage(
      targetIndex,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void _submitPaper() {
    _timer.cancel();
    _penaltyTimer?.cancel();
    final provider = context.read<PaperProvider>();
    final timeSpent = _initialSeconds - _secondsRemaining;
    final result = provider.submitPaper(timeSpentSeconds: timeSpent);
    final answers = provider.getAnswerRecords();
    context.read<ProgressProvider>().saveResult(result, answers);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AnswerReviewScreen(
          result: result,
          questions: provider.questions,
          answers: answers,
        ),
      ),
    );
  }

  void _showEndPaperConfirmation() {
    final provider = context.read<PaperProvider>();
    final answered = provider.answered;
    final total = provider.totalQuestions;
    final remaining = total - answered;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            const Icon(Icons.exit_to_app_rounded, color: AppTheme.warning),
            const SizedBox(width: 8),
            Text(
              'End Paper Now?',
              style: GoogleFonts.poppins(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You can finish your test at any time. Your score will be calculated from both total questions and the questions you attempted.',
              style: GoogleFonts.poppins(color: AppTheme.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: [
                  _dialogStatRow('Total Questions:', '$total', Colors.white),
                  const Divider(color: AppTheme.border, height: 12),
                  _dialogStatRow('Attempted / Answered:', '$answered', AppTheme.success),
                  const Divider(color: AppTheme.border, height: 12),
                  _dialogStatRow('Unattempted / Skipped:', '$remaining', AppTheme.warning),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Passing criteria: 60% of total marks.',
              style: GoogleFonts.poppins(color: AppTheme.accent, fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Continue Test',
              style: GoogleFonts.poppins(color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _submitPaper();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              'End & View Marks',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dialogStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(color: AppTheme.textSecondary, fontSize: 12)),
        Text(value, style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
      ],
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _penaltyTimer?.cancel();
    _pageController.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final provider = context.read<PaperProvider>();
    final total = provider.questions.length;
    if (total == 0) return KeyEventResult.ignored;

    // Keys 1, 2, 3, 4 or A, B, C, D to select option
    if (event.logicalKey == LogicalKeyboardKey.digit1 || event.logicalKey == LogicalKeyboardKey.keyA) {
      provider.selectAnswer(_currentIndex, 0);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.digit2 || event.logicalKey == LogicalKeyboardKey.keyB) {
      provider.selectAnswer(_currentIndex, 1);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.digit3 || event.logicalKey == LogicalKeyboardKey.keyC) {
      provider.selectAnswer(_currentIndex, 2);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.digit4 || event.logicalKey == LogicalKeyboardKey.keyD) {
      provider.selectAnswer(_currentIndex, 3);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      _navigateToQuestion(_currentIndex + 1, total);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      _navigateToQuestion(_currentIndex - 1, total);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.keyE) {
      _showEndPaperConfirmation();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaperProvider>();
    final questions = provider.questions;

    if (provider.loading || questions.isEmpty) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppTheme.accent),
              const SizedBox(height: 16),
              Text(
                'Loading exam paper...',
                style: GoogleFonts.poppins(color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return Focus(
      focusNode: _keyboardFocusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 850;

            return Column(
              children: [
                // ── Top Header Bar ────────────────────────────────────
                _buildHeader(provider, questions.length),

                // Penalty banner if user navigated backwards
                if (_penaltyToast != null)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    color: AppTheme.error.withValues(alpha: 0.9),
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    child: Text(
                      _penaltyToast!,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // ── Main Content Area ─────────────────────────────────
                Expanded(
                  child: isDesktop
                      ? _buildDesktopLayout(questions, provider)
                      : _buildMobileLayout(questions, provider),
                ),

                // ── Bottom Navigation Controls ────────────────────────
                _buildNavBar(questions.length, provider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(PaperProvider provider, int total) {
    final progress = (_currentIndex + 1) / total;

    return Container(
      color: AppTheme.surface,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: Row(
                children: [
                  // Close / Exit icon
                  IconButton(
                    onPressed: _showEndPaperConfirmation,
                    icon: const Icon(Icons.close_rounded, color: AppTheme.textSecondary),
                    padding: EdgeInsets.zero,
                    tooltip: 'End Paper',
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          widget.title,
                          style: GoogleFonts.poppins(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '60% Passing Criteria • −5s for going back',
                          style: GoogleFonts.poppins(
                            color: AppTheme.accent,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Timer Widget
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _timerColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _timerColor.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.timer_rounded, color: _timerColor, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          _timeString,
                          style: GoogleFonts.poppins(
                            color: _timerColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Prominent "End Paper" Header Button
                  ElevatedButton.icon(
                    onPressed: _showEndPaperConfirmation,
                    icon: const Icon(Icons.stop_circle_rounded, size: 15),
                    label: Text(
                      'End Paper',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 11),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.error.withValues(alpha: 0.85),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),

            // Progress bar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.border,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accent),
              minHeight: 3,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentIndex + 1} of $total',
                    style: GoogleFonts.poppins(color: AppTheme.textPrimary, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${provider.answered} Answered • ${provider.remaining} Remaining',
                    style: GoogleFonts.poppins(color: AppTheme.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Mobile layout (Single column PageView)
  Widget _buildMobileLayout(List<Question> questions, PaperProvider provider) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (i) {
        if (i < _currentIndex) {
          // If swiped back
          final penalty = (_currentIndex - i) * 5;
          setState(() {
            _secondsRemaining = math.max(0, _secondsRemaining - penalty);
            _penaltyToast = '⚠️ -$penalty sec deducted for going back!';
          });
          _penaltyTimer?.cancel();
          _penaltyTimer = Timer(const Duration(milliseconds: 2500), () {
            if (mounted) setState(() => _penaltyToast = null);
          });
        }
        setState(() => _currentIndex = i);
      },
      itemCount: questions.length,
      itemBuilder: (context, index) {
        return _buildQuestionCard(questions[index], index, provider);
      },
    );
  }

  /// Desktop layout (Center question view + Right AS&RC Question Palette)
  Widget _buildDesktopLayout(List<Question> questions, PaperProvider provider) {
    return Row(
      children: [
        // Center Question Area
        Expanded(
          flex: 7,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (i) {
              if (i < _currentIndex) {
                final penalty = (_currentIndex - i) * 5;
                setState(() {
                  _secondsRemaining = math.max(0, _secondsRemaining - penalty);
                  _penaltyToast = '⚠️ -$penalty sec deducted for going back!';
                });
                _penaltyTimer?.cancel();
                _penaltyTimer = Timer(const Duration(milliseconds: 2500), () {
                  if (mounted) setState(() => _penaltyToast = null);
                });
              }
              setState(() => _currentIndex = i);
            },
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 750),
                  child: _buildQuestionCard(questions[index], index, provider),
                ),
              );
            },
          ),
        ),

        // Vertical Divider
        const VerticalDivider(width: 1, color: AppTheme.border),

        // Right Question Palette (AS&RC style)
        Expanded(
          flex: 3,
          child: _buildDesktopQuestionPalette(questions.length, provider),
        ),
      ],
    );
  }

  Widget _buildDesktopQuestionPalette(int total, PaperProvider provider) {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.grid_4x4_rounded, color: AppTheme.accent, size: 18),
              const SizedBox(width: 8),
              Text(
                'AS&RC Question Palette',
                style: GoogleFonts.poppins(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Legend
          Row(
            children: [
              _legendDot(AppTheme.success, 'Answered'),
              const SizedBox(width: 12),
              _legendDot(AppTheme.border, 'Skipped'),
              const SizedBox(width: 12),
              _legendDot(AppTheme.accent, 'Current'),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppTheme.border, height: 1),
          const SizedBox(height: 12),
          // Grid of numbers
          Expanded(
            child: GridView.builder(
              itemCount: total,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, idx) {
                final isCurrent = idx == _currentIndex;
                final isAnswered = provider.isAnswered(idx);

                Color bgColor = AppTheme.surfaceLight;
                Color textColor = AppTheme.textSecondary;
                Color borderColor = AppTheme.border;

                if (isCurrent) {
                  bgColor = AppTheme.accent.withValues(alpha: 0.25);
                  borderColor = AppTheme.accent;
                  textColor = AppTheme.accent;
                } else if (isAnswered) {
                  bgColor = AppTheme.success.withValues(alpha: 0.2);
                  borderColor = AppTheme.success;
                  textColor = AppTheme.success;
                }

                return InkWell(
                  onTap: () => _navigateToQuestion(idx, total),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor, width: isCurrent ? 2 : 1),
                    ),
                    child: Center(
                      child: Text(
                        '${idx + 1}',
                        style: GoogleFonts.poppins(
                          color: textColor,
                          fontWeight: isCurrent || isAnswered ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Desktop shortcuts tip
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '⌨️ Keyboard: 1-4 / A-D to select\n←/→ to navigate (-5s going back)\nE to End Paper',
              style: GoogleFonts.poppins(color: AppTheme.textMuted, fontSize: 10, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.poppins(color: AppTheme.textSecondary, fontSize: 10)),
      ],
    );
  }

  Widget _buildQuestionCard(Question q, int index, PaperProvider provider) {
    final selected = provider.selectedAnswers[index];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section & Category badges
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _sectionColor(q.section).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _sectionColor(q.section).withValues(alpha: 0.4)),
                ),
                child: Text(
                  _sectionLabel(q.section),
                  style: GoogleFonts.poppins(
                    color: _sectionColor(q.section),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Text(
                  q.category.toUpperCase(),
                  style: GoogleFonts.poppins(color: AppTheme.textSecondary, fontSize: 9, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Question Text
          Text(
            q.text,
            style: GoogleFonts.poppins(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),

          // Non-Verbal Vector Graphics Renderer
          if (q.section.toLowerCase() == 'nonverbal')
            NonVerbalFigureWidget(question: q),

          const SizedBox(height: 20),

          // Options list (A, B, C, D)
          ...List.generate(q.options.length, (i) {
            final isSelected = selected == i;
            return GestureDetector(
              onTap: () => provider.selectAnswer(index, i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary.withValues(alpha: 0.25) : AppTheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? AppTheme.accent : AppTheme.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? AppTheme.accent : AppTheme.surfaceLight,
                        border: Border.all(color: isSelected ? AppTheme.accent : AppTheme.border),
                      ),
                      child: Center(
                        child: Text(
                          String.fromCharCode(65 + i), // A, B, C, D
                          style: GoogleFonts.poppins(
                            color: isSelected ? Colors.black : AppTheme.textSecondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        q.options[i],
                        style: GoogleFonts.poppins(
                          color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          if (selected != null)
            TextButton.icon(
              onPressed: () => provider.clearAnswer(index),
              icon: const Icon(Icons.clear_rounded, size: 16),
              label: Text('Clear Selection', style: GoogleFonts.poppins(fontSize: 12)),
              style: TextButton.styleFrom(foregroundColor: AppTheme.textMuted),
            ),
        ],
      ),
    );
  }

  Widget _buildNavBar(int total, PaperProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: [
          // Previous button (deducts 5 seconds)
          if (_currentIndex > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _navigateToQuestion(_currentIndex - 1, total),
                icon: const Icon(Icons.arrow_back_rounded, size: 16),
                label: Text(
                  'Previous (-5s)',
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.warning,
                  side: const BorderSide(color: AppTheme.warning),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            )
          else
            const Expanded(child: SizedBox()),

          const SizedBox(width: 12),

          // Next or Submit
          if (_currentIndex < total - 1)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _navigateToQuestion(_currentIndex + 1, total),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: Text(
                  'Next Question',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            )
          else
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _showEndPaperConfirmation,
                icon: const Icon(Icons.check_circle_rounded, size: 16),
                label: Text(
                  'Finish Exam ✓',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.success,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
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
        return '🧠 VERBAL INTELLIGENCE';
      case 'nonverbal':
        return '🔷 NON-VERBAL INTELLIGENCE';
      case 'gk':
        return '🌍 GENERAL KNOWLEDGE';
      case 'english':
        return '📖 ENGLISH';
      case 'math':
        return '📐 MATHEMATICS';
      default:
        return section.toUpperCase();
    }
  }
}
