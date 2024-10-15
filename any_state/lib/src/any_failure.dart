import 'package:equatable/equatable.dart';

import 'any_state.dart';

/// Any displayable failure must extend this class
class AnyFailure extends AnyState with EquatableMixin implements Exception {
  static const AnyFailure empty = AnyFailure('');
  static const AnyFailure common = AnyFailure('common-failure');
  static const AnyFailure unknown = AnyFailure('unknown-failure');
  static const AnyFailure system = AnyFailure('system-failure');
  static const AnyFailure notSupported = AnyFailure('not-supported');
  static const AnyFailure timeout = AnyFailure('operation-timeout');
  static const AnyFailure network = AnyFailure('network-failure');
  static const AnyFailure fetchData = AnyFailure('fetch-data');
  static const AnyFailure resourceNotFound = AnyFailure('resource-not-found');

  const AnyFailure(super.code);
}
