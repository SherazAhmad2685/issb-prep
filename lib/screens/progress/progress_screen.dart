import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/providers.dart';
import '../../core/models/models.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProgressProvider>().loadResults();
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('My Progress',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: AppTheme.background,
      ),
      body: progress.loading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.accent))
          : progress.results.isEmpty
              ? _buildEmpty()
              : _buildDashboard(progress),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📊', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text('No papers attempted yet',
              style: GoogleFonts.poppins(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Start a practice paper to see your analytics here.',
              style: GoogleFonts.poppins(
                  color: AppTheme.textSecondary, fontSize: 13),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildDashboard(ProgressProvider progress) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Overall stats
        _sectionTitle('Overview'),
        const SizedBox(height: 10),
        Row(
          children: [
            _overviewTile('Papers Done', '${progress.results.length}',
                Icons.assignment_turned_in_rounded, AppTheme.success),
            const SizedBox(width: 10),
            _overviewTile('Overall Accuracy',
                '${progress.overallAccuracy.toStringAsFixed(0)}%',
                Icons.track_changes_rounded, AppTheme.accent),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _overviewTile('🔥 Streak', '${progress.streakDays} days',
                Icons.local_fire_department_rounded, AppTheme.warning),
            const SizedBox(width: 10),
            _overviewTile('Weak Areas', '${progress.weakAreas.length}',
                Icons.warning_amber_rounded, AppTheme.error),
          ],
        ),

        const SizedBox(height: 24),

        // Score history chart
        if (progress.results.length >= 2) ...[
          _sectionTitle('Score History'),
          const SizedBox(height: 10),
          _buildLineChart(progress.results),
          const SizedBox(height: 24),
        ],

        // Section accuracy
        if (progress.sectionAccuracy.isNotEmpty) ...[
          _sectionTitle('Section Accuracy'),
          const SizedBox(height: 10),
          ...progress.sectionAccuracy.entries.map(
              (e) => _sectionBar(e.key, e.value)),
          const SizedBox(height: 24),
        ],

        // Weak areas
        if (progress.weakAreas.isNotEmpty) ...[
          _sectionTitle('⚠️ Weak Areas — Focus Here'),
          const SizedBox(height: 10),
          ...progress.weakAreas.map((area) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppTheme.error.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: AppTheme.error, size: 18),
                    const SizedBox(width: 10),
                    Text(_sectionLabel(area),
                        style: GoogleFonts.poppins(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 13)),
                    const Spacer(),
                    Text('< 60% accuracy',
                        style: GoogleFonts.poppins(
                            color: AppTheme.error, fontSize: 11)),
                  ],
                ),
              )),
          const SizedBox(height: 24),
        ],

        // Recent results
        _sectionTitle('Recent Papers'),
        const SizedBox(height: 10),
        ...progress.results.take(8).map((r) => _resultTile(r)),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _sectionTitle(String title) => Text(title,
      style: GoogleFonts.poppins(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 15));

  Widget _overviewTile(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(value,
                style: GoogleFonts.poppins(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.w800)),
            Text(label,
                style: GoogleFonts.poppins(
                    color: AppTheme.textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart(List<PaperResult> results) {
    final sorted = results.reversed.take(10).toList();
    final spots = sorted.asMap().entries.map((e) =>
        FlSpot(e.key.toDouble(), e.value.percentage)).toList();

    return Container(
      height: 180,
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(
            drawHorizontalLine: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                getTitlesWidget: (v, meta) => Text(
                  '${v.toInt()}%',
                  style: GoogleFonts.poppins(
                      color: AppTheme.textMuted, fontSize: 9),
                ),
              ),
            ),
            bottomTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppTheme.accent,
              barWidth: 2.5,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.accent.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionBar(String section, double pct) {
    final color = _sectionColor(section);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(_sectionLabel(section),
                      style: GoogleFonts.poppins(
                          color: AppTheme.textSecondary, fontSize: 12))),
              Text('${pct.toStringAsFixed(0)}%',
                  style: GoogleFonts.poppins(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12)),
            ],
          ),
          const SizedBox(height: 5),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: pct / 100),
            duration: const Duration(milliseconds: 800),
            builder: (_, v, __) => LinearProgressIndicator(
              value: v,
              backgroundColor: AppTheme.border,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultTile(PaperResult r) {
    final pct = r.percentage;
    final color = pct >= 60
        ? AppTheme.success
        : pct >= 40
            ? AppTheme.warning
            : AppTheme.error;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text('${pct.toStringAsFixed(0)}%',
                  style: GoogleFonts.poppins(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 10)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.paperType == 'issb_intel' ? 'ISSB Intelligence Paper' : 'PMA Long Course',
                    style: GoogleFonts.poppins(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 12)),
                Text(
                    '✅ ${r.correct}  ❌ ${r.wrong}  ⚪ ${r.skipped}  Score: ${r.score.toStringAsFixed(1)}/${r.maxScore.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                        color: AppTheme.textSecondary, fontSize: 10)),
              ],
            ),
          ),
          Text(
              '${r.completedAt.day}/${r.completedAt.month}',
              style: GoogleFonts.poppins(
                  color: AppTheme.textMuted, fontSize: 10)),
        ],
      ),
    );
  }

  Color _sectionColor(String section) {
    switch (section) {
      case 'verbal': return AppTheme.verbalColor;
      case 'nonverbal': return AppTheme.nonVerbalColor;
      case 'gk': return AppTheme.gkColor;
      case 'english': return AppTheme.info;
      case 'math': return AppTheme.accent;
      default: return AppTheme.textSecondary;
    }
  }

  String _sectionLabel(String section) {
    switch (section) {
      case 'verbal': return '🧠 Verbal Intelligence';
      case 'nonverbal': return '🔷 Non-Verbal Intelligence';
      case 'gk': return '🌍 General Knowledge';
      case 'english': return '📖 English';
      case 'math': return '📐 Mathematics';
      default: return section.toUpperCase();
    }
  }
}
