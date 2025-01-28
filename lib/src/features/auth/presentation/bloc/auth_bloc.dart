// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dio_refresh/dio_refresh.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/core/utils/response_state.dart';
import 'package:unn_grading/src/features/auth/domain/auth_repo.dart';
import 'package:unn_grading/src/features/auth/domain/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;

  AuthBloc(this.repo) : super(const AuthLoggedOut()) {
    on<GetLoginState>((event, emit) {
      final _state = state;
      emit(AuthInitial());
      emit(_state);
    });
    on<AuthRegisterIn>((event, emit) async {
      emit(state.copyWith(status: const RequestLoading()));

      final data = await repo.register(event.data);

      data.fold((left) {
        emit(state.copyWith(status: left));
      }, (right) {
        emit(state.copyWith(
          status: const RequestSuccess('Successfully created account'),
        ));
        add(const SwitchLoginType(0));
      });
    });
    on<AuthLogIn>((event, emit) async {
      emit(state.copyWith(status: const RequestLoading()));
      final data = await repo.login(event.username, event.password);

      await data.fold(
        (left) {
          emit(state.copyWith(status: left));
        },
        (right) async {
          TokenManager.instance.setToken(right);
          // = right;
          final data = await repo.getUser();
          await data.fold(
            (left) {
              emit(state.copyWith(status: left));
            },
            (right) async {
              emit(AuthLoggedIn(user: right));
            },
          );
        },
      );
    });
    on<AuthLogOut>((event, emit) {
      TokenManager.instance.setToken(
        TokenStore(accessToken: null, refreshToken: null),
      );
      emit(const AuthLoggedOut());
    });
    on<AuthSendPasswprdReset>((event, emit) async {
      emit(state.copyWith(status: const RequestLoading()));
      final data = await repo.forgotPassword(event.email);

      data.fold((left) {
        emit(state.copyWith(status: left));
      }, (right) {
        emit(AuthResetPasswordState(event.email));
      });
    });
    on<AuthSetNewPasswprdReset>((event, emit) async {
      emit(state.copyWith(status: const RequestLoading()));
      final data = await repo.resetPassword(
        (state as AuthResetPasswordState).email,
        event.otp,
        event.newPassword,
      );

      data.fold((left) {
        emit(state.copyWith(status: left));
      }, (right) {
        emit(const AuthPasswordResetState());
      });
    });
    on<SwitchLoginType>((event, emit) {
      emit((state as AuthLoggedOut).copyWith(authPage: event.index));
    });
  }
}
