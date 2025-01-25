import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/results/domain/models/result.dart';

abstract class ResultRepository {
  Future<Either<RequestError, bool>> upload(File result, String fileName);
  Future<Either<RequestError, bool>> update(UpdateResultData data);
  Future<Either<RequestError, bool>> submit(ResultData data);
  Future<Either<RequestError, bool>> delete(String id);
  Future<Either<RequestError, ResultData>> openResult(String id);
  Future<Either<RequestError, List<Result>>> searchByCourse(
      SearchResultByCourse data);
  Future<Either<RequestError, List<Result>>> searchByDept(
      SearchResultByDept data);
  Future<Either<RequestError, List<Result>>> searchByRegNo(
    SearchResultByRegistration data,
  );
}

class SearchResult {}

class SearchResultByDept extends SearchResult {
  final String department, session, semester;

  SearchResultByDept({
    required this.department,
    required this.session,
    required this.semester,
  });

  Map<String, dynamic> toJson() => {
        "department": department,
        "session": session,
        "semester": semester,
      };
}

class SearchResultByCourse extends SearchResult {
  final String courseCode;
  final String? session, semester;

  SearchResultByCourse({required this.courseCode, this.session, this.semester});

  Map<String, dynamic> toJson() => {
        "course_code": courseCode,
        "semester_name": semester,
        "session": session,
      };
}

class SearchResultByRegistration extends SearchResult {
  final String regNo, session;

  SearchResultByRegistration({required this.regNo, required this.session});

  Map<String, dynamic> toJson() => {
        "registration_number": regNo,
        "session": session,
      };
}
