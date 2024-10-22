class Result {
  final int id;
  final String courseTitle, courseCode, units, session, semester, lecturer;

  Result({
    required this.id,
    this.courseTitle = '',
    this.courseCode = '',
    this.units = '',
    this.lecturer = '',
    this.session = '',
    this.semester = '',
  });
}
