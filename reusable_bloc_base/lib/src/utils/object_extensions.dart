// ignore_for_file: no_runtimetype_tostring

import 'package:flutter/foundation.dart';

extension ObjectX on Object {
  String get debugTag => kDebugMode ? '[$runtimeType]' : '';
}
