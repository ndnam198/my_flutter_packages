import 'dart:async';

import 'package:any_state/any_state.dart';
import 'package:example/bloc/counter_success.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reusable_bloc_base/reusable_bloc_base.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends BaseBloc<void, CounterEvent, CounterState>
    with BlocContinuousHistorySnapshot {
  CounterBloc() : super(const CounterState(counter: 0, blocHistory: '')) {
    onDroppable<IncrementCounterEvent>(_onIncrementCounter);
    onDroppable<DecrementCounterEvent>(_onDecrementCounter);
    onDroppable<ShowFailureEvent>(_onShowFailure);
    onDroppable<PrintBlocHistoryEvent>(_onPrintBlocHistory);
  }

  FutureOr<void> _onIncrementCounter(
      CounterEvent event, Emitter<CounterState> emit) async {
    emit(state.beforeAction());
    emit(state
        .successState(success: const CounterSuccess.incremented())
        .copyWith(counter: state.counter + 1));
  }

  FutureOr<void> _onDecrementCounter(
      CounterEvent event, Emitter<CounterState> emit) async {
    emit(state.beforeAction());
    emit(state
        .successState(success: const CounterSuccess.decremented())
        .copyWith(counter: state.counter - 1));
  }

  FutureOr<void> _onShowFailure(
      ShowFailureEvent event, Emitter<CounterState> emit) async {
    emit(state.beforeAction());
    await Future.delayed(const Duration(seconds: 1));
    emit(state.failureState(failure: const CounterFailure.counterFailed()));
  }

  FutureOr<void> _onPrintBlocHistory(
      PrintBlocHistoryEvent event, Emitter<CounterState> emit) async {
    final history = getLastNItems(historySize!);
    emit(state.copyWith(
      blocHistory: history.map((e) => e.toString()).join('\n'),
    ));
  }

  @override
  int? get historySize => 10;
}
