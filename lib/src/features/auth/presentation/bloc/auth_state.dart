part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState({this.status});

  final RequestStatus? status;

  AuthState copyWith({RequestStatus? status});

  @override
  List<Object?> get props => [status];
}

final class AuthInitial extends AuthState {
  @override
  AuthState copyWith({RequestStatus? status}) {
    throw UnimplementedError();
  }
}

final class AuthLoggedIn extends AuthState {
  final User user;

  const AuthLoggedIn({super.status, required this.user});

  @override
  AuthState copyWith({RequestStatus? status}) {
    return AuthLoggedIn(status: status ?? this.status, user: user);
  }
}

final class AuthLoggedOut extends AuthState {
  final int authPage;

  const AuthLoggedOut({super.status, this.authPage = 0});

  @override
  AuthLoggedOut copyWith({RequestStatus? status, int? authPage}) {
    return AuthLoggedOut(
      status: status ?? this.status,
      authPage: authPage ?? this.authPage,
    );
  }

  @override
  List<Object?> get props => [status, authPage];
}
