import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/providers.dart';
import '../../core/models/models.dart';
import 'paper_screen.dart';

class IssbPapersScreen extends StatelessWidget {
  const IssbPapersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final issbResults = progress.issbResults;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('ISSB Intelligence Papers',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
        backgroundColor: AppTheme.background,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Paper structure info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A3B5E), Color(0xFF0D2441)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppTheme.verbalColor.withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Paper Structure',
                    style: GoogleFonts.poppins(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
                const SizedBox(height: 12),
                _structureRow('🧠 Verbal Intelligence', '100 Questions',
                    AppTheme.verbalColor),
                _structureRow('🔷 Non-Verbal Intelligence', '50 Questions',
                    AppTheme.nonVerbalColor),
                _structureRow('🌍 General Knowledge', '50 Questions',
                    AppTheme.gkColor),
                const Divider(color: AppTheme.border),
                _structureRow('📋 Total', '200 Questions', AppTheme.accent),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Start new paper button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _startPaper(context, false),
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text('Start New Practice Paper',
                  style: GoogleFonts.poppins(fontSize: 15)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _startSectionDrill(context),
              icon: const Icon(Icons.tune_rounded),
              label: Text('Section Drills (Verbal / Non-Verbal / GK)',
                  style: GoogleFonts.poppins(fontSize: 13)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.verbalColor,
                side: BorderSide(color: AppTheme.verbalColor.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),

          if (issbResults.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text('Past Papers',
                style: GoogleFonts.poppins(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15)),
            const SizedBox(height: 12),
            ...issbResults.take(10).map((r) => _resultTile(context, r)),
          ],
        ],
      ),
    );
  }

  Widget _structureRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
              child: Text(label,
                  style: GoogleFonts.poppins(
                      color: AppTheme.textSecondary, fontSize: 12))),
          Text(value,
              style: GoogleFonts.poppins(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12)),
        ],
      ),
    );
  }

  Widget _resultTile(BuildContext context, PaperResult r) {
    final pct = r.percentage.toStringAsFixed(0);
    final color = r.percentage >= 60
        ? AppTheme.success
        : r.percentage >= 40
            ? AppTheme.warning
            : AppTheme.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text('$pct%',
                  style: GoogleFonts.poppins(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 12)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ISSB Paper',
                    style: GoogleFonts.poppins(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 13)),
                Text(
                    '✅ ${r.correct}  ❌ ${r.wrong}  ⚪ ${r.skipped}  of ${r.totalQuestions}',
                    style: GoogleFonts.poppins(
                        color: AppTheme.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Text(
              '${r.completedAt.day}/${r.completedAt.month}/${r.completedAt.year}',
              style: GoogleFonts.poppins(
                  color: AppTheme.textMuted, fontSize: 10)),
        ],
      ),
    );
  }

  void _startPaper(BuildContext context, bool examMode) async {
    final provider = context.read<PaperProvider>();
    await provider.loadIssbPaper();
    if (context.mounted) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => PaperScreen(
                    title: 'ISSB Intelligence Paper',
                    totalMinutes: 90,
                    isExamMode: examMode,
                  )));
    }
  }

  void _startSectionDrill(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose Section Drill',
                style: GoogleFonts.poppins(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16)),
            const SizedBox(height: 16),
            _drillOption(context, '🧠 Verbal Intelligence', '50 Questions',
                AppTheme.verbalColor, 'verbal'),
            _drillOption(context, '🔷 Non-Verbal Intelligence', '25 Questions',
                AppTheme.nonVerbalColor, 'nonverbal'),
            _drillOption(context, '🌍 General Knowledge', '25 Questions',
                AppTheme.gkColor, 'gk'),
          ],
        ),
      ),
    );
  }

  Widget _drillOption(BuildContext context, String label, String count,
      Color color, String section) {
    return ListTile(
      onTap: () async {
        Navigator.pop(context);
        // Future: implement section-specific drill
      },
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.play_circle_filled_rounded, color: color),
      ),
      title: Text(label,
          style: GoogleFonts.poppins(
              color: AppTheme.textPrimary, fontSize: 13)),
      trailing: Text(count,
          style: GoogleFonts.poppins(
              color: color, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}
