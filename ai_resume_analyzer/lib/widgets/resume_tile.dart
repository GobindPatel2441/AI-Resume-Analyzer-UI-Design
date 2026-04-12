import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class ResumeTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final double score;
  final VoidCallback onTap;
  final DateTime? date;
  final VoidCallback? onDelete;

  const ResumeTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.score,
    required this.onTap,
    this.date,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    Color scoreColor;
    if (score >= 80) {
      scoreColor = Colors.green;
    } else if (score >= 60) {
      scoreColor = Colors.orange;
    } else {
      scoreColor = Colors.red;
    }

    String dateStr = '';
    if (date != null) {
      dateStr =
          '${date!.day}/${date!.month}/${date!.year}';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: onDelete,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.only(right: 8),
              ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.picture_as_pdf_outlined,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (dateStr.isNotEmpty)
              Text(
                dateStr,
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 11),
              ),
          ],
        ),
        trailing: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: scoreColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${score.toInt()}',
            style: TextStyle(
              color: scoreColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
