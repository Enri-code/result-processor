import 'package:flutter/material.dart';
import 'package:unn_grading/src/core/constants/app_color.dart';

final themeData = ThemeData(
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
);
