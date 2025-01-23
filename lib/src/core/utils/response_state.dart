import 'package:equatable/equatable.dart';

abstract class RequestStatus extends Equatable {
  const RequestStatus();
}

class RequestError extends RequestStatus {
  final String error;
  const RequestError(this.error);

  static const unknown = RequestError('An unknown error occured.');

  @override
  List<Object?> get props => [error];
}

class RequestSuccess extends RequestStatus {
  const RequestSuccess();

  @override
  List<Object?> get props => [];
}

class RequestLoading extends RequestStatus {
  const RequestLoading();

  @override
  List<Object?> get props => [];
}
