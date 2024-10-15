part of 'counter_bloc.dart';

class CounterEvent extends BaseEvent {
  const CounterEvent();

  @override
  List<Object> get props => [];
}

class IncrementCounterEvent extends CounterEvent {
  const IncrementCounterEvent();

  @override
  List<Object> get props => [];
}

class DecrementCounterEvent extends CounterEvent {
  const DecrementCounterEvent();

  @override
  List<Object> get props => [];
}

class ShowFailureEvent extends CounterEvent {
  const ShowFailureEvent();
}

class PrintBlocHistoryEvent extends CounterEvent {
  const PrintBlocHistoryEvent();
}
