import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/course.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AkademiTakipApp());
}

class AkademiTakipApp extends StatefulWidget {
  const AkademiTakipApp({super.key});

  @override
  State<AkademiTakipApp> createState() =>
      _AkademiTakipAppState();
}

class _AkademiTakipAppState
    extends State<AkademiTakipApp> {
  bool _isDark = true;

  final List<Course> _courses = [];

  String _selectedSemester = 'Bahar 2025';
  final List<String> _semesters = [
    'Güz 2024',
    'Bahar 2025',
    'Güz 2025'
  ];

  void _toggleTheme() {
    setState(() => _isDark = !_isDark);
  }


  void _addCourse(Course course) {
    setState(() => _courses.add(course));
  }

  void _updateCourse(Course updated) {
    setState(() {
      final index = _courses
          .indexWhere((c) => c.id == updated.id);
      if (index != -1) _courses[index] = updated;
    });
  }

  void _deleteCourse(String id) {
    setState(() =>
        _courses.removeWhere((c) => c.id == id));
  }

  void _toggleAttendance(
      String courseId, int week) {
    setState(() {
      final course = _courses
          .firstWhere((c) => c.id == courseId);
      final current = course.attendanceMap[week];
      if (current == null) {
        course.attendanceMap[week] =
            true;
      } else if (current == true) {
        course.attendanceMap[week] =
            false;
      } else {
        course.attendanceMap
            .remove(week);
      }
    });
  }

  void _selectSemester(String s) {
    setState(() => _selectedSemester = s);
  }

  void _addSemester(String s) {
    setState(() {
      if (!_semesters.contains(s)) {
        _semesters.add(s);
        _selectedSemester = s;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: _isDark
          ? Brightness.light
          : Brightness.dark,
      systemNavigationBarColor: _isDark
          ? AppColors.darkBg
          : AppColors.lightBg,
      systemNavigationBarIconBrightness: _isDark
          ? Brightness.light
          : Brightness.dark,
    ));

    return MaterialApp(
      title: 'AkademiTakip',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(isDark: _isDark),
      home: HomeScreen(
        isDark: _isDark,
        courses: _courses,
        selectedSemester: _selectedSemester,
        semesters: _semesters,
        onToggleTheme: _toggleTheme,
        onAddCourse: _addCourse,
        onUpdateCourse: _updateCourse,
        onDeleteCourse: _deleteCourse,
        onToggleAttendance: _toggleAttendance,
        onSelectSemester: _selectSemester,
        onAddSemester: _addSemester,
      ),
    );
  }
}
