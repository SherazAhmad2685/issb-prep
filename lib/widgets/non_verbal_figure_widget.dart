import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/models/models.dart';
import '../core/theme/app_theme.dart';

/// Renders a dynamic, crisp vector diagram for PMA Non-Verbal Intelligence questions.
class NonVerbalFigureWidget extends StatelessWidget {
  final Question question;

  const NonVerbalFigureWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    if (question.section.toLowerCase() != 'nonverbal') {
      return const SizedBox.shrink();
    }

    final cat = question.category.toLowerCase();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.nonVerbalColor.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.nonVerbalColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'FIGURE DIAGRAM • ${question.category.toUpperCase()}',
                  style: GoogleFonts.poppins(
                    color: AppTheme.nonVerbalColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.auto_graph_rounded, color: AppTheme.nonVerbalColor, size: 16),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              height: 130,
              width: 280,
              child: CustomPaint(
                painter: _NonVerbalPainter(category: cat, text: question.text),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NonVerbalPainter extends CustomPainter {
  final String category;
  final String text;

  _NonVerbalPainter({required this.category, required this.text});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final accentPaint = Paint()
      ..color = AppTheme.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final fillPaint = Paint()
      ..color = AppTheme.nonVerbalColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    if (category.contains('mirror') || text.toLowerCase().contains('mirror')) {
      _paintMirror(canvas, size, strokePaint, accentPaint);
    } else if (category.contains('water') || text.toLowerCase().contains('water')) {
      _paintWaterReflection(canvas, size, strokePaint, accentPaint);
    } else if (category.contains('matrix')) {
      _paintMatrix(canvas, size, strokePaint, accentPaint);
    } else if (category.contains('series') || text.toLowerCase().contains('next')) {
      _paintSeries(canvas, size, strokePaint, accentPaint);
    } else if (category.contains('analogy')) {
      _paintAnalogy(canvas, size, strokePaint, accentPaint);
    } else if (category.contains('odd')) {
      _paintOddOneOut(canvas, size, strokePaint, accentPaint);
    } else {
      _paintGeometry(canvas, size, strokePaint, fillPaint);
    }
  }

  void _paintMirror(Canvas canvas, Size size, Paint stroke, Paint accent) {
    // Vertical dotted mirror axis
    final axisPaint = Paint()
      ..color = AppTheme.warning
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    for (double y = 10; y < size.height - 10; y += 8) {
      canvas.drawLine(Offset(cx, y), Offset(cx, y + 4), axisPaint);
    }

    // Left figure (Original)
    final leftCenter = Offset(cx - 60, size.height / 2);
    _drawShape(canvas, leftCenter, 30, stroke, isLeft: true);

    // Arrow to mirror
    _drawArrow(canvas, Offset(cx - 25, size.height / 2), Offset(cx - 10, size.height / 2), stroke);

    // Right figure (Reflected)
    final rightCenter = Offset(cx + 60, size.height / 2);
    _drawShape(canvas, rightCenter, 30, accent, isLeft: false);

    _drawText(canvas, Offset(cx - 75, size.height - 20), 'Object');
    _drawText(canvas, Offset(cx + 45, size.height - 20), 'Mirror [?]');
  }

  void _paintWaterReflection(Canvas canvas, Size size, Paint stroke, Paint accent) {
    final cy = size.height / 2;

    // Water surface line
    final waterPaint = Paint()
      ..color = AppTheme.info
      ..strokeWidth = 2.0;
    canvas.drawLine(Offset(30, cy), Offset(size.width - 30, cy), waterPaint);

    // Top object
    final topCenter = Offset(size.width / 2, cy - 35);
    _drawTriangle(canvas, topCenter, 25, stroke, pointUp: true);

    // Bottom reflected object
    final bottomCenter = Offset(size.width / 2, cy + 35);
    _drawTriangle(canvas, bottomCenter, 25, accent, pointUp: false);

    _drawText(canvas, Offset(35, cy - 15), 'Object');
    _drawText(canvas, Offset(35, cy + 5), 'Water Reflection');
  }

  void _paintMatrix(Canvas canvas, Size size, Paint stroke, Paint accent) {
    // 3x3 Grid
    const cellSize = 32.0;
    final startX = (size.width - (cellSize * 3)) / 2;
    final startY = (size.height - (cellSize * 3)) / 2;

    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        final rect = Rect.fromLTWH(
          startX + c * cellSize,
          startY + r * cellSize,
          cellSize,
          cellSize,
        );
        canvas.drawRect(rect, stroke);

        final cellCenter = rect.center;
        if (r == 2 && c == 2) {
          // Question mark box
          canvas.drawRect(rect, Paint()..color = AppTheme.accent.withValues(alpha: 0.2)..style = PaintingStyle.fill);
          _drawText(canvas, Offset(cellCenter.dx - 4, cellCenter.dy - 8), '?', color: AppTheme.accent, size: 16);
        } else {
          // Pattern dots or inner shape
          final dotCount = (r + c) % 3 + 1;
          for (int d = 0; d < dotCount; d++) {
            canvas.drawCircle(
              Offset(cellCenter.dx + (d - 1) * 6, cellCenter.dy),
              2.5,
              Paint()..color = Colors.white70..style = PaintingStyle.fill,
            );
          }
        }
      }
    }
  }

  void _paintSeries(Canvas canvas, Size size, Paint stroke, Paint accent) {
    final stepWidth = size.width / 4;
    final cy = size.height / 2;

    for (int i = 0; i < 4; i++) {
      final cx = 35 + i * (stepWidth - 5);
      final center = Offset(cx, cy);

      // Frame
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: center, width: 44, height: 44), const Radius.circular(8)),
        stroke,
      );

      if (i < 3) {
        // Rotating indicator: 0°, 45°, 90°
        final angle = i * (math.pi / 4);
        final end = Offset(
          center.dx + 15 * math.cos(angle),
          center.dy + 15 * math.sin(angle),
        );
        canvas.drawLine(center, end, Paint()..color = Colors.white..strokeWidth = 2);
        canvas.drawCircle(center, 3, Paint()..color = AppTheme.accent..style = PaintingStyle.fill);
      } else {
        // Step 4 is "?"
        _drawText(canvas, Offset(center.dx - 4, center.dy - 10), '?', color: AppTheme.accent, size: 18);
      }

      // Step label
      _drawText(canvas, Offset(center.dx - 8, cy + 28), '(${i + 1})', size: 9);
    }
  }

  void _paintAnalogy(Canvas canvas, Size size, Paint stroke, Paint accent) {
    final cy = size.height / 2;

    // Fig A
    canvas.drawCircle(Offset(45, cy), 18, stroke);
    _drawText(canvas, Offset(40, cy + 24), 'A', size: 10);

    // : (is to)
    _drawText(canvas, Offset(80, cy - 8), ':', size: 16, color: AppTheme.accent);

    // Fig B (Square)
    canvas.drawRect(Rect.fromCenter(center: Offset(115, cy), width: 34, height: 34), stroke);
    _drawText(canvas, Offset(110, cy + 24), 'B', size: 10);

    // :: (as)
    _drawText(canvas, Offset(150, cy - 8), '::', size: 16, color: AppTheme.warning);

    // Fig C (Triangle)
    _drawTriangle(canvas, Offset(185, cy), 20, stroke, pointUp: true);
    _drawText(canvas, Offset(180, cy + 24), 'C', size: 10);

    // : (is to)
    _drawText(canvas, Offset(215, cy - 8), ':', size: 16, color: AppTheme.accent);

    // Fig D (?)
    final dRect = Rect.fromCenter(center: Offset(245, cy), width: 34, height: 34);
    canvas.drawRRect(RRect.fromRectAndRadius(dRect, const Radius.circular(6)), accent);
    _drawText(canvas, Offset(240, cy - 10), '?', size: 16, color: AppTheme.accent);
    _drawText(canvas, Offset(240, cy + 24), 'D', size: 10);
  }

  void _paintOddOneOut(Canvas canvas, Size size, Paint stroke, Paint accent) {
    final cy = size.height / 2;
    final labels = ['A', 'B', 'C', 'D'];

    for (int i = 0; i < 4; i++) {
      final cx = 35 + i * 65.0;
      final center = Offset(cx, cy);

      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: center, width: 44, height: 44), const Radius.circular(8)),
        stroke,
      );

      if (i == 0) {
        canvas.drawCircle(center, 14, stroke);
      } else if (i == 1) {
        canvas.drawRect(Rect.fromCenter(center: center, width: 24, height: 24), stroke);
      } else if (i == 2) {
        _drawTriangle(canvas, center, 16, stroke, pointUp: true);
      } else {
        // Odd one out with different element (e.g. cross or 3D shaded)
        canvas.drawCircle(center, 14, stroke);
        canvas.drawLine(Offset(center.dx - 10, center.dy), Offset(center.dx + 10, center.dy), accent);
        canvas.drawLine(Offset(center.dx, center.dy - 10), Offset(center.dx, center.dy + 10), accent);
      }

      _drawText(canvas, Offset(center.dx - 4, cy + 28), labels[i], size: 10, color: Colors.white70);
    }
  }

  void _paintGeometry(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw regular hexagon or spatial geometric construction
    final path = Path();
    const sides = 6;
    const radius = 40.0;
    for (int i = 0; i < sides; i++) {
      final angle = (i * 2 * math.pi / sides) - (math.pi / 2);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);

    // Inner diagonals
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      Paint()..color = Colors.white38..strokeWidth = 1,
    );
  }

  void _drawShape(Canvas canvas, Offset center, double s, Paint paint, {required bool isLeft}) {
    final path = Path();
    final factor = isLeft ? 1 : -1;
    path.moveTo(center.dx - 15 * factor, center.dy - 15);
    path.lineTo(center.dx + 15 * factor, center.dy);
    path.lineTo(center.dx - 15 * factor, center.dy + 15);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawTriangle(Canvas canvas, Offset center, double size, Paint paint, {required bool pointUp}) {
    final path = Path();
    final dy = pointUp ? -1.0 : 1.0;
    path.moveTo(center.dx, center.dy + size * dy);
    path.lineTo(center.dx - size, center.dy - size * dy * 0.7);
    path.lineTo(center.dx + size, center.dy - size * dy * 0.7);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawArrow(Canvas canvas, Offset from, Offset to, Paint paint) {
    canvas.drawLine(from, to, paint);
  }

  void _drawText(Canvas canvas, Offset offset, String text, {Color color = Colors.white, double size = 11}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: GoogleFonts.poppins(color: color, fontSize: size, fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
