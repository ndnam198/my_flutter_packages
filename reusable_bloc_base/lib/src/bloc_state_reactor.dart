import 'dart:async';

import 'package:any_state/any_state.dart';
import 'package:flutter/material.dart';

typedef ReactorCallbackAgainstState<T extends AnyState> = FutureOr<void>
    Function(
  BuildContext context,
  T state,
);

typedef SimpleReactor = FutureOr<void> Function(
  BuildContext context,
);

class BlocStateReactor {
  static ReactorCallbackAgainstState<AnyFailure> onErrorState =
      (context, failure) {};

  static ReactorCallbackAgainstState<AnySuccess> onSuccessState =
      (context, success) {};

  static SimpleReactor showLoading = (
    BuildContext context,
  ) {};

  static SimpleReactor hideLoading = (
    BuildContext context,
  ) {};
}
