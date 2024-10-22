import 'dart:developer';

import 'package:flutter/foundation.dart';

/// Prints messages only in **Debug** mode
void dLog(dynamic message) {
  if (kDebugMode) log(message.toString());
}
