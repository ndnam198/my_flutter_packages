import '../../l10n/l10n.dart';
import 'any_state.dart';

class AnySuccess extends AnyState {
  const AnySuccess(super.code);

  static const AnySuccess empty = AnySuccess('');
  static const AnySuccess common = AnySuccess('any-success');

  @override
  String translate(AppLocalizations l10n) {
    if (code == 'any-success') {
      return l10n.successAny;
    }
    print('Unknown success code: $code');
    return '';
  }
}
