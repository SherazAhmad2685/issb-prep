import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/providers.dart';
import 'paper_screen.dart';

class PmaLongCourseScreen extends StatefulWidget {
  const PmaLongCourseScreen({super.key});

  @override
  State<PmaLongCourseScreen> createState() => _PmaLongCourseScreenState();
}

class _PmaLongCourseScreenState extends State<PmaLongCourseScreen> {
  bool _negativeMarking = false; // Default: No negative marking in AS&RC initial test

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final pmaResults = progress.pmaResults;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'PMA Long Course Initial Test',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        backgroundColor: AppTheme.background,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              // Header Banner
              _buildOfficialBanner(),

              const SizedBox(height: 20),

              // Test Rules & Constraints Banner
              _buildRulesCard(),

              const SizedBox(height: 24),

              // Section Header
              Text(
                '3 Separate Test Portions',
                style: GoogleFonts.poppins(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Practice each portion individually or simulate the full sequential examination.',
                style: GoogleFonts.poppins(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),

              // Portion 1: Verbal Intelligence Test (84 Qs • 30 Mins)
              _portionCard(
                portionNumber: '1',
                title: 'Verbal Intelligence Test',
                subtitle: 'Number/letter series, time & days sequence, coding-decoding, speed math & blood relations.',
                questionCount: '84 Questions',
                duration: '30 Minutes',
                accentColor: AppTheme.verbalColor,
                icon: Icons.psychology_rounded,
                onStart: () => _startVerbalPortion(context),
              ),

              const SizedBox(height: 14),

              // Portion 2: Non-Verbal Intelligence Test (64 Qs • 30 Mins)
              _portionCard(
                portionNumber: '2',
                title: 'Non-Verbal Intelligence Test',
                subtitle: 'Figure series, odd-one-out shapes, analogies, matrices, mirror & water reflections.',
                questionCount: '64 Questions',
                duration: '30 Minutes',
                accentColor: AppTheme.nonVerbalColor,
                icon: Icons.grid_view_rounded,
                onStart: () => _startNonVerbalPortion(context),
              ),

              const SizedBox(height: 14),

              // Portion 3: Academic & General Knowledge Test (50 Qs • 30 Mins)
              _portionCard(
                portionNumber: '3',
                title: 'Academic & General Knowledge',
                subtitle: 'Pakistan Studies (15 Qs), Islamic Studies (10 Qs), World GK (10 Qs), English (8 Qs), Maths (7 Qs).',
                questionCount: '50 Questions',
                duration: '30 Minutes',
                accentColor: AppTheme.gkColor,
                icon: Icons.menu_book_rounded,
                onStart: () => _startAcademicPortion(context),
              ),

              const SizedBox(height: 20),

              // Full PMA Simulation Button
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF381414), Color(0xFF1F0C0C)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.pmaColor.withValues(alpha: 0.6), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.military_tech_rounded, color: AppTheme.pmaColor, size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Full PMA Long Course Simulation',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.pmaColor.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '198 Qs • 90 Mins',
                            style: GoogleFonts.poppins(
                              color: AppTheme.pmaColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'All 3 portions combined (84 Verbal + 64 Non-Verbal + 50 Academic). Exactly matches the complete computer test at Army Selection & Recruitment Centres (AS&RC).',
                      style: GoogleFonts.poppins(color: AppTheme.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _startFullPmaSimulation(context),
                        icon: const Icon(Icons.play_circle_fill_rounded),
                        label: Text(
                          'Start Full 198 Questions Exam',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.pmaColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Settings Card (Negative marking toggle)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.border),
                ),
                child: SwitchListTile(
                  value: _negativeMarking,
                  onChanged: (v) => setState(() => _negativeMarking = v),
                  title: Text(
                    'Optional Negative Marking (−0.25)',
                    style: GoogleFonts.poppins(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Official AS&RC initial test has NO negative marking. Turn ON for harder practice.',
                    style: GoogleFonts.poppins(color: AppTheme.textSecondary, fontSize: 11),
                  ),
                  activeThumbColor: AppTheme.accent,
                  contentPadding: EdgeInsets.zero,
                ),
              ),

              if (pmaResults.isNotEmpty) ...[
                const SizedBox(height: 28),
                Text(
                  'Past Test Attempts',
                  style: GoogleFonts.poppins(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 12),
                ...pmaResults.take(10).map((r) => _buildResultTile(context, r)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfficialBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A2B), Color(0xFF112219)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🇵🇰', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Official AS&RC Computerized Exam Pattern',
                  style: GoogleFonts.poppins(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _specRow('Portion 1', 'Verbal Intelligence Test', '84 MCQs', '30 Min', AppTheme.verbalColor),
          _specRow('Portion 2', 'Non-Verbal Intelligence Test', '64 MCQs', '30 Min', AppTheme.nonVerbalColor),
          _specRow('Portion 3', 'Academic & General Knowledge', '50 MCQs', '30 Min', AppTheme.gkColor),
          const Divider(color: AppTheme.border, height: 16),
          _specRow('Total Exam', 'All 3 Portions Combined', '198 MCQs', '90 Min', AppTheme.accent),
        ],
      ),
    );
  }

  Widget _specRow(String tag, String name, String count, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              tag,
              style: GoogleFonts.poppins(color: color, fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.poppins(color: AppTheme.textPrimary, fontSize: 12),
            ),
          ),
          Text(
            '$count • $time',
            style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.w600, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildRulesCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          _ruleItem(
            icon: Icons.verified_rounded,
            color: AppTheme.success,
            title: 'Passing Threshold: 60% Required',
            description: 'Hardened 60% passing criteria to ensure competitive qualification.',
          ),
          const Divider(color: AppTheme.border, height: 16),
          _ruleItem(
            icon: Icons.timer_outlined,
            color: AppTheme.warning,
            title: 'Backward Navigation Penalty: −5s per question',
            description: 'Going back to a previous question deducts 5 seconds from your timer.',
          ),
          const Divider(color: AppTheme.border, height: 16),
          _ruleItem(
            icon: Icons.exit_to_app_rounded,
            color: AppTheme.accent,
            title: 'Anytime "End Paper" Available',
            description: 'Finish at any point to view marks calculated from total vs attempted questions.',
          ),
        ],
      ),
    );
  }

  Widget _ruleItem({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(color: AppTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 12),
              ),
              Text(
                description,
                style: GoogleFonts.poppins(color: AppTheme.textSecondary, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _portionCard({
    required String portionNumber,
    required String title,
    required String subtitle,
    required String questionCount,
    required String duration,
    required Color accentColor,
    required IconData icon,
    required VoidCallback onStart,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: accentColor.withValues(alpha: 0.4)),
                ),
                child: Center(
                  child: Icon(icon, color: accentColor, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Portion $portionNumber: $title',
                      style: GoogleFonts.poppins(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '$questionCount • $duration',
                      style: GoogleFonts.poppins(
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  'Start',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.poppins(color: AppTheme.textSecondary, fontSize: 11, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildResultTile(BuildContext context, PaperResult r) {
    final pct = r.percentage;
    final isPassed = r.isPassed;
    final color = isPassed ? AppTheme.success : AppTheme.error;

    String portionName = 'PMA Exam';
    if (r.paperType == 'pma_verbal') portionName = 'Portion 1: Verbal Intelligence';
    if (r.paperType == 'pma_nonverbal') portionName = 'Portion 2: Non-Verbal Intelligence';
    if (r.paperType == 'pma_academic') portionName = 'Portion 3: Academic / GK';
    if (r.paperType == 'pma_full' || r.paperType == 'pma_long') portionName = 'Full PMA Simulation';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${pct.toStringAsFixed(0)}%',
                    style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                  Text(
                    isPassed ? 'PASS' : 'FAIL',
                    style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.w700, fontSize: 8),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  portionName,
                  style: GoogleFonts.poppins(color: AppTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 12),
                ),
                Text(
                  'Marks: ${r.score.toStringAsFixed(1)} / ${r.totalQuestions}  •  Attempted: ${r.attempted}/${r.totalQuestions}',
                  style: GoogleFonts.poppins(color: AppTheme.textSecondary, fontSize: 11),
                ),
                Text(
                  'Accuracy: ${r.percentageAttempted.toStringAsFixed(0)}%  •  ✅ ${r.correct}  ❌ ${r.wrong}  ⚪ ${r.skipped}',
                  style: GoogleFonts.poppins(color: AppTheme.textMuted, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startVerbalPortion(BuildContext context) async {
    final provider = context.read<PaperProvider>();
    provider.setNegativeMarking(_negativeMarking);
    await provider.loadPmaVerbalPaper();
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PaperScreen(
            title: 'PMA Verbal Intelligence (Portion 1)',
            totalMinutes: 30,
            portionType: 'pma_verbal',
          ),
        ),
      );
    }
  }

  void _startNonVerbalPortion(BuildContext context) async {
    final provider = context.read<PaperProvider>();
    provider.setNegativeMarking(_negativeMarking);
    await provider.loadPmaNonVerbalPaper();
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PaperScreen(
            title: 'PMA Non-Verbal Intelligence (Portion 2)',
            totalMinutes: 30,
            portionType: 'pma_nonverbal',
          ),
        ),
      );
    }
  }

  void _startAcademicPortion(BuildContext context) async {
    final provider = context.read<PaperProvider>();
    provider.setNegativeMarking(_negativeMarking);
    await provider.loadPmaAcademicPaper();
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PaperScreen(
            title: 'PMA Academic & General Knowledge (Portion 3)',
            totalMinutes: 30,
            portionType: 'pma_academic',
          ),
        ),
      );
    }
  }

  void _startFullPmaSimulation(BuildContext context) async {
    final provider = context.read<PaperProvider>();
    provider.setNegativeMarking(_negativeMarking);
    await provider.loadPmaFullPaper();
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PaperScreen(
            title: 'PMA Long Course Full Simulation',
            totalMinutes: 90,
            portionType: 'pma_full',
          ),
        ),
      );
    }
  }
}
