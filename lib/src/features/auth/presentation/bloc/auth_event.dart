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

class AuthSendPasswprdReset extends AuthEvent {
  final String email;

  const AuthSendPasswprdReset({required this.email});
}

class AuthSetNewPasswprdReset extends AuthEvent {
  final String otp, newPassword;

  const AuthSetNewPasswprdReset({required this.otp, required this.newPassword});
}

class AuthLogOut extends AuthEvent {}
