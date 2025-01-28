import 'package:dio_refresh/dio_refresh.dart';
import 'package:either_dart/either.dart';
import 'package:unn_grading/src/core/utils/dio.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/auth/domain/auth_repo.dart';
import 'package:unn_grading/src/features/auth/domain/user.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either<RequestError, TokenStore>> login(
    String username,
    String password,
  ) async {
    try {
      final response = await AuthService.dio.post('/auth/login', data: {
        "username": username,
        "password": password,
      });

      if (response.statusCode == 200) {
        return Right(TokenStore(
          accessToken: response.data['access_token'],
          refreshToken: response.data['refresh_token'],
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
      final response = await AuthService.dio.post(
        '/auth/register',
        data: data.toJson(),
      );

      if (response.statusCode == 201) return const Right(true);

      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }

  @override
  Future<Either<RequestError, bool>> forgotPassword(String email) async {
    try {
      final response = await AuthService.dio.post(
        '/auth/forgot-password',
        data: {"email": email},
      );

      if (response.statusCode == 200) return const Right(true);

      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }

  @override
  Future<Either<RequestError, bool>> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    try {
      final response = await AuthService.dio.post(
        '/auth/reset-password',
        data: {"email": email, "otp": otp, "new_password": newPassword},
      );

      if (response.statusCode == 200) return const Right(true);

      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }

  @override
  Future<Either<RequestError, User>> getUser() async {
    try {
      final response = await AuthService.dio.get('/auth/me');

      if (response.statusCode == 200) {
        return Right(User.fromJson(response.data));
      }

      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }
}
