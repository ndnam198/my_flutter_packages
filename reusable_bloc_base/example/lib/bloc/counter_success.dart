import 'package:any_state/any_state.dart';

class CounterSuccess extends AnySuccess {
  const CounterSuccess.incremented() : super('counter-incremented');
  const CounterSuccess.decremented() : super('counter-decremented');

  @override
  String translate([Object? l10n]) {
    switch (code) {
      case 'counter-incremented':
        return 'Counter incremented';
      case 'counter-decremented':
        return 'Counter decremented';
      default:
        return '';
    }
  }
}

class CounterFailure extends AnyFailure {
  const CounterFailure.counterFailed() : super('counter-failed');

  @override
  String translate([Object? l10n]) {
    switch (code) {
      case 'counter-failed':
        return 'Counter failed';
      default:
        return '';
    }
  }
}
