import 'package:either_dart/either.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/auth/domain/user.dart';

class RegisterData {
  final String username, password, role;

  RegisterData({
    required this.username,
    required this.password,
    required this.role,
  });
}

abstract class AuthRepository {
  Future<Either<RequestError, User>> login(String username, String password);
  Future<Either<RequestError, bool>> register(RegisterData data);
}
