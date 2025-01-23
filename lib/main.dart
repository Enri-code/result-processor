import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/core/constants/app_color.dart';
import 'package:unn_grading/src/core/utils/dio.dart';
import 'package:unn_grading/src/features/auth/data/auth_repo_impl.dart';
import 'package:unn_grading/src/features/auth/domain/auth_repo.dart';
import 'package:unn_grading/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:unn_grading/src/features/results/data/results_repo_impl.dart';
import 'package:unn_grading/src/features/results/domain/results_repo.dart';
import 'package:unn_grading/src/features/results/presentation/pages/pluto_grid_grading_page.dart';
import 'package:unn_grading/src/features/results/presentation/search/search_result_bloc/search_result_bloc.dart';
import 'package:unn_grading/src/features/results/presentation/upload/upload_result_bloc/upload_result_bloc.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowMinSize(const Size(360, 420));
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(),
        ),
        RepositoryProvider<ResultRepository>(
          create: (context) => ResultRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc(context.read())),
          BlocProvider(create: (context) => UploadResultBloc(context.read())),
          BlocProvider(create: (context) => SearchResultBloc(context.read())),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<AuthBloc, AuthState>(
              listenWhen: (p, c) => c is AuthLoggedIn,
              listener: (context, state) {
                token = (state as AuthLoggedIn).user.accessToken;
              },
            ),
            BlocListener<AuthBloc, AuthState>(
              listenWhen: (p, c) => c is AuthLoggedOut,
              listener: (context, state) => token = null,
            ),
          ],
          child: MaterialApp(
            restorationScopeId: 'app',
            title: 'Result Processor',
            debugShowCheckedModeBanner: false,
            home: const PlutoGridGradingPage(),
            theme: ThemeData(
              useMaterial3: true,
              inputDecorationTheme: InputDecorationTheme(
                isDense: true,
                hintStyle: const TextStyle(
                  color: Colors.black45,
                  fontSize: 13,
                  height: 1,
                ),
                errorStyle: TextStyle(
                  color: Colors.red[900],
                  fontSize: 9,
                  height: 1,
                ),
                prefixIconColor: Colors.grey,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(.6),
                    width: 1.5,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
              ),
              colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primary),
            ),
          ),
        ),
      ),
    );
  }
}
