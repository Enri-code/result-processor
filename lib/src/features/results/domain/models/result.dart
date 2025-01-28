import 'package:equatable/equatable.dart';

class ResultData extends Result {
  final List<Score> scores;

  const ResultData({
    super.id,
    required super.courseCode,
    required super.courseTitle,
    required super.semester,
    required super.session,
    required super.department,
    required super.courseUnit,
    required this.scores,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "results": scores.map((e) => e.toJson()).toList(),
    };
  }

  factory ResultData.fromJson(Map<String, dynamic> json) {
    final results = List.from(json['scores'] ?? []).map((e) {
      return Score(
        studentName: e['student_name'] ?? '',
        regNo: e['registration_number'] ?? '',
        ca: int.tryParse(e['ca_score']?.toString() ?? '') ?? 0,
        exam: int.tryParse(e['exam_score']?.toString() ?? '') ?? 0,
        total: int.tryParse(e['total_score']?.toString() ?? '') ?? 0,
        grade: e['grade'] ?? '',
      );
    }).toList();

    return ResultData(
      id: json['id'] ?? '',
      courseCode: json['course_code'] ?? '',
      courseTitle: json['course_title'] ?? '',
      semester: json['semester'] ?? '',
      session: json['session'] ?? '',
      department: json['department'] ?? '',
      courseUnit: json['course_unit'],
      scores: results,
    );
  }
}

class Result extends Equatable {
  final int? id;
  final String courseCode, courseTitle, semester, session, department;
  final int? courseUnit;

  const Result({
    this.id,
    required this.courseCode,
    required this.courseTitle,
    required this.semester,
    required this.session,
    required this.department,
    required this.courseUnit,
  });

  Map<String, dynamic> toJson() => {
        if (id != null) "id": id,
        "course_code": courseCode,
        "course_title": courseTitle,
        "course_unit": courseUnit,
        "department": department,
        "semester_name": semester,
        "session": session,
      };

  @override
  List<Object?> get props => [id];
}

class Score {
  final String studentName, regNo, grade;
  final int ca, exam, total;

  Score({
    required this.studentName,
    required this.regNo,
    required this.grade,
    required this.ca,
    required this.exam,
    required this.total,
  });

//required fields: registration_number, ca_score, exam_score, total_score, grade"
  Map<String, dynamic> toJson() => {
        "student_name": studentName,
        "registration_number": regNo,
        "ca_score": ca,
        "exam_score": exam,
        "total_score": total,
        "grade": grade,
      };
}
