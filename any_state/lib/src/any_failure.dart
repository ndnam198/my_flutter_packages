import 'package:equatable/equatable.dart';

import '../../l10n/l10n.dart';
import 'any_state.dart';

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

  @override
  String translate(AppLocalizations l10n) {
    if (code == 'common-failure') {
      return l10n.failureOperation;
    } else if (code == 'unknown-failure') {
      return l10n.failureUnknown;
    } else if (code == 'system-failure') {
      return l10n.failureSystem;
    } else if (code == 'not-supported') {
      return l10n.failureOperationNotSupported;
    } else if (code == 'operation-timeout') {
      return l10n.failureOperationTimeout;
    } else if (code == 'network-failure') {
      return l10n.failureNetwork;
    } else if (code == 'fetch-data') {
      return l10n.failureFetchDataFromInternet;
    } else if (code == 'resource-not-found') {
      return l10n.failureResourceNotFound;
    } else {
      print('Unknown failure code: $code');
      return '';
    }
  }
}
