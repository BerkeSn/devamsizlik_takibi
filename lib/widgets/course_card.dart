import 'package:flutter/material.dart';

import '../models/course.dart';
import '../theme/app_theme.dart';

class CourseCard extends StatelessWidget {
  final Course       course;
  final bool         isDark;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const CourseCard({
    super.key,
    required this.course,
    required this.isDark,
    required this.onTap,
    required this.onDelete,
  });

  Color _statusColor() {
    switch (course.absenceStatus) {
      case AbsenceStatus.safe:     return AppColors.safe;
      case AbsenceStatus.warning:  return AppColors.warning;
      case AbsenceStatus.danger:   return AppColors.danger;
      case AbsenceStatus.critical: return AppColors.critical;
    }
  }

  String _statusLabel() {
    switch (course.absenceStatus) {
      case AbsenceStatus.safe:     return 'Güvende';
      case AbsenceStatus.warning:  return 'Dikkat';
      case AbsenceStatus.danger:   return 'Tehlike';
      case AbsenceStatus.critical: return 'Limit!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme       = Theme.of(context);
    final color       = AppColors.courseColor(course.colorIndex);
    final statusColor = _statusColor();
    final surface     = isDark ? AppColors.darkSurface  : AppColors.lightSurface;
    final border      = isDark ? AppColors.darkBorder   : AppColors.lightBorder;
    final muted       = isDark ? AppColors.darkTextMuted: AppColors.lightTextMuted;

    final progress = course.maxAbsences == 0
        ? 0.0
        : (course.totalAbsences / course.maxAbsences).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color:        surface,
          borderRadius: BorderRadius.circular(16),
          border:       Border.all(color: border),
        ),
        clipBehavior: Clip.hardEdge,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: color),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              course.name,
                              style: theme.textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),

                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color:        statusColor.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: statusColor.withOpacity(0.30)),
                            ),
                            child: Text(
                              _statusLabel(),
                              style: TextStyle(
                                color:      statusColor,
                                fontSize:   11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),

                          GestureDetector(
                            onTap: onDelete,
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Icon(Icons.delete_outline_rounded,
                                  size: 18, color: muted),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Text(
                        '${course.courseDay.turkishName}  ·  ${course.semester}',
                        style: TextStyle(fontSize: 12, color: muted),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          _MiniStat(
                            label: 'Devamsızlık',
                            value: '${course.totalAbsences}/${course.maxAbsences}',
                            color: statusColor,
                          ),
                          const SizedBox(width: 16),
                          _MiniStat(
                            label: 'Kalan hak',
                            value: '${course.remainingAbsences.clamp(0, 99)}',
                            color: color,
                          ),
                          const SizedBox(width: 16),
                          _MiniStat(
                            label: 'Katılım',
                            value: '%${(course.attendanceRate * 100).toStringAsFixed(0)}',
                            color: AppColors.safe,
                          ),
                          const Spacer(),
                          Icon(Icons.chevron_right_rounded,
                              size: 18, color: muted),
                        ],
                      ),

                      const SizedBox(height: 10),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value:           progress,
                          backgroundColor: isDark
                              ? AppColors.darkSurface2
                              : AppColors.lightSurface2,
                          valueColor: AlwaysStoppedAnimation(statusColor),
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color  color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize:   15,
            fontWeight: FontWeight.w700,
            color:      color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkTextMuted
                : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}
