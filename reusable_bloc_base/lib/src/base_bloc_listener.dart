// ignore: unused_element
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_state.dart';
import 'base_state_reactor.dart';

const _debugTag = '[BaseStateListener]';

typedef Selector<S> = dynamic Function(S state);

class BaseBlocListener<A, B extends Bloc<dynamic, S>, S extends BaseState<A>>
    extends StatelessWidget {
  final Widget child;
  final String debugLabel;
  final AlertType failureType;
  final AlertType successType;
  final bool shouldShowLoading;
  final List<Selector<S>> customSelector;
  final List<A> loadingActions;
  final bool Function(BuildContext context, S state)? ignoreWhen;

  const BaseBlocListener({
    required this.child,
    this.loadingActions = const [],
    super.key,
    this.debugLabel = '',
    this.failureType = AlertType.dialog,
    this.successType = AlertType.dialog,
    this.shouldShowLoading = true,
    this.customSelector = const [],
    this.ignoreWhen,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        if (!failureType.isNone)
          ListenerFactory.failureListener<A, B, S>(
            debugLabel: debugLabel,
            type: failureType,
            ignoreWhen: ignoreWhen,
          ),
        if (!successType.isNone)
          ListenerFactory.successListener<A, B, S>(
            debugLabel: debugLabel,
            type: successType,
            ignoreWhen: ignoreWhen,
          ),
        if (shouldShowLoading)
          ListenerFactory.loadingListener<A, B, S>(
            selectors: customSelector,
            debugLabel: debugLabel,
            loadingActions: loadingActions,
            ignoreWhen: ignoreWhen,
          ),
      ],
      child: child,
    );
  }
}

class ListenerFactory {
  static BlocListener<B, T>
      failureListener<A, B extends Bloc<dynamic, T>, T extends BaseState<A>>({
    String debugLabel = '',
    bool Function(BuildContext context, T state)? ignoreWhen,
    AlertType type = AlertType.dialog,
  }) {
    return BlocListener<B, T>(
      listenWhen: (previous, current) =>
          previous.failure.isEmpty && current.failure.isNotEmpty,
      listener: (context, state) {
        if (ignoreWhen != null && ignoreWhen(context, state)) {
          return;
        }
        if (debugLabel.isNotEmpty) {
          print(
            '$_debugTag $debugLabel: failure state changes ${state.failure}',
          );
        }
        BaseStateReactor.onErrorState(
          context,
          state.failure,
        );
      },
      child: const SizedBox.shrink(),
    );
  }

  static BlocListener<B, S>
      loadingListener<A, B extends Bloc<dynamic, S>, S extends BaseState<A>>({
    String debugLabel = '',
    List<Selector<S>> selectors = const [],
    List<A> loadingActions = const [],
    bool Function(BuildContext context, S state)? ignoreWhen,
  }) {
    return BlocListener<B, S>(
      listenWhen: (previous, current) {
        if (debugLabel.isNotEmpty) {
          print(
            '$_debugTag $debugLabel: loading state changes ${current.isLoading}',
          );
        }
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
        if (debugLabel.isNotEmpty) {
          print(
            '$_debugTag $debugLabel: loading state changes $shouldShowLoading',
          );
        }
        if (shouldShowLoading) {
          BaseStateReactor.showLoading(context);
        } else {
          BaseStateReactor.hideLoading(context);
        }
      },
      child: const SizedBox.shrink(),
    );
  }

  static BlocListener<B, T>
      successListener<A, B extends Bloc<dynamic, T>, T extends BaseState<A>>({
    String debugLabel = '',
    bool Function(BuildContext context, T state)? ignoreWhen,
    AlertType type = AlertType.dialog,
  }) {
    return BlocListener<B, T>(
      listenWhen: (previous, current) =>
          previous.success.isEmpty &&
          current.success.isNotEmpty &&
          previous.success != current.success,
      listener: (context, state) {
        if (ignoreWhen != null && ignoreWhen(context, state)) {
          return;
        }
        if (debugLabel.isNotEmpty) {
          print(
            '$_debugTag $debugLabel: success state changes ${state.success}',
          );
        }
        BaseStateReactor.onSuccessState(
          context,
          state.success,
        );
      },
      child: const SizedBox.shrink(),
    );
  }
}

enum AlertType {
  dialog,
  snackbar,
  none;

  bool get isDialog => this == dialog;
  bool get isNone => this == none;
  bool get isSnackbar => this == snackbar;
}
