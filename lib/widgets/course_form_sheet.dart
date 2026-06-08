import 'package:flutter/material.dart';

import '../models/course.dart';
import '../theme/app_theme.dart';

class CourseFormSheet extends StatefulWidget {
  final String semester;
  final Course? existingCourse;

  final Function(
    String name,
    int totalWeeks,
    int maxAbsences,
    int colorIndex,
    WeekDay courseDay,
  ) onSave;

  const CourseFormSheet({
    super.key,
    required this.semester,
    required this.onSave,
    this.existingCourse,
  });

  @override
  State<CourseFormSheet> createState() =>
      _CourseFormSheetState();
}

class _CourseFormSheetState
    extends State<CourseFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;

  late int _totalWeeks;
  late int _maxAbsences;
  late int _colorIndex;
  late WeekDay _courseDay;

  @override
  void initState() {
    super.initState();
    final c = widget.existingCourse;
    _nameCtrl = TextEditingController(
        text: c?.name ?? '');
    _totalWeeks = c?.totalWeeks ?? 14;
    _maxAbsences = c?.maxAbsences ?? 6;
    _colorIndex = c?.colorIndex ?? 0;
    _courseDay = c?.courseDay ?? WeekDay.monday;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate())
      return;

    widget.onSave(
      _nameCtrl.text.trim(),
      _totalWeeks,
      _maxAbsences,
      _colorIndex,
      _courseDay,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark =
        theme.brightness == Brightness.dark;
    final surface = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;
    final surface2 = isDark
        ? AppColors.darkSurface2
        : AppColors.lightSurface2;
    final border = isDark
        ? AppColors.darkBorder
        : AppColors.lightBorder;
    final isEdit = widget.existingCourse != null;

    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context)
              .viewInsets
              .bottom),
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius:
              const BorderRadius.vertical(
                  top: Radius.circular(24)),
          border: Border(
              top: BorderSide(color: border)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
              24, 12, 24, 36),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(
                        bottom: 20),
                    decoration: BoxDecoration(
                      color: border,
                      borderRadius:
                          BorderRadius.circular(
                              2),
                    ),
                  ),
                ),
                Text(
                  isEdit
                      ? 'Dersi Düzenle'
                      : 'Yeni Ders Ekle',
                  style: theme
                      .textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  widget.semester,
                  style:
                      theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameCtrl,
                  decoration:
                      const InputDecoration(
                    labelText: 'Ders Adı',
                    prefixIcon: Icon(
                        Icons.book_outlined,
                        size: 18,
                        color: AppColors.accent),
                  ),
                  textCapitalization:
                      TextCapitalization.words,
                  validator: (v) => (v == null ||
                          v.trim().isEmpty)
                      ? 'Ders adı boş bırakılamaz'
                      : null,
                ),
                const SizedBox(height: 20),
                _Stepper(
                  label: 'Toplam Hafta',
                  sublabel:
                      'Dönem boyunca kaç hafta ders var?',
                  value: _totalWeeks,
                  min: 1,
                  max: 52,
                  onChanged: (v) => setState(
                      () => _totalWeeks = v),
                  isDark: isDark,
                ),
                const SizedBox(height: 16),
                _Stepper(
                  label: 'Devamsızlık Hakkı',
                  sublabel:
                      'En fazla kaç kere devamsız kalabilirsin?',
                  value: _maxAbsences,
                  min: 0,
                  max: 30,
                  onChanged: (v) => setState(
                      () => _maxAbsences = v),
                  isDark: isDark,
                ),
                const SizedBox(height: 24),
                Text('Ders Günü',
                    style: theme
                        .textTheme.titleSmall),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      WeekDay.values.map((day) {
                    final selected =
                        _courseDay == day;
                    return GestureDetector(
                      onTap: () => setState(
                          () => _courseDay = day),
                      child: AnimatedContainer(
                        duration: const Duration(
                            milliseconds: 150),
                        padding: const EdgeInsets
                            .symmetric(
                            horizontal: 14,
                            vertical: 9),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.accent
                              : surface2,
                          borderRadius:
                              BorderRadius
                                  .circular(10),
                          border: Border.all(
                            color: selected
                                ? AppColors.accent
                                : border,
                          ),
                        ),
                        child: Text(
                          day.shortName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: selected
                                ? Colors.white
                                : theme
                                    .textTheme
                                    .bodyMedium
                                    ?.color,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Text('Ders Rengi',
                    style: theme
                        .textTheme.titleSmall),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(
                    AppColors.courseColors.length,
                    (i) {
                      final selected =
                          _colorIndex == i;
                      final color = AppColors
                          .courseColors[i];
                      return GestureDetector(
                        onTap: () => setState(
                            () =>
                                _colorIndex = i),
                        child: AnimatedContainer(
                          duration:
                              const Duration(
                                  milliseconds:
                                      150),
                          width: 32,
                          height: 32,
                          decoration:
                              BoxDecoration(
                            color: color,
                            shape:
                                BoxShape.circle,
                            border: selected
                                ? Border.all(
                                    color: isDark
                                        ? Colors
                                            .white
                                        : Colors
                                            .black,
                                    width: 2.5,
                                  )
                                : null,
                          ),
                          child: selected
                              ? const Icon(
                                  Icons
                                      .check_rounded,
                                  color: Colors
                                      .white,
                                  size: 16,
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _save,
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          AppColors.accent,
                      padding: const EdgeInsets
                          .symmetric(
                          vertical: 16),
                      shape:
                          RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          12)),
                    ),
                    child: Text(
                      isEdit
                          ? 'Değişiklikleri Kaydet'
                          : 'Dersi Ekle',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  final String label;
  final String sublabel;
  final int value;
  final int min;
  final int max;
  final Function(int) onChanged;
  final bool isDark;

  const _Stepper({
    required this.label,
    required this.sublabel,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface2 = isDark
        ? AppColors.darkSurface2
        : AppColors.lightSurface2;
    final border = isDark
        ? AppColors.darkBorder
        : AppColors.lightBorder;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                      theme.textTheme.titleSmall),
              const SizedBox(height: 2),
              Text(sublabel,
                  style:
                      theme.textTheme.labelSmall),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: surface2,
            borderRadius:
                BorderRadius.circular(10),
            border: Border.all(color: border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StepBtn(
                icon: Icons.remove,
                enabled: value > min,
                onTap: () => onChanged(value - 1),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _StepBtn(
                icon: Icons.add,
                enabled: value < max,
                onTap: () => onChanged(value + 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _StepBtn({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 10),
        child: Icon(
          icon,
          size: 16,
          color: enabled
              ? Theme.of(context).iconTheme.color
              : Theme.of(context).disabledColor,
        ),
      ),
    );
  }
}
