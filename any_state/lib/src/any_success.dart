import 'any_state.dart';

/// Any displayable success must extend this class
class AnySuccess extends AnyState {
  const AnySuccess(super.code);

  static const AnySuccess empty = AnySuccess('');
  static const AnySuccess common = AnySuccess('any-success');
}
