class UpdateResultData {
  final String courseCode, regNo, session, semester;

  UpdateResultData({
    required this.courseCode,
    required this.regNo,
    required this.session,
    required this.semester,
  });

  Map<String, dynamic> toJson() => {
        'course_code': courseCode,
        'registration_number': regNo,
        'session': session,
        'semester': semester,
      };
}

class ResultData extends Result {
  final List<Score> results;

  ResultData({
    required super.courseCode,
    required super.courseTitle,
    required super.semester,
    required super.session,
    required super.department,
    required super.courseUnit,
    required this.results,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "results": results.map((e) => e.toJson()).toList(),
    };
  }
}

class Result {
  final String courseCode, courseTitle, semester, session;
  final String? department;
  final int? courseUnit;
  // final int? level;

  Result({
    required this.courseCode,
    required this.courseTitle,
    required this.semester,
    required this.session,
    // required this.faculty,
    required this.department,
    required this.courseUnit,
    // required this.level,
  });

  Map<String, dynamic> toJson() => {
        "course_code": courseCode,
        "course_title": courseTitle,
        "course_unit": courseUnit,
        // "level": level,
        // "faculty": faculty,
        "exam_department": department,
        "semester_name": semester,
        "session": session,
      };
}

class Score {
  final String fullname, regNo, grade;
  final int ca, exam, total;

  Score({
    required this.fullname,
    required this.regNo,
    required this.grade,
    required this.ca,
    required this.exam,
    required this.total,
  });

  Map<String, dynamic> toJson() => {
        "full_name": fullname,
        "registration_number": regNo,
        "ca_score": ca,
        "exam_score": exam,
        "total_score": total,
        "grade": grade,
      };
}
