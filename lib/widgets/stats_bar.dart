// ─────────────────────────────────────────────
// stats_bar.dart  →  Dönem istatistik özeti
// ─────────────────────────────────────────────
//
// fl_chart paketi yok → saf Flutter widget'larıyla
// basit ama bilgilendirici bir özet bar.
//
// 4 stat kutusu + renkli segment bar gösterir.

import 'package:flutter/material.dart';

import '../models/course.dart';
import '../theme/app_theme.dart';

class StatsBar extends StatelessWidget {
  final List<Course> courses;
  final bool isDark;

  const StatsBar(
      {super.key,
      required this.courses,
      required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty)
      return const SizedBox.shrink();

    final theme = Theme.of(context);
    final surface = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;
    final border = isDark
        ? AppColors.darkBorder
        : AppColors.lightBorder;

    // Durum sayıları
    int safe = 0,
        warning = 0,
        danger = 0,
        critical = 0;
    for (final c in courses) {
      switch (c.absenceStatus) {
        case AbsenceStatus.safe:
          safe++;
          break;
        case AbsenceStatus.warning:
          warning++;
          break;
        case AbsenceStatus.danger:
          danger++;
          break;
        case AbsenceStatus.critical:
          critical++;
          break;
      }
    }

    // Genel katılım yüzdesi
    final avgRate = courses.isEmpty
        ? 1.0
        : courses.fold<double>(0,
                (s, c) => s + c.attendanceRate) /
            courses.length;

    // En çok devamsız ders
    final mostAbsent = courses.isEmpty
        ? null
        : courses.reduce((a, b) =>
            a.totalAbsences > b.totalAbsences
                ? a
                : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // ── Başlık ───────────────────────────
          Row(
            children: [
              Text('Dönem Özeti',
                  style:
                      theme.textTheme.titleSmall),
              const Spacer(),
              Text(
                '%${(avgRate * 100).toStringAsFixed(0)} genel katılım',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.safe,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── 4 stat kutusu ────────────────────
          Row(
            children: [
              _StatBox(
                  label: 'Güvende',
                  value: '$safe',
                  color: AppColors.safe,
                  isDark: isDark),
              const SizedBox(width: 8),
              _StatBox(
                  label: 'Dikkat',
                  value: '$warning',
                  color: AppColors.warning,
                  isDark: isDark),
              const SizedBox(width: 8),
              _StatBox(
                  label: 'Tehlike',
                  value: '$danger',
                  color: AppColors.danger,
                  isDark: isDark),
              const SizedBox(width: 8),
              _StatBox(
                  label: 'Kritik',
                  value: '$critical',
                  color: AppColors.critical,
                  isDark: isDark),
            ],
          ),
          const SizedBox(height: 12),

          // ── Segment bar ───────────────────────
          // Her durumun oranını yatay olarak gösterir.
          // fl_chart yerine basit Row + Flexible tekniği.
          ClipRRect(
            borderRadius:
                BorderRadius.circular(4),
            child: SizedBox(
              height: 6,
              child: Row(
                children: [
                  if (safe > 0)
                    _Segment(
                        flex: safe,
                        color: AppColors.safe),
                  if (warning > 0)
                    _Segment(
                        flex: warning,
                        color: AppColors.warning),
                  if (danger > 0)
                    _Segment(
                        flex: danger,
                        color: AppColors.danger),
                  if (critical > 0)
                    _Segment(
                        flex: critical,
                        color:
                            AppColors.critical),
                  // Eğer hiçbir ders yoksa gri bar
                  if (safe +
                          warning +
                          danger +
                          critical ==
                      0)
                    Expanded(
                      child: Container(
                        color: isDark
                            ? AppColors
                                .darkSurface2
                            : AppColors
                                .lightSurface2,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── En çok devamsız ders ─────────────
          if (mostAbsent != null &&
              mostAbsent.totalAbsences > 0) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 13,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors
                            .lightTextMuted),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'En çok devamsız: ${mostAbsent.name} (${mostAbsent.totalAbsences} hafta)',
                    style: theme
                        .textTheme.labelSmall,
                    overflow:
                        TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Stat kutusu ───────────────────────────────
class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: color.withOpacity(0.20)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Segment bar parçası ───────────────────────
class _Segment extends StatelessWidget {
  final int flex;
  final Color color;
  const _Segment(
      {required this.flex, required this.color});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      child: Container(color: color),
    );
  }
}
