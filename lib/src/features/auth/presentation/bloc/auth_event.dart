part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class GetLoginState extends AuthEvent {}

class SwitchLoginType extends AuthEvent {
  final int? index;

  const SwitchLoginType([this.index]);
}

class AuthRegisterIn extends AuthEvent {
  final RegisterData data;

  const AuthRegisterIn({required this.data});
}

class AuthLogIn extends AuthEvent {
  final String username, password;

  const AuthLogIn({required this.username, required this.password});
}

class AuthLogOut extends AuthEvent {}
