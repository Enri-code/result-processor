import 'package:dio_refresh/dio_refresh.dart';
import 'package:either_dart/either.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/auth/domain/user.dart';

class RegisterData {
  final String username, department, email, password, role;

  RegisterData({
    required this.username,
    required this.department,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "username": username,
        "password": password,
        "department": department,
        "role": role,
      };
}

abstract class AuthRepository {
  Future<Either<RequestError, bool>> register(RegisterData data);
  Future<Either<RequestError, TokenStore>> login(
      String username, String password);
  Future<Either<RequestError, User>> getUser();
  Future<Either<RequestError, bool>> forgotPassword(String email);
  Future<Either<RequestError, bool>> resetPassword(
    String email,
    String otp,
    String newPassword,
  );
}
