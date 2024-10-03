import 'package:any_state/any_state.dart';
import 'package:equatable/equatable.dart';

abstract class BaseState<A> extends Equatable {
  final AnyFailure failure;
  final AnySuccess success;
  final bool isLoading;
  final Set<A> pendingActions;

  const BaseState({
    this.isLoading = false,
    this.success = AnySuccess.empty,
    this.failure = AnyFailure.empty,
    this.pendingActions = const {},
  });

  BaseState<A> get resetValue;

  @override
  List<Object> get props => [
        success,
        failure,
        isLoading,
        pendingActions,
      ];

  T _afterAction<T extends BaseState<A>>({
    AnySuccess? success,
    AnyFailure? failure,
    A? action,
  }) {
    final updatedActions = action != null
        ? (Set<A>.from(pendingActions)..remove(action))
        : pendingActions;

    return copyWith(
      success: success,
      isLoading: action != null ? isLoading : false,
      failure: failure,
      pendingActions: updatedActions,
    ) as T;
  }

  T beforeAction<T extends BaseState<A>>([A? action]) {
    return copyWith(
      success: AnySuccess.empty,
      failure: AnyFailure.empty,
      isLoading: action != null ? isLoading : true,
      pendingActions:
          action != null ? {...pendingActions, action} : pendingActions,
    ) as T;
  }

  T beforeActionNoLoading<T extends BaseState<A>>() {
    return copyWith(
      success: AnySuccess.empty,
      failure: AnyFailure.empty,
      isLoading: false,
    ) as T;
  }

  BaseState<A> copyWith({
    AnySuccess? success,
    AnyFailure? failure,
    bool? isLoading,
    Set<A>? pendingActions,
  });

  T failureState<T extends BaseState<A>>({
    AnyFailure? failure,
    A? action,
  }) {
    return _afterAction(
      failure: failure,
      action: action,
    ) as T;
  }

  T successState<T extends BaseState<A>>({
    AnySuccess? success,
    A? clearAction,
  }) {
    return _afterAction(
      success: success,
      action: clearAction,
    ) as T;
  }
}
