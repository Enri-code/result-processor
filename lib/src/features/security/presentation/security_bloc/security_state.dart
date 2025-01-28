part of 'security_bloc.dart';

sealed class SecurityState extends Equatable {
  const SecurityState([this.logs = const [], this.page = 1]);
  final int page;
  final List<ActivityLog> logs;

  @override
  List<Object> get props => [page, logs];
}

final class SecurityInitial extends SecurityState {}

final class SecurityLogsLoadingState extends SecurityState {
  const SecurityLogsLoadingState(super.logs, super.page);
}

final class SecurityLogsErrorState extends SecurityState {
  final RequestError left;
  const SecurityLogsErrorState(this.left, super.logs, super.page);
}

final class SecurityLogsLoadedState extends SecurityState {
  const SecurityLogsLoadedState(super.logs, super.page);
}
