import 'package:flutter_test/flutter_test.dart';
import 'package:issb_prep/core/models/models.dart';

void main() {
  group('PaperResult Marking Engine Tests', () {
    test('Calculates score without negative marking', () {
      final score = PaperResult.calculateScore(
        correct: 10,
        wrong: 5,
        negativeMarking: false,
      );
      expect(score, equals(10.0));
    });

    test('Calculates score with negative marking (-0.25 per wrong answer)', () {
      final score = PaperResult.calculateScore(
        correct: 10,
        wrong: 4,
        negativeMarking: true,
      );
      // 10 correct - (4 * 0.25)
      expect(score, equals(9.0));
    });

    test('Score does not drop below zero with severe negative marking', () {
      final score = PaperResult.calculateScore(
        correct: 2,
        wrong: 20, // 20 * 0.25 = 5 penalty
        negativeMarking: true,
      );
      // 2 - 5 = -3, clamped to 0
      expect(score, equals(0.0));
    });
  });
}
