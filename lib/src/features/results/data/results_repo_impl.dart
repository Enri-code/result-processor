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
  Future<Either<RequestError, List<Result>>> searchByDept(
      SearchResultByDept data) async {
    try {
      final response = await dioService.post(
        '/results/by-department',
        data: data.toJson(),
      );

      if (response.statusCode == 200) {
        return Right(List.from(response.data['results']).map((e) {
          return ResultData.fromJson(e);
        }).toList());
      }

      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }

  @override
  Future<Either<RequestError, List<Result>>> searchByCourse(
    SearchResultByCourse data,
  ) async {
    // return Future.delayed(
    //   const Duration(seconds: 3),
    //   () => Right(List.generate(9, (index) {
    //     return const Result(
    //       id: '',
    //       courseCode: 'Cos 444',
    //       courseTitle: 'Cos Title',
    //       semester: 'First',
    //       session: '2020-2021',
    //       department: 'Comp Sci',
    //       courseUnit: 3,
    //     );
    //   })),
    // );
    try {
      final response = await dioService.get(
        '/results/by-course',
        data: data.toJson(),
      );

      if (response.statusCode == 200) {
        return Right(List.from(response.data['results']).map((e) {
          return ResultData.fromJson(e);
        }).toList());
      }

      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }

  @override
  Future<Either<RequestError, List<Result>>> searchByRegNo(
      SearchResultByRegistration data) async {
    try {
      final response = await dioService.get(
        '/results/by-registration',
        data: data.toJson(),
      );

      if (response.statusCode == 200) {
        return Right(List.from(response.data['results']).map((e) {
          return ResultData.fromJson(e);
        }).toList());
      }
      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }

  @override
  Future<Either<RequestError, ResultData>> openResult(String id) async {
    try {
      // return Future.delayed(
      //   const Duration(seconds: 3),
      //   () => Right(ResultData(
      //     id: '',
      //     courseUnit: 3,
      //     courseCode: 'Cos 444',
      //     courseTitle: 'Cos Title',
      //     semester: 'First',
      //     session: '2020-2021',
      //     department: 'Comp Sci',
      //     results: List.generate(40, (index) {
      //       return Score(
      //           fullname: 'Eric Onyeulo',
      //           regNo: '2019/247680',
      //           grade: 'A',
      //           ca: 28,
      //           exam: 67,
      //           total: 95);
      //     }),
      //   )),
      // );
      final response = await dioService.get('/results/$id}');

      if (response.statusCode == 200) {
        return Right(ResultData.fromJson(response.data));
      }

      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }
}
