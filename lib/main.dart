import 'dart:io';

import 'package:flutter/material.dart';
import 'package:unn_grading/src/core/constants/app_color.dart';
import 'package:unn_grading/src/core/utils/router.dart';
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
    // return ScreenUtilInit(
    //   designSize: const Size(1280, 720),
    //   minTextAdapt: true,
    //   splitScreenMode: true,
    //   builder: (_, context) {
    return MaterialApp.router(
      restorationScopeId: 'app',
      title: 'Result Processor',
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.primary,
        ),
      ),
    );
    // },
    // );
  }
}
