import 'package:equatable/equatable.dart';

abstract class RequestStatus extends Equatable {
  final String message;
  const RequestStatus([this.message = '']);

  @override
  List<Object?> get props => [message];
}

class RequestError extends RequestStatus {
  const RequestError([super.message]);

  static const unknown = RequestError('An unknown error occured.');
}

class RequestSuccess extends RequestStatus {
  const RequestSuccess([super.message]);
}

class RequestLoading extends RequestStatus {
  const RequestLoading([super.message]);
}
