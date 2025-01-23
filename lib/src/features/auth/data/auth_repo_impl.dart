import 'package:either_dart/either.dart';
import 'package:unn_grading/src/core/utils/dio.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/auth/domain/auth_repo.dart';
import 'package:unn_grading/src/features/auth/domain/user.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either<RequestError, User>> login(
      String username, String password) async {
    try {
      final response = await dioService.post('/auth/login', data: {
        "username": username,
        "password": password,
      });

      if (response.statusCode == 200) {
        return Right(User(
          username: username,
          accessToken: response.data['access_token'],
          role: response.data['role'],
        ));
      }

      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }

  @override
  Future<Either<RequestError, bool>> register(RegisterData data) async {
    try {
      final response = await dioService.post('/auth/register', data: {
        "username": data.username,
        "password": data.password,
        "role": data.role,
      });

      if (response.statusCode == 201) return const Right(true);

      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }
}
