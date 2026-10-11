import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/providers.dart';
import '../../widgets/module_card.dart';
import '../papers/issb_papers_screen.dart';
import '../papers/pma_long_course_screen.dart';
import '../psych/psych_screen.dart';
import '../gto/gto_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProgressProvider>().loadResults();
      context.read<PreferencesProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final prefs = context.watch<PreferencesProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(prefs.streakDays),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildStatsRow(progress),
                const SizedBox(height: 24),
                _sectionTitle('ISSB Preparation'),
                const SizedBox(height: 12),
                _buildIssbCards(context),
                const SizedBox(height: 24),
                _sectionTitle('PMA Long Course'),
                const SizedBox(height: 12),
                _buildPmaCard(context),
                const SizedBox(height: 24),
                _sectionTitle('Psychological Tests'),
                const SizedBox(height: 12),
                _buildPsychCards(context),
                const SizedBox(height: 24),
                _sectionTitle('GTO & Interview'),
                const SizedBox(height: 12),
                _buildGtoCard(context),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(int streak) {
    return SliverAppBar(
      expandedHeight: 160,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.background,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A3B27),
                Color(0xFF0D1117),
                Color(0xFF1A1A2E),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppTheme.accent.withValues(alpha: 0.5), width: 1),
                      ),
                      child: const Text('⭐', style: TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ISSB Prep',
                            style: GoogleFonts.poppins(
                              color: AppTheme.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Pakistan Army Selection Preparation',
                            style: GoogleFonts.poppins(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (streak > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.warning.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppTheme.warning.withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          children: [
                            const Text('🔥',
                                style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 4),
                            Text(
                              '$streak day streak',
                              style: GoogleFonts.poppins(
                                color: AppTheme.warning,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(ProgressProvider progress) {
    return Row(
      children: [
        _statCard('Papers Done', '${progress.results.length}',
            Icons.assignment_turned_in_rounded, AppTheme.success),
        const SizedBox(width: 12),
        _statCard('Accuracy',
            '${progress.overallAccuracy.toStringAsFixed(0)}%',
            Icons.track_changes_rounded, AppTheme.accent),
        const SizedBox(width: 12),
        _statCard('Weak Areas', '${progress.weakAreas.length}',
            Icons.warning_amber_rounded, AppTheme.error),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value,
                style: GoogleFonts.poppins(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            Text(label,
                style: GoogleFonts.poppins(
                    color: AppTheme.textSecondary, fontSize: 10),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title,
        style: GoogleFonts.poppins(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600));
  }

  Widget _buildIssbCards(BuildContext context) {
    return Column(
      children: [
        ModuleCard(
          title: 'ISSB Intelligence Papers',
          subtitle: '200 Qs • 100 Verbal + 50 Non-Verbal + 50 GK',
          icon: Icons.psychology_alt_rounded,
          gradient: const LinearGradient(
            colors: [Color(0xFF1A3B5E), Color(0xFF0D2441)],
          ),
          accentColor: AppTheme.verbalColor,
          badge: '30 Papers',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const IssbPapersScreen())),
        ),
      ],
    );
  }

  Widget _buildPmaCard(BuildContext context) {
    return ModuleCard(
      title: 'PMA Long Course Initial Test',
      subtitle: '3 Separate Portions: 84 Verbal + 64 Non-Verbal + 50 Academic • 60% Passing',
      icon: Icons.military_tech_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF3B1A1A), Color(0xFF241010)],
      ),
      accentColor: AppTheme.pmaColor,
      badge: 'Official Format',
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const PmaLongCourseScreen())),
    );
  }

  Widget _buildPsychCards(BuildContext context) {
    return Column(
      children: [
        ModuleCard(
          title: 'Psychological Tests',
          subtitle: 'TAT • WAT • SRT • SDT • PPDT — All 5 tests',
          icon: Icons.self_improvement_rounded,
          gradient: const LinearGradient(
            colors: [Color(0xFF2D1B4E), Color(0xFF1A0F30)],
          ),
          accentColor: AppTheme.psychColor,
          badge: '5 Tests',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const PsychScreen())),
        ),
      ],
    );
  }

  Widget _buildGtoCard(BuildContext context) {
    return ModuleCard(
      title: 'GTO & Interview Prep',
      subtitle: 'Group Tasks • Command Tasks • IO Interview Q&A',
      icon: Icons.groups_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF3B2A0F), Color(0xFF251A08)],
      ),
      accentColor: AppTheme.gtoColor,
      badge: 'Guide',
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const GtoScreen())),
    );
  }
}
