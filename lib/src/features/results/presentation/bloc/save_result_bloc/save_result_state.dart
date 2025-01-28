part of 'save_result_bloc.dart';

sealed class SaveResultState extends Equatable {
  const SaveResultState({this.status, this.savedResultStates = const {}});

  final Map<ResultTab, EditResultState> savedResultStates;
  final RequestStatus? status;

  SaveResultState copyWith({RequestStatus? status});

  @override
  List<Object?> get props => [status, savedResultStates];
}

final class SaveResultInitial extends SaveResultState {
  const SaveResultInitial({super.status});

  @override
  SaveResultInitial copyWith({RequestStatus? status}) {
    return SaveResultInitial(status: status ?? this.status);
  }
}

final class ResultValidateState extends SaveResultState {
  const ResultValidateState({super.status, super.savedResultStates});

  @override
  ResultValidateState copyWith({RequestStatus? status}) {
    return ResultValidateState(
      status: status ?? this.status,
      savedResultStates: savedResultStates,
    );
  }
}

final class ResultSaveState extends SaveResultState {
  final ResultTab tab;
  const ResultSaveState({
    super.status,
    super.savedResultStates,
    required this.tab,
  });

  @override
  ResultSaveState copyWith({
    RequestStatus? status,
    // Map<ResultTab, EditResultState>? savedResultStates,
  }) {
    return ResultSaveState(
      status: status ?? this.status,
      savedResultStates: savedResultStates,
      tab: tab,
      // savedResultStates: savedResultStates ?? this.savedResultStates,
    );
  }
}

final class ResultDeleteState extends SaveResultState {
  final ResultTab tab;
  const ResultDeleteState({
    super.status,
    super.savedResultStates,
    required this.tab,
  });

  @override
  ResultDeleteState copyWith({RequestStatus? status}) {
    return ResultDeleteState(
      status: status ?? this.status,
      savedResultStates: savedResultStates,
      tab: tab,
    );
  }
}
