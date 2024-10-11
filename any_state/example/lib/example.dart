import 'package:any_state/any_state.dart';
import 'package:any_state/l10n/app_localizations.dart';

class NetworkFailure extends AnyFailure {
  const NetworkFailure(super.code);

  const NetworkFailure.badResponse() : super('bad_response');

  const NetworkFailure.timeout() : super('timeout');

  const NetworkFailure.noInternet() : super('no_internet');

  @override
  String translate(AppLocalizations l10n) {
    switch (code) {
      case 'bad_response':
        return 'Bad response';
      case 'timeout':
        return 'Operation timeout';
      case 'no_internet':
        return 'No internet connection';
      default:
        return super.translate(l10n);
    }
  }
}

int example1() {
  // Create a failure
  // ignore: unused_local_variable
  const badResponseFailure = NetworkFailure.badResponse();

  return 0;
}
