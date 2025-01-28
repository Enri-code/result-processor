import 'package:flutter/material.dart';
import 'package:unn_grading/src/core/constants/app_color.dart';

final themeData = ThemeData(
  useMaterial3: true,
  inputDecorationTheme: InputDecorationTheme(
    isDense: true,
    filled: true,
    fillColor: AppColor.lightGrey1,
    hintStyle: const TextStyle(color: Colors.black45, fontSize: 13, height: 1),
    errorStyle: TextStyle(color: Colors.red[900], fontSize: 10, height: 1),
    prefixIconColor: Colors.grey,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[500]!, width: 1.5),
      borderRadius: const BorderRadius.all(Radius.circular(4)),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.lightGrey3),
      borderRadius: BorderRadius.all(Radius.circular(6)),
    ),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primary),
);
