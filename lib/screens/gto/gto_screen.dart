import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/models.dart';

class GtoScreen extends StatelessWidget {
  const GtoScreen({super.key});

  static final List<GtoTask> _tasks = [
    GtoTask(
      name: 'Group Discussion (GD)',
      description: 'All candidates discuss a topic without a designated leader. Assessors observe initiative, group cohesion, and leadership.',
      tips: '• Speak clearly and confidently\n• Listen to others and build on their points\n• Introduce new angles to the discussion\n• Do not talk excessively or stay silent\n• Summarise the group\'s view when appropriate',
      iconEmoji: '💬',
    ),
    GtoTask(
      name: 'Group Planning Exercise (GPE)',
      description: 'The group receives a complex problem. Each individual presents a plan, then the group agrees on one combined plan to present.',
      tips: '• Study the model carefully\n• Prepare a clear, logical individual plan\n• Compromise constructively during group discussion\n• Present confidently and concisely',
      iconEmoji: '📋',
    ),
    GtoTask(
      name: 'Progressive Group Task (PGT)',
      description: 'The group solves a series of increasingly difficult outdoor obstacle problems using limited resources.',
      tips: '• Take initiative early\n• Think creatively with available materials\n• Encourage quieter members\n• Keep track of time\n• Demonstrate leadership through practical help',
      iconEmoji: '🏗️',
    ),
    GtoTask(
      name: 'Half Group Task (HGT)',
      description: 'The group is split in half. Each half solves an outdoor task independently, allowing more individual visibility.',
      tips: '• Increased individual opportunity — be visible\n• Lead sub-tasks\n• Show quick decision-making',
      iconEmoji: '⚡',
    ),
    GtoTask(
      name: 'Final Group Task (FGT)',
      description: 'The full group completes a final complex outdoor obstacle task. It is the last GTO activity.',
      tips: '• Apply lessons from PGT/HGT\n• Be consistent in your leadership\n• Help teammates who are struggling\n• Finish strong — assessors note final impressions',
      iconEmoji: '🏁',
    ),
    GtoTask(
      name: 'Command Task (CT)',
      description: 'Each candidate takes command of a small group and must solve a problem as the leader, giving orders to teammates.',
      tips: '• Plan before acting\n• Give clear, specific orders\n• Involve all team members\n• Adapt if the plan isn\'t working\n• Maintain controlled authority — not aggressive',
      iconEmoji: '🎖️',
    ),
    GtoTask(
      name: 'Individual Obstacles (IO)',
      description: 'Each candidate completes a personal obstacle course. Time and technique are evaluated.',
      tips: '• Attempt all obstacles\n• Show confidence at height\n• Pace yourself — do not burn out early\n• Smile and show positive attitude even if you struggle',
      iconEmoji: '🏃',
    ),
    GtoTask(
      name: 'IO Interview (Personal Interview)',
      description: 'A 1-on-1 interview with an Interviewing Officer. Covers your background, motivation, current affairs, and personality.',
      tips: '• Know your background deeply: hometown, school, family, hobbies\n• Prepare for: "Why do you want to join the Army?"\n• Stay updated on current affairs (Pakistan & world)\n• Be honest — contradictions are probed\n• Speak confidently but humbly',
      iconEmoji: '🎤',
    ),
  ];

  static const _interviewQuestions = [
    'Why do you want to join the Pakistan Army?',
    'Tell me about yourself.',
    'What are your strengths and weaknesses?',
    'Who is your role model and why?',
    'What is the current security situation of Pakistan?',
    'Name the current Chief of Army Staff.',
    'What is CPEC and its significance?',
    'What would you do if your orders conflict with your ethics?',
    'How do you handle stress?',
    'Describe a time you led a team.',
    'What do you know about ISSB?',
    'What are the OLQs (Officer-Like Qualities)?',
    'What is the difference between a leader and a manager?',
    'Where does Pakistan stand in terms of military strength globally?',
    'What is your plan if you are not selected at ISSB?',
    'Name three recent major operations of the Pakistan Army.',
    'What is the GHQ and where is it located?',
    'What does the Shaheen falcon symbolize for PAF?',
    'Explain your understanding of loyalty and its importance in the Army.',
    'What qualities make a good officer?',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: Text('GTO & Interview Prep',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          backgroundColor: AppTheme.background,
          bottom: TabBar(
            indicatorColor: AppTheme.gtoColor,
            labelColor: AppTheme.gtoColor,
            unselectedLabelColor: AppTheme.textMuted,
            labelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, fontSize: 13),
            tabs: const [
              Tab(text: 'GTO Tasks'),
              Tab(text: 'Interview Q&A'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildGtoList(context),
            _buildInterviewList(),
          ],
        ),
      ),
    );
  }

  Widget _buildGtoList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _tasks.length,
      itemBuilder: (context, i) {
        final task = _tasks[i];
        return _taskCard(context, task);
      },
    );
  }

  Widget _taskCard(BuildContext context, GtoTask task) {
    return GestureDetector(
      onTap: () => _showTaskDetail(context, task),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.gtoColor.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.gtoColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                  child: Text(task.iconEmoji,
                      style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.name,
                      style: GoogleFonts.poppins(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    task.description.length > 70
                        ? '${task.description.substring(0, 70)}...'
                        : task.description,
                    style: GoogleFonts.poppins(
                        color: AppTheme.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppTheme.gtoColor),
          ],
        ),
      ),
    );
  }

  void _showTaskDetail(BuildContext context, GtoTask task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        maxChildSize: 0.92,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollCtrl) => ListView(
          controller: scrollCtrl,
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Text(task.iconEmoji,
                  style: const TextStyle(fontSize: 40)),
            ),
            const SizedBox(height: 12),
            Text(task.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 18)),
            const SizedBox(height: 16),
            Text('Description',
                style: GoogleFonts.poppins(
                    color: AppTheme.gtoColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
            const SizedBox(height: 8),
            Text(task.description,
                style: GoogleFonts.poppins(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    height: 1.5)),
            const SizedBox(height: 16),
            Text('Tips to Excel',
                style: GoogleFonts.poppins(
                    color: AppTheme.accent,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
            const SizedBox(height: 8),
            Text(task.tips,
                style: GoogleFonts.poppins(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    height: 1.7)),
          ],
        ),
      ),
    );
  }

  Widget _buildInterviewList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _interviewQuestions.length,
      itemBuilder: (context, i) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppTheme.gtoColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text('${i + 1}',
                    style: GoogleFonts.poppins(
                        color: AppTheme.gtoColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 11)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(_interviewQuestions[i],
                  style: GoogleFonts.poppins(
                      color: AppTheme.textPrimary, fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}
