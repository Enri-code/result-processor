import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/security/domain/models/log_data.dart';
import 'package:unn_grading/src/features/security/domain/security_repo.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' as c;

part 'security_event.dart';
part 'security_state.dart';

class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  final SecurityRepo repo;
  SecurityBloc(this.repo) : super(SecurityInitial()) {
    on<GetActivityLogsEvent>((event, emit) async {
      emit(SecurityLogsLoadingState(state.logs, state.page));
      final response = await repo.getLogs(state.page);
      response.fold(
        (left) {
          emit(SecurityLogsErrorState(left, state.logs, state.page));
        },
        (right) {
          emit(SecurityLogsLoadedState(
            [...state.logs, ...right],
            right.isEmpty ? -1 : state.page + 1,
          ));
        },
      );
    }, transformer: c.droppable());
  }
}
