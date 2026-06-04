// ─────────────────────────────────────────────
// course.dart  →  Uygulamanın tek veri modeli
// ─────────────────────────────────────────────
//
// Bu dosyada ne var?
//   • WeekDay   : Haftanın günlerini temsil eden enum
//   • Course    : Bir dersin tüm bilgilerini tutan sınıf
//   • AbsenceStatus : Devamsızlık durumunu anlatan enum
//
// Enum nedir?
//   Sabit seçenekler listesi. Örneğin WeekDay.monday
//   "pazartesi" anlamına gelir; sayı veya String yerine
//   anlamlı isimler kullanmamızı sağlar.

// ── Haftanın günleri ──────────────────────────
enum WeekDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

// Enum değerlerine Türkçe isim eklemek için extension kullanıyoruz.
// Extension: Var olan bir tipe yeni özellik/metot ekler.
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

// ── Devamsızlık durumu ────────────────────────
enum AbsenceStatus {
  safe,
  warning,
  danger,
  critical
}

// ── Ders sınıfı ───────────────────────────────
class Course {
  // final: Bir kez atanır, sonradan değiştirilemez.
  final String
      id; // Eşsiz kimlik (uuid paketi üretir)

  // Bu alanlar değiştirilebilir (final değil):
  String name; // Ders adı
  int totalWeeks; // Kaç haftalık ders var?
  int maxAbsences; // En fazla kaç kere devamsız kalınabilir?
  int colorIndex; // Renk paletteki indeks (0-9)
  WeekDay courseDay; // Dersin günü
  String
      semester; // Hangi dönem? (ör. "Bahar 2025")

  // attendanceMap: Her haftanın durumunu tutar.
  //   Key   → hafta numarası (1, 2, 3 … totalWeeks)
  //   Value → true = katıldım, false = gitmedim
  //   Eğer key yoksa → henüz işaretlenmemiş
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
  //    ↑ attendanceMap verilmezse boş Map başlatılır.

  // ── Hesaplanan özellikler (getter) ──────────
  // Getter: Parametre almadan bir değer hesaplayan özellik.

  // Toplam devamsız olunan hafta sayısı
  int get totalAbsences => attendanceMap.values
      .where((attended) => !attended)
      .length;

  // Toplam katılınan hafta sayısı
  int get totalAttended => attendanceMap.values
      .where((attended) => attended)
      .length;

  // Kalan devamsızlık hakkı
  int get remainingAbsences =>
      maxAbsences - totalAbsences;

  // Kaç hafta işaretlenmiş?
  int get markedWeeks => attendanceMap.length;

  // Katılım yüzdesi (0.0 - 1.0 arası)
  double get attendanceRate => markedWeeks == 0
      ? 1.0
      : totalAttended / markedWeeks;

  // Devamsızlık durumu
  AbsenceStatus get absenceStatus {
    if (remainingAbsences <= 0)
      return AbsenceStatus.critical;
    if (remainingAbsences == 1)
      return AbsenceStatus.danger;
    if (remainingAbsences <= maxAbsences * 0.3)
      return AbsenceStatus.warning;
    return AbsenceStatus.safe;
  }

  // ── JSON dönüşümleri (SharedPreferences için) ──
  // SharedPreferences sadece String saklayabilir.
  // Bu yüzden Course nesnesini JSON String'e çevirip saklıyoruz.

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'totalWeeks': totalWeeks,
        'maxAbsences': maxAbsences,
        'colorIndex': colorIndex,
        'courseDay':
            courseDay.index, // enum → int
        'semester': semester,
        // Map<int,bool> → Map<String,bool>  (JSON key'leri String olmak zorunda)
        'attendanceMap': attendanceMap.map(
            (k, v) => MapEntry(k.toString(), v)),
      };

  // JSON'dan Course nesnesi üret (fabrika constructor)
  factory Course.fromJson(
          Map<String, dynamic> json) =>
      Course(
        id: json['id'],
        name: json['name'],
        totalWeeks: json['totalWeeks'],
        maxAbsences: json['maxAbsences'],
        colorIndex: json['colorIndex'] ?? 0,
        courseDay: WeekDay.values[
            json['courseDay'] ?? 0], // int → enum
        semester:
            json['semester'] ?? 'Bahar 2025',
        attendanceMap: (json['attendanceMap']
                    as Map<String, dynamic>? ??
                {})
            .map((k, v) => MapEntry(
                int.parse(k), v as bool)),
      );
}
