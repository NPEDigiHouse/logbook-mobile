class StudentWeeklyGrade {
  final String id;
  final String name;
  final String supervisor;
  final List<WeeklyGrade> grades;

  StudentWeeklyGrade(
    this.id,
    this.name,
    this.supervisor, {
    required this.grades,
  });
}

class WeeklyGrade {
  final int week;
  final String date;
  final String place;
  final double? score;

  WeeklyGrade(
    this.week,
    this.date,
    this.place,
    this.score,
  );
}

final List<StudentWeeklyGrade> students = List.generate(
  16,
  (_) => StudentWeeklyGrade(
    'H071191099',
    'Ahdini Zulfiana Abidin',
    'Marlyanti Nur Rahmah',
    grades: [
      WeeklyGrade(
        1,
        'Senin, 27 Mar 2023',
        'RS Unhas',
        80,
      ),
      WeeklyGrade(
        2,
        'Kamis, 30 Mar 2023',
        'RS UMI',
        65,
      ),
      WeeklyGrade(
        3,
        'Ahad, 7 April 2023',
        'Puskesmas',
        null,
      ),
    ],
  ),
);
