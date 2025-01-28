import 'package:either_dart/either.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/security/domain/models/log_data.dart';

abstract class SecurityRepo {
  Future<Either<RequestError, List<ActivityLog>>> getLogs(int page);
}
