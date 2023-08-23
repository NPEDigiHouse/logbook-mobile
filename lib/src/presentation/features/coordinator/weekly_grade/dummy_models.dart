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
  final int weekNumber;
  final String date;
  final String location;
  final int grade;

  WeeklyGrade(
    this.weekNumber,
    this.date,
    this.location,
    this.grade,
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
    ],
  ),
);
