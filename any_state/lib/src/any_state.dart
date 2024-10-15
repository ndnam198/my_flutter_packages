import 'package:equatable/equatable.dart';

import '../any_state.dart';

abstract class AnyState extends Equatable {
  const AnyState(this.code);

  /// a dashed string to briefly describe the state
  final String code;

  /// a method to translate the state to a human-readable string
  String translate([covariant Object? l10n]) {
    throw UnimplementedError();
  }

  bool get isEmpty => code == '';
  bool get isNotEmpty => !isEmpty;
  bool get isSuccess => this is AnySuccess;
  bool get isFailure => this is AnyFailure;

  @override
  String toString() {
    return '$runtimeType{code: $code}';
  }

  @override
  List<Object?> get props => [code];
}
