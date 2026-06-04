import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/course.dart';
import '../theme/app_theme.dart';
import '../widgets/course_card.dart';
import '../widgets/course_form_sheet.dart';
import '../widgets/stats_bar.dart';
import 'attendance_screen.dart';

class HomeScreen extends StatelessWidget {
  final bool isDark;
  final List<Course> courses;
  final String selectedSemester;
  final List<String> semesters;
  final VoidCallback onToggleTheme;
  final Function(Course) onAddCourse;
  final Function(Course) onUpdateCourse;
  final Function(String) onDeleteCourse;
  final Function(String, int) onToggleAttendance;
  final Function(String) onSelectSemester;
  final Function(String) onAddSemester;

  const HomeScreen({
    super.key,
    required this.isDark,
    required this.courses,
    required this.selectedSemester,
    required this.semesters,
    required this.onToggleTheme,
    required this.onAddCourse,
    required this.onUpdateCourse,
    required this.onDeleteCourse,
    required this.onToggleAttendance,
    required this.onSelectSemester,
    required this.onAddSemester,
  });

  List<Course> get _filtered => courses
      .where(
          (c) => c.semester == selectedSemester)
      .toList();

  void _openAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true,
      builder: (_) => CourseFormSheet(
        semester: selectedSemester,
        onSave: (name, totalWeeks, maxAbsences,
            colorIndex, courseDay) {
          onAddCourse(Course(
            id: const Uuid()
                .v4(),
            name: name,
            totalWeeks: totalWeeks,
            maxAbsences: maxAbsences,
            colorIndex: colorIndex,
            courseDay: courseDay,
            semester: selectedSemester,
          ));
        },
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, Course course) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Dersi Sil'),
        content: Text(
            '"${course.name}" dersini ve tüm devamsızlık verilerini silmek istediğine emin misin?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Vazgeç',
                style: TextStyle(
                    color: Theme.of(ctx)
                        .textTheme
                        .bodySmall
                        ?.color)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor:
                    AppColors.critical),
            onPressed: () {
              onDeleteCourse(course.id);
              Navigator.pop(ctx);
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  void _openSemesterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _SemesterSheet(
        semesters: semesters,
        selected: selectedSemester,
        onSelect: onSelectSemester,
        onAdd: onAddSemester,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filtered;
    final bg = isDark
        ? AppColors.darkBg
        : AppColors.lightBg;
    final border = isDark
        ? AppColors.darkBorder
        : AppColors.lightBorder;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            
            SliverAppBar(
              floating: true,
              pinned: false,
              backgroundColor: bg,
              titleSpacing: 20,
              title: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text('AkademiTakip',
                      style: theme
                          .textTheme.titleLarge),
                  const SizedBox(height: 1),
                  Text(
                    '${filtered.length} ders',
                    style:
                        theme.textTheme.bodySmall,
                  ),
                ],
              ),
              actions: [
                
                GestureDetector(
                  onTap: () =>
                      _openSemesterSheet(context),
                  child: Container(
                    margin: const EdgeInsets.only(
                        right: 8),
                    padding: const EdgeInsets
                        .symmetric(
                        horizontal: 12,
                        vertical: 7),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(
                              20),
                      border: Border.all(
                          color: border),
                    ),
                    child: Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        Text(
                          selectedSemester,
                          style: theme.textTheme
                              .labelSmall
                              ?.copyWith(
                                  fontWeight:
                                      FontWeight
                                          .w600),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                            Icons
                                .keyboard_arrow_down_rounded,
                            size: 15,
                            color: theme
                                .textTheme
                                .bodySmall
                                ?.color),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onToggleTheme,
                  tooltip: isDark
                      ? 'Açık moda geç'
                      : 'Koyu moda geç',
                  icon: AnimatedSwitcher(
                    duration: const Duration(
                        milliseconds: 250),
                    child: Icon(
                      isDark
                          ? Icons
                              .wb_sunny_outlined
                          : Icons
                              .nightlight_round,
                      key: ValueKey(
                          isDark),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),

            if (filtered.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(
                          16, 8, 16, 0),
                  child: StatsBar(
                      courses: filtered,
                      isDark: isDark),
                ),
              ),

            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                        20, 20, 20, 8),
                child: Text(
                  'Derslerim',
                  style: theme
                      .textTheme.labelSmall
                      ?.copyWith(
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            if (filtered.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.accent
                              .withOpacity(0.08),
                          borderRadius:
                              BorderRadius
                                  .circular(20),
                        ),
                        child: const Icon(
                            Icons
                                .menu_book_rounded,
                            color:
                                AppColors.accent,
                            size: 34),
                      ),
                      const SizedBox(height: 16),
                      Text('Henüz ders eklenmedi',
                          style: theme.textTheme
                              .titleMedium),
                      const SizedBox(height: 6),
                      Text(
                        'Sağ alttaki + butonuna bas',
                        style: theme
                            .textTheme.bodySmall,
                        textAlign:
                            TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

            SliverList(
              delegate:
                  SliverChildBuilderDelegate(
                (context, index) {
                  final course = filtered[index];
                  return Padding(
                    padding:
                        const EdgeInsets.fromLTRB(
                            16, 0, 16, 10),
                    child: CourseCard(
                      course: course,
                      isDark: isDark,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AttendanceScreen(
                            course: course,
                            isDark: isDark,
                            onUpdateCourse:
                                onUpdateCourse,
                            onToggleAttendance:
                                onToggleAttendance,
                          ),
                        ),
                      ),
                      onDelete: () =>
                          _confirmDelete(
                              context, course),
                    ),
                  );
                },
                childCount: filtered.length,
              ),
            ),

            const SliverToBoxAdapter(
                child: SizedBox(height: 100)),
          ],
        ),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () => _openAddSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Ders Ekle',
            style: TextStyle(
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _SemesterSheet extends StatefulWidget {
  final List<String> semesters;
  final String selected;
  final Function(String) onSelect;
  final Function(String) onAdd;

  const _SemesterSheet({
    required this.semesters,
    required this.selected,
    required this.onSelect,
    required this.onAdd,
  });

  @override
  State<_SemesterSheet> createState() =>
      _SemesterSheetState();
}

class _SemesterSheetState
    extends State<_SemesterSheet> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context)
              .viewInsets
              .bottom),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            24, 14, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .dividerColor,
                  borderRadius:
                      BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text('Dönem Seç',
                style:
                    theme.textTheme.titleLarge),
            const SizedBox(height: 12),

            ...widget.semesters.map((s) {
              final isSelected =
                  s == widget.selected;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  widget.onSelect(s);
                  Navigator.pop(context);
                },
                title: Text(
                  s,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color: isSelected
                        ? AppColors.accent
                        : null,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        color: AppColors.accent,
                        size: 18)
                    : null,
              );
            }),

            const Divider(height: 24),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    decoration: const InputDecoration(
                        hintText:
                            'Yeni dönem  (ör. Bahar 2026)'),
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets
                        .symmetric(
                        horizontal: 18,
                        vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                12)),
                  ),
                  onPressed: () {
                    final name =
                        _ctrl.text.trim();
                    if (name.isNotEmpty) {
                      widget.onAdd(name);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Ekle'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
