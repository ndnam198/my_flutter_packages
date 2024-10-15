import 'dart:async';

import 'package:any_state/any_state.dart';
import 'package:flutter/material.dart';

typedef BaseStateReactorCallback<T extends AnyState> = FutureOr<void> Function(
  BuildContext context,
  T state,
);

typedef BaseStateReactorWithoutState = FutureOr<void> Function(
  BuildContext context,
);

class StateReactor {
  static BaseStateReactorCallback<AnyFailure> onErrorState =
      (context, failure) {};

  static BaseStateReactorCallback<AnySuccess> onSuccessState =
      (context, success) {};

  static BaseStateReactorWithoutState showLoading = (
    BuildContext context,
  ) {};

  static BaseStateReactorWithoutState hideLoading = (
    BuildContext context,
  ) {};
}
