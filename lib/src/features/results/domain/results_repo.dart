import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/results/domain/models/result.dart';

abstract class ResultRepository {
  Future<Either<RequestError, bool>> upload(File result, String fileName);
  Future<Either<RequestError, int>> submit(ResultData data);
  Future<Either<RequestError, bool>> updateResultMeta(Result data);
  Future<Either<RequestError, bool>> updateResultScores(
      int id, List<Score> scores);
  Future<Either<RequestError, bool>> delete(int id);
  Future<Either<RequestError, ResultData>> openResult(int id);
  Future<Either<RequestError, List<Result>>> search(SearchResult data);
}

class SearchResult {
  final String? courseCode, regNo, department, session, semester;

  SearchResult({
    this.courseCode,
    this.regNo,
    this.department,
    this.session,
    this.semester,
  });

  Map<String, dynamic> toJson() => {
        "course_code": courseCode,
        "department": department,
        "semester": semester,
        "session": session,
        "registration_number": regNo,
      };
}
