import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../l10n/l10n.dart';

abstract class AnyState extends Equatable {
  const AnyState(this.code);

  /// a dashed string to briefly describe the state
  final String code;

  /// a method to translate the state to a human-readable string
  String translate(AppLocalizations l10n);

  bool get isEmpty => code == '';
  bool get isNotEmpty => !isEmpty;

  @override
  String toString() {
    if (kDebugMode) {
      // ignore: no_runtimetype_tostring
      return '$runtimeType{code: $code}';
    }
    return super.toString();
  }

  @override
  List<Object?> get props => [code];
}
