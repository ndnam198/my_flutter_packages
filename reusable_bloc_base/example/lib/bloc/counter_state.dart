part of 'counter_bloc.dart';

class CounterState extends BaseState<void, CounterState> {
  const CounterState({
    super.success,
    super.failure,
    super.isLoading,
    super.pendingActions,
    required this.counter,
    required this.blocHistory,
  });

  final int counter;
  final String blocHistory;

  @override
  List<Object> get props => [...super.props, counter, blocHistory];

  @override
  CounterState copyWith({
    AnySuccess? success,
    AnyFailure? failure,
    bool? isLoading,
    Set<void>? pendingActions,
    int? counter,
    String? blocHistory,
  }) {
    return CounterState(
      counter: counter ?? this.counter,
      success: success ?? this.success,
      failure: failure ?? this.failure,
      isLoading: isLoading ?? this.isLoading,
      pendingActions: pendingActions ?? this.pendingActions,
      blocHistory: blocHistory ?? this.blocHistory,
    );
  }

  @override
  String toString() {
    return 'CounterState{\n'
        '  counter: $counter,\n'
        '  blocHistory: $blocHistory,\n'
        '  success: $success,\n'
        '  failure: $failure,\n'
        '  isLoading: $isLoading,\n'
        '  pendingActions: $pendingActions\n'
        '}';
  }
}
