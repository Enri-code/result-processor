import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:mime/mime.dart';
import 'package:unn_grading/src/core/utils/dio.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/results/domain/models/result.dart';
import 'package:unn_grading/src/features/results/domain/results_repo.dart';

class ResultRepositoryImpl extends ResultRepository {
  @override
  Future<Either<RequestError, bool>> delete(int id) async {
    try {
      final response = await AuthService.dio.delete('/results/delete/$id');

      if (response.statusCode == 200) return const Right(true);

      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }

  @override
  Future<Either<RequestError, int>> submit(ResultData data) async {
    try {
      final jsonData = data.toJson()
        ..addAll({
          "level": "0",
          "lecturers": [1],
          "faculty": "Faculty",
        });

      final response = await AuthService.dio.post(
        '/results/submit',
        data: jsonData,
      );

      if (response.statusCode == 200) return Right(response.data['result_id']);

      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }

  @override
  Future<Either<RequestError, bool>> updateResultMeta(Result data) async {
    try {
      final response = await AuthService.dio.patch(
        '/results/${data.id}/update-meta',
        data: data.toJson(),
      );

      if (response.statusCode == 200) return const Right(true);

      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }

  @override
  Future<Either<RequestError, bool>> updateResultScores(
      int id, List<Score> scores) async {
    try {
      final response = await AuthService.dio.patch(
        '/results/$id/update-score',
        data: scores.map((e) => e.toJson()).toList(),
      );

      if (response.statusCode == 200) return const Right(true);

      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }

  @override
  Future<Either<RequestError, bool>> upload(
      File result, String fileName) async {
    try {
      final response = await AuthService.dio.post(
        '/results/upload',
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'multipart/form-data'},
        ),
        data: FormData.fromMap({
          'type': lookupMimeType(result.path),
          'file': MultipartFile.fromFileSync(result.path, filename: fileName),
        }),
      );

      if (response.statusCode == 200) return const Right(true);

      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }

  @override
  Future<Either<RequestError, List<Result>>> search(SearchResult data) async {
    try {
      final response = await AuthService.dio.get(
        '/results/search',
        data: data.toJson(),
      );

      if (response.statusCode == 200) {
        return Right(List.from(response.data['search_results']).map((e) {
          return ResultData.fromJson(e);
        }).toList());
      }

      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }

  @override
  Future<Either<RequestError, ResultData>> openResult(int id) async {
    try {
      final response = await AuthService.dio.get('/results/$id');

      if (response.statusCode == 200) {
        return Right(ResultData.fromJson(response.data));
      }

      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }
}
