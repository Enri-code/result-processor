import 'package:either_dart/either.dart';
import 'package:unn_grading/src/core/utils/dio.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/security/domain/models/log_data.dart';
import 'package:unn_grading/src/features/security/domain/security_repo.dart';

class SecurityRepoImpl extends SecurityRepo {
  @override
  Future<Either<RequestError, List<ActivityLog>>> getLogs(int page) async {
    try {
      final response = await AuthService.dio.get(
        '/security/action-logs',
        queryParameters: {"page": page, "per_page": 15},
      );

      if (response.statusCode == 200) {
        return Right(List.from(response.data['action_logs']).map((e) {
          return ActivityLog.fromJson(e);
        }).toList());
      }

      return Left(RequestError(response.data['error']));
    } catch (e) {
      return const Left(RequestError.unknown);
    }
  }
}
