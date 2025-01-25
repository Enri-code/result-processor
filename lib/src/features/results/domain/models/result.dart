import 'package:equatable/equatable.dart';

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

  const ResultData({
    super.id,
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

  factory ResultData.fromJson(Map<String, dynamic> json) {
    final results = List.from(json['results']).map((e) {
      return Score(
        fullname: e['full_name'],
        regNo: e['registration_number'],
        ca: e['ca_score'],
        exam: e['exam_score'],
        total: e['total_score'],
        grade: e['grade'],
      );
    }).toList();

    return ResultData(
      courseCode: json['course_code'],
      courseTitle: json['course_title'],
      semester: json['semester_name'],
      session: json['session'],
      department: json['exam_department'],
      courseUnit: json['course_unit'],
      results: results,
    );
  }
}

class Result extends Equatable {
  final String? id;
  final String courseCode, courseTitle, semester, session;
  final String? department;
  final int? courseUnit;
  // final int? level;

  const Result({
    this.id,
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
        if (id != null) "id": id,
        "course_code": courseCode,
        "course_title": courseTitle,
        "course_unit": courseUnit,
        // "level": level,
        // "faculty": faculty,
        "exam_department": department,
        "semester_name": semester,
        "session": session,
      };

  @override
  List<Object?> get props => [id];
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
