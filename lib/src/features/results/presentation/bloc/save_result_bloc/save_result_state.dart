part of 'save_result_bloc.dart';

sealed class SaveResultState extends Equatable {
  const SaveResultState({this.status, this.savedResultStates = const {}});

  final Map<ResultTab, EditResultState> savedResultStates;
  final RequestStatus? status;

  SaveResultState copyWith({
    RequestStatus? status,
    // Map<ResultTab, EditResultState>? savedResultStates,
  });

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

final class ValidateResultState extends SaveResultState {
  const ValidateResultState({super.status, super.savedResultStates});

  @override
  ValidateResultState copyWith({RequestStatus? status}) {
    return ValidateResultState(status: status ?? this.status);
  }
}

final class ResultSavedState extends SaveResultState {
  const ResultSavedState({super.status, super.savedResultStates});

  @override
  ResultSavedState copyWith({
    RequestStatus? status,
    // Map<ResultTab, EditResultState>? savedResultStates,
  }) {
    return ResultSavedState(
      status: status ?? this.status,
      // savedResultStates: savedResultStates ?? this.savedResultStates,
    );
  }
}
