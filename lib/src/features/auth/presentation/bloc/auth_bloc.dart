// ignore_for_file: no_leading_underscores_for_local_identifiers

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
        emit(state.copyWith(status: const RequestSuccess()));
        add(const SwitchLoginType(1));
      });
    });
    on<AuthLogIn>((event, emit) async {
      emit(state.copyWith(status: const RequestLoading()));
      final data = await repo.login(event.username, event.password);

      data.fold((left) {
        emit(state.copyWith(status: left));
      }, (right) {
        emit(AuthLoggedIn(user: right));
      });
    });
    on<AuthLogOut>((event, emit) {
      emit(const AuthLoggedOut());
    });
    on<SwitchLoginType>((event, emit) {
      final _state = state as AuthLoggedOut;
      emit(_state.copyWith(authPage: event.index));
    });
  }
}
