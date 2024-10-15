import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';

/// This helps to keep a history of the states that the bloc has gone through. Mostly for debugging purposes.
mixin BlocContinuousHistorySnapshot<B, S> on Bloc<B, S> {
  final Queue<S> _history = Queue<S>();

  /// determined by the mixin user
  int? get historySize;
  int get _historySize => historySize ?? 5; // default history size

  @override
  void onTransition(Transition<B, S> transition) {
    _history.add(transition.nextState);
    if (_history.length > _historySize) {
      _history.removeFirst();
    }
    super.onTransition(transition);
  }

  S get previousState {
    if (_history.length > 1) {
      return _history.last;
    }
    return state;
  }

  List<S> getLastNItems(int item) {
    if (item > _history.length) {
      return _history.toList();
    }
    return _history.toList().sublist(_history.length - item);
  }
}
