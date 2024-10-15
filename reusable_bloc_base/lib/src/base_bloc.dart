// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:any_state/any_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_event.dart';
import 'base_state.dart';

abstract class BaseBloc<A, E extends BaseEvent, S extends BaseState<A, S>>
    extends Bloc<E, S> {
  BaseBloc(super.initialState);

  /// Process only one event and ignore (drop) any new events
  /// until the current event is done.
  ///
  /// **Note**: dropped events never trigger the event handler.
  void onDroppable<Event extends E>(EventHandler<Event, S> handler) {
    on<Event>(
      handler,
      transformer: droppable<Event>(),
    );
  }

  /// Process events one at a time by maintaining a queue of added events
  /// and processing the events sequentially.
  ///
  /// **Note**: there is no event handler overlap and every event is guaranteed
  /// to be handled in the order it was received.
  void onSequential<Event extends E>(EventHandler<Event, S> handler) {
    on<Event>(
      handler,
      transformer: sequential<Event>(),
    );
  }

  /// Process events concurrently.
  ///
  /// **Note**: there may be event handler overlap and state changes will occur
  /// as soon as they are emitted. This means that states may be emitted in
  /// an order that does not match the order in which the corresponding events
  /// were added.
  void onConcurrent<Event extends E>(EventHandler<Event, S> handler) {
    on<Event>(
      handler,
      transformer: concurrent<Event>(),
    );
  }

  /// Process only one event by cancelling any pending events and
  /// processing the new event immediately.
  ///
  /// Avoid using [restartable] if you expect an event to have
  /// immediate results -- it should only be used with asynchronous APIs.
  ///
  /// **Note**: there is no event handler overlap and any currently running tasks
  /// will be aborted if a new event is added before a prior one completes.
  void onRestartable<Event extends E>(EventHandler<Event, S> handler) {
    on<Event>(
      handler,
      transformer: restartable<Event>(),
    );
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    if (error is AnyFailure) {
      emit(
        state.recoveryStateWhenError
            .failureState(
          failure: error,
        )
            .copyWith(
          pendingActions: {},
        ),
      );
    } else {
      emit(
        state.recoveryStateWhenError
            .failureState(
          failure: AnyFailure.unknown,
        )
            .copyWith(
          pendingActions: {},
        ),
      );
    }
    super.onError(error, stackTrace);
  }
}
