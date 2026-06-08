import 'package:flutter/material.dart';

import '../models/course.dart';
import '../theme/app_theme.dart';
import '../widgets/course_form_sheet.dart';

class AttendanceScreen extends StatelessWidget {
  final Course course;
  final bool isDark;
  final Function(Course) onUpdateCourse;
  final Function(String, int) onToggleAttendance;

  const AttendanceScreen({
    super.key,
    required this.course,
    required this.isDark,
    required this.onUpdateCourse,
    required this.onToggleAttendance,
  });

  Color _statusColor() {
    switch (course.absenceStatus) {
      case AbsenceStatus.safe:
        return AppColors.safe;
      case AbsenceStatus.warning:
        return AppColors.warning;
      case AbsenceStatus.danger:
        return AppColors.danger;
      case AbsenceStatus.critical:
        return AppColors.critical;
    }
  }

  String _statusMessage() {
    final r = course.remainingAbsences;
    switch (course.absenceStatus) {
      case AbsenceStatus.safe:
        return '$r devamsızlık hakkın var';
      case AbsenceStatus.warning:
        return 'Dikkat! Yalnızca $r hakkın kaldı';
      case AbsenceStatus.danger:
        return 'Tehlike! Sadece $r hakkın var';
      case AbsenceStatus.critical:
        return r <= 0
            ? 'Devamsızlık limitini doldurdun!'
            : 'Son $r hakkın — çok dikkatli ol!';
    }
  }

  void _openEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => CourseFormSheet(
        semester: course.semester,
        existingCourse:
            course,
        onSave: (name, totalWeeks, maxAbsences,
            colorIndex, courseDay) {
          course.name = name;
          course.totalWeeks = totalWeeks;
          course.maxAbsences = maxAbsences;
          course.colorIndex = colorIndex;
          course.courseDay = courseDay;
          onUpdateCourse(course);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        AppColors.courseColor(course.colorIndex);
    final statusColor = _statusColor();
    final bg = isDark
        ? AppColors.darkBg
        : AppColors.lightBg;
    final surface = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;
    final border = isDark
        ? AppColors.darkBorder
        : AppColors.lightBorder;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        
        leading: IconButton(
          icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(course.name,
                  style:
                      theme.textTheme.titleMedium,
                  overflow:
                      TextOverflow.ellipsis),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () =>
                _openEditSheet(context),
            icon: const Icon(Icons.edit_outlined,
                size: 16),
            label: const Text('Düzenle',
                style: TextStyle(fontSize: 13)),
            style: TextButton.styleFrom(
                foregroundColor:
                    AppColors.accent),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  16, 8, 16, 0),
              child: _SummaryCard(
                course: course,
                color: color,
                statusColor: statusColor,
                statusMsg: _statusMessage(),
                isDark: isDark,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  20, 20, 20, 10),
              child: Row(
                children: [
                  Text('Haftalık Takvim',
                      style: theme
                          .textTheme.titleSmall),
                  const Spacer(),
                  const _LegendDot(
                      color: AppColors.safe,
                      label: 'Katıldım'),
                  const SizedBox(width: 10),
                  const _LegendDot(
                      color: AppColors.critical,
                      label: 'Gitmedim'),
                  const SizedBox(width: 10),
                  _LegendDot(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                    label: '—',
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  20, 0, 20, 12),
              child: Text(
                '1.tık → Katıldım  ·  2.tık → Gitmedim  ·  3.tık → Sıfırla',
                style: theme.textTheme.labelSmall,
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
                16, 0, 16, 100),
            sliver: SliverGrid(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              delegate:
                  SliverChildBuilderDelegate(
                (context, index) {
                  final week = index + 1;
                  final attended = course
                          .attendanceMap[
                      week];
                  return _WeekTile(
                    week: week,
                    attended: attended,
                    dayLabel: course
                        .courseDay.shortName,
                    isDark: isDark,
                    onTap: () =>
                        onToggleAttendance(
                            course.id, week),
                  );
                },
                childCount: course.totalWeeks,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final Course course;
  final Color color;
  final Color statusColor;
  final String statusMsg;
  final bool isDark;

  const _SummaryCard({
    required this.course,
    required this.color,
    required this.statusColor,
    required this.statusMsg,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final surface = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;
    final border = isDark
        ? AppColors.darkBorder
        : AppColors.lightBorder;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _StatBox(
                label: 'Devamsızlık',
                value:
                    '${course.totalAbsences}/${course.maxAbsences}',
                valueColor: statusColor,
              ),
              _Divider(),
              _StatBox(
                label: 'Kalan Hak',
                value:
                    '${course.remainingAbsences.clamp(0, 99)}',
                valueColor: color,
              ),
              _Divider(),
              _StatBox(
                label: 'Katılım',
                value:
                    '${(course.attendanceRate * 100).toStringAsFixed(0)}%',
                valueColor: AppColors.safe,
              ),
            ],
          ),

          const SizedBox(height: 14),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  Text(
                      '${course.courseDay.turkishName} günleri  ·  ${course.totalWeeks} hafta',
                      style: theme
                          .textTheme.labelSmall),
                  Text(
                    course.absenceStatus ==
                            AbsenceStatus.critical
                        ? 'Limit doldu!'
                        : '${course.remainingAbsences.clamp(0, 99)} hak kaldı',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: course.maxAbsences == 0
                      ? 0
                      : (course.totalAbsences /
                              course.maxAbsences)
                          .clamp(0.0, 1.0),
                  backgroundColor: isDark
                      ? AppColors.darkSurface2
                      : AppColors.lightSurface2,
                  valueColor:
                      AlwaysStoppedAnimation(
                          statusColor),
                  minHeight: 6,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color:
                  statusColor.withOpacity(0.08),
              borderRadius:
                  BorderRadius.circular(10),
              border: Border.all(
                  color: statusColor
                      .withOpacity(0.2)),
            ),
            child: Text(
              statusMsg,
              style: TextStyle(
                color: statusColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  const _StatBox(
      {required this.label,
      required this.value,
      required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: valueColor),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: Theme.of(context).dividerColor,
    );
  }
}

class _WeekTile extends StatelessWidget {
  final int week;
  final bool?
      attended;
  final String dayLabel;
  final bool isDark;
  final VoidCallback onTap;

  const _WeekTile({
    required this.week,
    required this.attended,
    required this.dayLabel,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color borderColor;
    final Widget centerIcon;

    if (attended == null) {
      bgColor = isDark
          ? AppColors.darkSurface
          : AppColors.lightSurface;
      borderColor = isDark
          ? AppColors.darkBorder
          : AppColors.lightBorder;
      centerIcon = Icon(Icons.circle_outlined,
          size: 18,
          color: isDark
              ? AppColors.darkBorder
              : AppColors.lightBorder);
    } else if (attended == true) {
      bgColor = AppColors.safe.withOpacity(0.08);
      borderColor =
          AppColors.safe.withOpacity(0.35);
      centerIcon = const Icon(Icons.check_rounded,
          size: 20, color: AppColors.safe);
    } else {
      bgColor =
          AppColors.critical.withOpacity(0.08);
      borderColor =
          AppColors.critical.withOpacity(0.35);
      centerIcon = const Icon(Icons.close_rounded,
          size: 20, color: AppColors.critical);
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Text(
              'Hafta',
              style: TextStyle(
                fontSize: 9,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$week',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark
                    ? AppColors.darkText
                    : AppColors.lightText,
                height: 1.1,
              ),
            ),
            Text(
              dayLabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 4),
            centerIcon,
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot(
      {required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: Theme.of(context)
                .textTheme
                .labelSmall),
      ],
    );
  }
}

