import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unn_grading/src/core/constants/theme.dart';
import 'package:unn_grading/src/features/auth/data/auth_repo_impl.dart';
import 'package:unn_grading/src/features/auth/domain/auth_repo.dart';
import 'package:unn_grading/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:unn_grading/src/features/results/data/results_repo_impl.dart';
import 'package:unn_grading/src/features/results/domain/results_repo.dart';
import 'package:unn_grading/src/features/results/presentation/pages/pluto_grid_grading_page.dart';
import 'package:unn_grading/src/features/results/presentation/search/open_result_bloc/open_result_bloc.dart';
import 'package:unn_grading/src/features/results/presentation/upload/upload_result_bloc/upload_result_bloc.dart';
import 'package:unn_grading/src/features/security/data/security_repo_impl.dart';
import 'package:unn_grading/src/features/security/domain/security_repo.dart';
import 'package:unn_grading/src/features/security/presentation/security_bloc/security_bloc.dart';
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
        RepositoryProvider<SecurityRepo>(
          create: (context) => SecurityRepoImpl(),
        ),
        RepositoryProvider<ResultRepository>(
          create: (context) => ResultRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc(context.read())),
          BlocProvider(create: (context) => UploadResultBloc(context.read())),
          BlocProvider(create: (context) => OpenResultBloc(context.read())),
          BlocProvider(create: (context) => SecurityBloc(context.read())),
        ],
        child: MaterialApp(
          restorationScopeId: 'app',
          title: 'Result Processor',
          debugShowCheckedModeBanner: false,
          theme: themeData,
          home: const PlutoGridGradingPage(),
        ),
      ),
    );
  }
}
