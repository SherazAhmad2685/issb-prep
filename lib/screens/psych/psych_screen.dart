import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../core/theme/app_theme.dart';
import '../../core/providers/providers.dart';


class PsychScreen extends StatelessWidget {
  const PsychScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Psychological Tests',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: AppTheme.background,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _testCard(
            context,
            emoji: '🖼️',
            title: 'TAT / PPDT',
            subtitle: 'Thematic Apperception Test\nPicture Perception & Discussion',
            color: AppTheme.psychColor,
            onTap: () => _showTatGuide(context),
          ),
          _testCard(
            context,
            emoji: '💬',
            title: 'WAT Drill',
            subtitle: 'Word Association Test\n25 words • 15 seconds each',
            color: AppTheme.verbalColor,
            onTap: () => _startWat(context),
          ),
          _testCard(
            context,
            emoji: '⚡',
            title: 'SRT Drill',
            subtitle: 'Situation Reaction Test\n15 situations • 30 seconds each',
            color: AppTheme.gtoColor,
            onTap: () => _startSrt(context),
          ),
          _testCard(
            context,
            emoji: '📝',
            title: 'SDT Guide',
            subtitle: 'Self Description Test\nHow to present OLQ traits',
            color: AppTheme.success,
            onTap: () => _showSdtGuide(context),
          ),
          _testCard(
            context,
            emoji: '✨',
            title: 'OLQ Self Assessment',
            subtitle: 'Officer-Like Qualities Checklist\nEvaluate your traits',
            color: AppTheme.accent,
            onTap: () => _showOlqChecklist(context),
          ),
        ],
      ),
    );
  }

  Widget _testCard(BuildContext context,
      {required String emoji,
      required String title,
      required String subtitle,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 24))),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  Text(subtitle,
                      style: GoogleFonts.poppins(
                          color: AppTheme.textSecondary, fontSize: 11)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: color.withValues(alpha: 0.7)),
          ],
        ),
      ),
    );
  }

  void _showTatGuide(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => const _TatGuideScreen()));
  }

  void _startWat(BuildContext context) async {
    final drill = context.read<DrillProvider>();
    await drill.loadWatDrill(count: 25);
    if (context.mounted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const _WatDrillScreen()));
    }
  }

  void _startSrt(BuildContext context) async {
    final drill = context.read<DrillProvider>();
    await drill.loadSrtDrill(count: 15);
    if (context.mounted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const _SrtDrillScreen()));
    }
  }

  void _showSdtGuide(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const _SdtGuideScreen()));
  }

  void _showOlqChecklist(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const _OlqScreen()));
  }
}

// ── TAT Guide ────────────────────────────────────────────────────────────────

class _TatGuideScreen extends StatelessWidget {
  const _TatGuideScreen();

  static const _tips = [
    ['Hero Concept', 'Always write your story around a positive hero who faces a challenge and overcomes it. The assessor evaluates your OLQs through the hero.'],
    ['Story Structure', 'Follow the PPP pattern: Past (background), Present (current situation), Plan (how hero resolves it). Your story should have a clear resolution.'],
    ['Positive Themes', 'Choose constructive themes: rescue, leadership, teamwork, success after hardship. Avoid themes of death without sacrifice, crime, or obsession.'],
    ['Time Management', '30 seconds per picture on PPDT, 4 minutes on TAT. Practice to stay within time.'],
    ['Legibility', 'Write clearly and fast. TAT is handwritten. Practice your penmanship under time pressure.'],
    ['Avoid Negatives', 'Do not write about suicide, murder, failure without resolution, or giving up. Always show the hero prevailing.'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('TAT / PPDT Guide',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: AppTheme.background,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.psychColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.psychColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              'In TAT/PPDT, you are shown ambiguous images and asked to write a story. Assessors evaluate Officer-Like Qualities (OLQs) through your story characters.',
              style: GoogleFonts.poppins(
                  color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          ..._tips.map((t) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.lightbulb_rounded,
                          color: AppTheme.accent, size: 16),
                      const SizedBox(width: 8),
                      Text(t[0],
                          style: GoogleFonts.poppins(
                              color: AppTheme.accent,
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                    ]),
                    const SizedBox(height: 8),
                    Text(t[1],
                        style: GoogleFonts.poppins(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                            height: 1.5)),
                  ],
                ),
              )),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sample Story Structure',
                    style: GoogleFonts.poppins(
                        color: AppTheme.success,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
                const SizedBox(height: 8),
                Text(
                  'Past: Ahmed, a determined young man, grew up in a flood-hit village where he saw people suffer.\n\nPresent: He is now an officer who hears about an incoming flood in a nearby district.\n\nPlan: He immediately organizes rescue teams, coordinates with local authorities, and leads the evacuation operation. Due to his swift action, all villagers are saved.',
                  style: GoogleFonts.poppins(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                      height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── WAT Drill ─────────────────────────────────────────────────────────────────

class _WatDrillScreen extends StatefulWidget {
  const _WatDrillScreen();

  @override
  State<_WatDrillScreen> createState() => _WatDrillScreenState();
}

class _WatDrillScreenState extends State<_WatDrillScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _seconds = 15;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
        vsync: this, duration: const Duration(seconds: 15));
    _startTimer();
  }

  void _startTimer() {
    _seconds = 15;
    _progressController.forward(from: 0);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds <= 0) {
        t.cancel();
        _next();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  void _next() {
    _timer?.cancel();
    final drill = context.read<DrillProvider>();
    drill.advance();
    if (!drill.drillComplete) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final drill = context.watch<DrillProvider>();

    if (drill.loading) {
      return const Scaffold(
          backgroundColor: AppTheme.background,
          body: Center(
              child:
                  CircularProgressIndicator(color: AppTheme.verbalColor)));
    }

    if (drill.drillComplete) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 16),
              Text('WAT Drill Complete!',
                  style: GoogleFonts.poppins(
                      color: AppTheme.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text('Great practice session!',
                  style: GoogleFonts.poppins(
                      color: AppTheme.textSecondary)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Back',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      );
    }

    final word = drill.currentWat;
    if (word == null) return const SizedBox();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded,
                        color: AppTheme.textSecondary),
                  ),
                  Expanded(
                    child: Text('WAT Drill — Word ${drill.currentIndex + 1} / ${drill.watWords.length}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: AppTheme.textSecondary, fontSize: 13)),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _timerColor.withValues(alpha: 0.15),
                      border: Border.all(color: _timerColor),
                    ),
                    child: Center(
                      child: Text('$_seconds',
                          style: GoogleFonts.poppins(
                              color: _timerColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _progressController,
              builder: (_, __) => LinearProgressIndicator(
                value: _progressController.value,
                backgroundColor: AppTheme.border,
                valueColor:
                    AlwaysStoppedAnimation<Color>(_timerColor),
                minHeight: 3,
              ),
            ),
            // Main word display
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Write your first thought:',
                      style: GoogleFonts.poppins(
                          color: AppTheme.textSecondary, fontSize: 13)),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 30),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2D1B4E), Color(0xFF1A0F30)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      word.word,
                      style: GoogleFonts.poppins(
                          color: AppTheme.psychColor,
                          fontSize: 36,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text('Positive associations:',
                      style: GoogleFonts.poppins(
                          color: AppTheme.textMuted, fontSize: 11)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    alignment: WrapAlignment.center,
                    children: word.positiveAssociations
                        .map((a) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppTheme.success
                                        .withValues(alpha: 0.4)),
                              ),
                              child: Text(a,
                                  style: GoogleFonts.poppins(
                                      color: AppTheme.success,
                                      fontSize: 12)),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            // Next button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.verbalColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Next Word →',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color get _timerColor =>
      _seconds > 8 ? AppTheme.success : _seconds > 4 ? AppTheme.warning : AppTheme.error;
}

// ── SRT Drill ─────────────────────────────────────────────────────────────────

class _SrtDrillScreen extends StatefulWidget {
  const _SrtDrillScreen();

  @override
  State<_SrtDrillScreen> createState() => _SrtDrillScreenState();
}

class _SrtDrillScreenState extends State<_SrtDrillScreen> {
  Timer? _timer;
  int _seconds = 30;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _seconds = 30;
    _showAnswer = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds <= 0) {
        t.cancel();
        setState(() => _showAnswer = true);
      } else {
        setState(() => _seconds--);
      }
    });
  }

  void _next() {
    _timer?.cancel();
    final drill = context.read<DrillProvider>();
    drill.advance();
    if (!drill.drillComplete) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final drill = context.watch<DrillProvider>();
    if (drill.loading) {
      return const Scaffold(
          backgroundColor: AppTheme.background,
          body: Center(
              child: CircularProgressIndicator(color: AppTheme.gtoColor)));
    }
    if (drill.drillComplete) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🏆', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 16),
              Text('SRT Drill Complete!',
                  style: GoogleFonts.poppins(
                      color: AppTheme.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Back',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      );
    }

    final situation = drill.currentSrt;
    if (situation == null) return const SizedBox();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
            'SRT — Situation ${drill.currentIndex + 1} / ${drill.srtSituations.length}',
            style: GoogleFonts.poppins(fontSize: 14)),
        backgroundColor: AppTheme.background,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _timerColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('$_seconds s',
                style: GoogleFonts.poppins(
                    color: _timerColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (30 - _seconds) / 30,
              backgroundColor: AppTheme.border,
              valueColor:
                  AlwaysStoppedAnimation<Color>(_timerColor),
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF3B2A0F), Color(0xFF251A08)]),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppTheme.gtoColor.withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Situation',
                      style: GoogleFonts.poppins(
                          color: AppTheme.gtoColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12)),
                  const SizedBox(height: 8),
                  Text(situation.situation,
                      style: GoogleFonts.poppins(
                          color: AppTheme.textPrimary,
                          fontSize: 14,
                          height: 1.6)),
                ],
              ),
            ),
            if (_showAnswer) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppTheme.success.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Model Answer',
                        style: GoogleFonts.poppins(
                            color: AppTheme.success,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                    const SizedBox(height: 8),
                    Text(situation.modelAnswer,
                        style: GoogleFonts.poppins(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                            height: 1.5)),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 16),
              Center(
                child: Text('Write your response now...',
                    style: GoogleFonts.poppins(
                        color: AppTheme.textMuted,
                        fontSize: 13,
                        fontStyle: FontStyle.italic)),
              ),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.gtoColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                    _showAnswer ? 'Next Situation →' : 'Skip / Show Answer',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700, fontSize: 14)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Color get _timerColor => _seconds > 15
      ? AppTheme.success
      : _seconds > 5
          ? AppTheme.warning
          : AppTheme.error;
}

// ── SDT Guide ─────────────────────────────────────────────────────────────────

class _SdtGuideScreen extends StatelessWidget {
  const _SdtGuideScreen();

  static const _points = [
    ['What is SDT?', 'You write 5 things others say about you (positive/negative), 5 things you say about yourself, and a short self-description paragraph.'],
    ['Show Balance', 'Include 1 mild weakness (e.g., "sometimes overly detail-oriented") but always pair it with how you are working to improve it.'],
    ['Highlight OLQs', 'Focus on traits like initiative, mental robustness, group cohesion, effectiveness influence, and determination.'],
    ['Be Consistent', 'Your SDT should match what your WAT/SRT/TAT reveal about your personality.'],
    ['Sample Sentence', '"Others say I am determined and calm under pressure. My weakness is that I sometimes take on too much responsibility, but I am learning to delegate."'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('SDT Guide',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: AppTheme.background,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _points
            .map((p) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppTheme.success.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p[0],
                          style: GoogleFonts.poppins(
                              color: AppTheme.success,
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                      const SizedBox(height: 8),
                      Text(p[1],
                          style: GoogleFonts.poppins(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                              height: 1.5)),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

// ── OLQ Checklist ─────────────────────────────────────────────────────────────

class _OlqScreen extends StatefulWidget {
  const _OlqScreen();

  @override
  State<_OlqScreen> createState() => _OlqScreenState();
}

class _OlqScreenState extends State<_OlqScreen> {
  final Map<String, bool> _checks = {
    'Effective Intelligence': false,
    'Reasoning Ability': false,
    'Organising Ability': false,
    'Power of Expression': false,
    'Social Adaptability': false,
    'Co-operation': false,
    'Sense of Responsibility': false,
    'Initiative': false,
    'Self-confidence': false,
    'Speed of Decision': false,
    'Determination': false,
    'Courage': false,
    'Mental Robustness': false,
    'Group Cohesion': false,
    'Effectiveness-Influence': false,
  };

  @override
  Widget build(BuildContext context) {
    final checked = _checks.values.where((v) => v).length;
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('OLQ Checklist',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: AppTheme.background,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: checked / _checks.length,
                    backgroundColor: AppTheme.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.accent),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Text('$checked/${_checks.length}',
                    style: GoogleFonts.poppins(
                        color: AppTheme.accent,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _checks.keys
                  .map((olq) => CheckboxListTile(
                        value: _checks[olq],
                        onChanged: (v) =>
                            setState(() => _checks[olq] = v!),
                        title: Text(olq,
                            style: GoogleFonts.poppins(
                                color: AppTheme.textPrimary,
                                fontSize: 13)),
                        activeColor: AppTheme.accent,
                        checkColor: Colors.black,
                        side: const BorderSide(color: AppTheme.border),
                        controlAffinity: ListTileControlAffinity.trailing,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
