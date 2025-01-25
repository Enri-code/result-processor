import 'package:either_dart/either.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/auth/domain/user.dart';

class RegisterData {
  final String username, email, password, role;

  RegisterData({
    required this.username,
    this.email = '',
    required this.password,
    required this.role,
  });
}

abstract class AuthRepository {
  Future<Either<RequestError, bool>> register(RegisterData data);
  Future<Either<RequestError, User>> login(String username, String password);
  Future<Either<RequestError, bool>> forgotPassword(String email);
  Future<Either<RequestError, bool>> resetPassword(
    String email,
    String otp,
    String newPassword,
  );
}
