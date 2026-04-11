import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class ScoreIndicator extends StatelessWidget {
  final double score;
  final double size;

  const ScoreIndicator({
    super.key,
    required this.score,
    this.size = 150,
  });

  @override
  Widget build(BuildContext context) {
    Color scoreColor;
    String label;
    if (score >= 80) {
      scoreColor = Colors.green;
      label = 'Excellent';
    } else if (score >= 60) {
      scoreColor = Colors.orange;
      label = 'Good';
    } else {
      scoreColor = Colors.red;
      label = 'Needs Work';
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: score / 100),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, _) {
        return Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: size,
                  width: size,
                  child: CircularProgressIndicator(
                    value: animValue,
                    strokeWidth: 14,
                    backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                    color: scoreColor,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(animValue * 100).toInt()}',
                      style: TextStyle(
                        fontSize: size * 0.27,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'ATS Score',
                      style: TextStyle(
                        fontSize: size * 0.09,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: scoreColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: TextStyle(
                    color: scoreColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }
}
