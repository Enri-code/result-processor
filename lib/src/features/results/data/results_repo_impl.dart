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
  Future<Either<RequestError, bool>> delete(String id) async {
    try {
      final response = await dioService.delete('/results/delete/$id');

      if (response.statusCode == 200) return const Right(true);

      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }

  @override
  Future<Either<RequestError, bool>> submit(ResultData data) async {
    try {
      final response = await dioService.post(
        '/results/submit',
        data: data.toJson(),
      );

      if (response.statusCode == 200) return const Right(true);

      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }

  @override
  Future<Either<RequestError, bool>> update(UpdateResultData data) async {
    try {
      final response = await dioService.put(
        '/results/update',
        data: data.toJson(),
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
      final response = await dioService.post(
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
  Future<Either<RequestError, bool>> searchByDept(
      SearchResultByDept data) async {
    try {
      final response = await dioService.post(
        '/results/by-department',
        data: data.toJson(),
      );

      if (response.statusCode == 200) return const Right(true);

      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }

  @override
  Future<Either<RequestError, bool>> searchByCourse(
    SearchResultByCourse data,
  ) async {
    try {
      final response = await dioService.get(
        '/results/by-course',
        data: data.toJson(),
      );

      if (response.statusCode == 200) return const Right(true);

      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }

  @override
  Future<Either<RequestError, bool>> searchByRegNo(
      SearchResultByRegistration data) async {
    try {
      final response = await dioService.get(
        '/results/by-registration',
        data: data.toJson(),
      );

      if (response.statusCode == 200) return const Right(true);

      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }
}
