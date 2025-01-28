part of 'security_bloc.dart';

sealed class SecurityEvent extends Equatable {
  const SecurityEvent();

  @override
  List<Object> get props => [];
}

class GetActivityLogsEvent extends SecurityEvent {
  const GetActivityLogsEvent();
}
