enum WeekDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

extension WeekDayExtension on WeekDay {
  String get turkishName {
    switch (this) {
      case WeekDay.monday:
        return 'Pazartesi';
      case WeekDay.tuesday:
        return 'Salı';
      case WeekDay.wednesday:
        return 'Çarşamba';
      case WeekDay.thursday:
        return 'Perşembe';
      case WeekDay.friday:
        return 'Cuma';
      case WeekDay.saturday:
        return 'Cumartesi';
      case WeekDay.sunday:
        return 'Pazar';
    }
  }

  String get shortName {
    switch (this) {
      case WeekDay.monday:
        return 'Pzt';
      case WeekDay.tuesday:
        return 'Sal';
      case WeekDay.wednesday:
        return 'Çar';
      case WeekDay.thursday:
        return 'Per';
      case WeekDay.friday:
        return 'Cum';
      case WeekDay.saturday:
        return 'Cmt';
      case WeekDay.sunday:
        return 'Paz';
    }
  }
}

enum AbsenceStatus {
  safe,
  warning,
  danger,
  critical
}

class Course {
  final String
      id;
  String name; 
  int totalWeeks;
  int maxAbsences; 
  int colorIndex;
  WeekDay courseDay;
  String
      semester;

  Map<int, bool> attendanceMap;

  Course({
    required this.id,
    required this.name,
    required this.totalWeeks,
    required this.maxAbsences,
    required this.colorIndex,
    required this.courseDay,
    required this.semester,
    Map<int, bool>? attendanceMap,
  }) : attendanceMap = attendanceMap ?? {};

  int get totalAbsences => attendanceMap.values
      .where((attended) => !attended)
      .length;


  int get totalAttended => attendanceMap.values
      .where((attended) => attended)
      .length;


  int get remainingAbsences =>
      maxAbsences - totalAbsences;


  int get markedWeeks => attendanceMap.length;


  double get attendanceRate => markedWeeks == 0
      ? 1.0
      : totalAttended / markedWeeks;


  AbsenceStatus get absenceStatus {
    if (remainingAbsences <= 0)
      return AbsenceStatus.critical;
    if (remainingAbsences == 1)
      return AbsenceStatus.danger;
    if (remainingAbsences <= maxAbsences * 0.3)
      return AbsenceStatus.warning;
    return AbsenceStatus.safe;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'totalWeeks': totalWeeks,
        'maxAbsences': maxAbsences,
        'colorIndex': colorIndex,
        'courseDay':
            courseDay.index,
        'semester': semester,
        'attendanceMap': attendanceMap.map(
            (k, v) => MapEntry(k.toString(), v)),
      };

  factory Course.fromJson(
          Map<String, dynamic> json) =>
      Course(
        id: json['id'],
        name: json['name'],
        totalWeeks: json['totalWeeks'],
        maxAbsences: json['maxAbsences'],
        colorIndex: json['colorIndex'] ?? 0,
        courseDay: WeekDay.values[
            json['courseDay'] ?? 0],
        semester:
            json['semester'] ?? 'Bahar 2025',
        attendanceMap: (json['attendanceMap']
                    as Map<String, dynamic>? ??
                {})
            .map((k, v) => MapEntry(
                int.parse(k), v as bool)),
      );
}
