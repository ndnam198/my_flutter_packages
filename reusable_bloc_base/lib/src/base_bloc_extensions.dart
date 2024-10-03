import 'package:any_state/any_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_state.dart';

const _defaultShouldThrowOnTimeout = false;
const _defaultWaitSeconds = 3;

extension BlocEtensions<T extends dynamic> on Bloc<dynamic, T> {
  Future<T> awaitUntil(
    bool Function(T state) test, {
    int secondToWait = _defaultWaitSeconds,
    bool shouldThrowOnTimeout = _defaultShouldThrowOnTimeout,
  }) async {
    return await stream
        .firstWhere(
          test,
          orElse: () => state,
        )
        .timeout(
          Duration(seconds: secondToWait),
          onTimeout: () => shouldThrowOnTimeout
              ? throw Exception('Timeout waiting for success or failure')
              : state,
        );
  }
}

extension BaseBlocExtension<A, T extends BaseState<A>> on Bloc<dynamic, T> {
  Future<T> awaitFailure({
    int secondToWait = _defaultWaitSeconds,
    bool shouldThrowOnTimeout = _defaultShouldThrowOnTimeout,
  }) {
    return stream
        .firstWhere(
          (element) => element.failure.isNotEmpty,
          orElse: () => state,
        )
        .timeout(
          Duration(seconds: secondToWait),
          onTimeout: () =>
              shouldThrowOnTimeout ? throw AnyFailure.timeout : state,
        );
  }

  Future<T> awaitSuccess({
    int secondToWait = _defaultWaitSeconds,
    bool shouldThrowOnTimeout = _defaultShouldThrowOnTimeout,
  }) {
    return stream
        .firstWhere(
          (element) => element.success.isNotEmpty,
          orElse: () => state,
        )
        .timeout(
          Duration(seconds: secondToWait),
          onTimeout: () =>
              shouldThrowOnTimeout ? throw AnyFailure.timeout : state,
        );
  }

  Future<T> awaitSuccessOrFail({
    int secondToWait = _defaultWaitSeconds,
    bool shouldThrowOnTimeout = _defaultShouldThrowOnTimeout,
  }) {
    return stream
        .firstWhere(
          (element) => element.success.isNotEmpty || element.failure.isNotEmpty,
          orElse: () => state,
        )
        .timeout(
          Duration(seconds: secondToWait),
          onTimeout: () =>
              shouldThrowOnTimeout ? throw AnyFailure.timeout : state,
        );
  }
}
