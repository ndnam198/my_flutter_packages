// ignore: unused_element
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../reusable_bloc_base.dart';

const _debugTag = '[BaseStateListener]';

typedef Selector<S> = dynamic Function(S state);
typedef LoggerMethod = void Function(Object? object);

class BaseStateListener<
    ActionType,
    BlocType extends BaseBloc<ActionType, BaseEvent, State>,
    State extends BaseState<ActionType, State>> extends StatelessWidget {
  final Widget child;
  final bool debug;
  final bool shouldShowLoading;
  final List<Selector<State>> customSelector;
  final List<ActionType> loadingActions;
  final bool Function(BuildContext context, State state)? ignoreWhen;
  final Map<ActionType, void Function(BuildContext context, State state)>?
      onActionDoneHandlers;
  final LoggerMethod? logger;

  const BaseStateListener({
    required this.child,
    this.loadingActions = const [],
    super.key,
    this.debug = false,
    this.shouldShowLoading = true,
    this.customSelector = const [],
    this.ignoreWhen,
    this.onActionDoneHandlers,
    this.logger,
  });

  void Function(Object? object) get _logger => logger ?? print;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        ReactorFactory.failureListener<ActionType, BlocType, State>(
          debug: debug,
          ignoreWhen: ignoreWhen,
          logger: _logger,
        ),
        ReactorFactory.successListener<ActionType, BlocType, State>(
          debug: debug,
          ignoreWhen: ignoreWhen,
          logger: _logger,
        ),
        ReactorFactory.loadingListener<ActionType, BlocType, State>(
          selectors: customSelector,
          debug: debug,
          loadingActions: loadingActions,
          ignoreWhen: ignoreWhen,
          logger: _logger,
        ),
        ...(onActionDoneHandlers ?? {}).keys.map(
          (action) {
            final handler = onActionDoneHandlers![action]!;
            return ReactorFactory.actionDoneListener<ActionType, BlocType,
                State>(
              action: action,
              onActionDone: handler,
              debug: debug,
              logger: _logger,
            );
          },
        ),
      ],
      child: child,
    );
  }
}

class ReactorFactory {
  static BlocListener<BlocType, State> actionDoneListener<
      ActionType,
      BlocType extends BaseBloc<ActionType, BaseEvent, State>,
      State extends BaseState<ActionType, State>>({
    required ActionType action,
    required void Function(BuildContext context, State state) onActionDone,
    required bool debug,
    LoggerMethod? logger,
  }) {
    return BlocListener<BlocType, State>(
      listenWhen: (previous, current) =>
          previous.isActionPending(action) &&
          current.isActionNotPending(action),
      listener: (context, state) {
        if (debug) {
          (logger ?? print)(
            '$_debugTag $BlocType: action done $action',
          );
        }
        onActionDone.call(context, state);
      },
      child: const SizedBox.shrink(),
    );
  }

  static BlocListener<B, S> failureListener<A, B extends Bloc<dynamic, S>,
      S extends BaseState<A, S>>({
    required bool debug,
    bool Function(BuildContext context, S state)? ignoreWhen,
    LoggerMethod? logger,
  }) {
    return BlocListener<B, S>(
      listenWhen: (previous, current) =>
          previous.failure.isEmpty && current.failure.isNotEmpty,
      listener: (context, state) {
        if (ignoreWhen != null && ignoreWhen(context, state)) {
          return;
        }
        if (debug) {
          (logger ?? print)(
            '$_debugTag $B: failure state changes ${state.failure}',
          );
        }
        BlocStateReactor.onErrorState(
          context,
          state.failure,
        );
      },
      child: const SizedBox.shrink(),
    );
  }

  static BlocListener<BlocType, State> loadingListener<
      A,
      BlocType extends Bloc<dynamic, State>,
      State extends BaseState<A, State>>({
    required bool debug,
    List<Selector<State>> selectors = const [],
    List<A> loadingActions = const [],
    bool Function(BuildContext context, State state)? ignoreWhen,
    LoggerMethod? logger,
  }) {
    return BlocListener<BlocType, State>(
      listenWhen: (previous, current) {
        return selectors
                .any((element) => element(current) != element(previous)) ||
            previous.isLoading != current.isLoading ||
            previous.pendingActions != current.pendingActions;
      },
      listener: (context, state) {
        if (ignoreWhen != null && ignoreWhen(context, state)) {
          return;
        }
        final shouldShowLoading = state.isLoading ||
            selectors.any((element) => element(state) == true) ||
            state.pendingActions.any(
              (action) => loadingActions.contains(action),
            );
        if (debug) {
          (logger ?? print)(
            '$_debugTag $BlocType: loading state changes $shouldShowLoading',
          );
        }
        if (shouldShowLoading) {
          BlocStateReactor.showLoading(context);
        } else {
          BlocStateReactor.hideLoading(context);
        }
      },
      child: const SizedBox.shrink(),
    );
  }

  static BlocListener<BlocType, State> successListener<
      A,
      BlocType extends Bloc<dynamic, State>,
      State extends BaseState<A, State>>({
    required bool debug,
    bool Function(BuildContext context, State state)? ignoreWhen,
    LoggerMethod? logger,
  }) {
    return BlocListener<BlocType, State>(
      listenWhen: (previous, current) =>
          previous.success.isEmpty &&
          current.success.isNotEmpty &&
          previous.success != current.success,
      listener: (context, state) {
        if (ignoreWhen != null && ignoreWhen(context, state)) {
          return;
        }
        if (debug) {
          (logger ?? print)(
            '$_debugTag $BlocType: success state changes ${state.success}',
          );
        }
        BlocStateReactor.onSuccessState(
          context,
          state.success,
        );
      },
      child: const SizedBox.shrink(),
    );
  }
}
