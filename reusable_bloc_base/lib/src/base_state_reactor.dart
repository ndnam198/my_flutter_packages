import 'dart:async';

import 'package:any_state/any_state.dart';
import 'package:any_state/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

typedef BaseStateReactorCallback<T extends AnyState> = FutureOr<void> Function(
  BuildContext context,
  T state,
);

typedef BaseStateReactorWithoutState = FutureOr<void> Function(
  BuildContext context,
);

class BaseStateReactor {
  static BaseStateReactorCallback<AnyFailure> onErrorState =
      (context, failure) {
    context.showSnackbarFailure(failure.translate(context.l10n));
  };

  static BaseStateReactorCallback<AnySuccess> onSuccessState =
      (context, success) {
    context.showSnackbarSuccess(success.translate(context.l10n));
  };

  static BaseStateReactorWithoutState showLoading = (
    BuildContext context,
  ) {};

  static BaseStateReactorWithoutState hideLoading = (
    BuildContext context,
  ) {};
}

extension _StateReactorExtensions on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  void showSnackbarFailure(String message, {EdgeInsets? margin}) {
    if (message.isEmpty || !mounted) return;
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
        behavior: margin != null ? SnackBarBehavior.floating : null,
        margin: margin,
      ),
    );
  }

  void showSnackbarSuccess(String message, {EdgeInsets? margin}) {
    if (message.isEmpty || !mounted) return;
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: margin != null ? SnackBarBehavior.floating : null,
        margin: margin,
      ),
    );
  }
}
