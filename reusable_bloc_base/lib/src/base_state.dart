import 'package:any_state/any_state.dart';
import 'package:equatable/equatable.dart';

import 'utils/utils.dart';

abstract class BaseState<ActionType, S extends BaseState<ActionType, S>>
    extends Equatable {
  final AnyFailure failure;
  final AnySuccess success;

  /// default property to control loading state
  final bool isLoading;

  /// contains properties to control loading state and other extra handling actions
  final Set<ActionType> pendingActions;

  const BaseState({
    this.isLoading = false,
    this.success = AnySuccess.empty,
    this.failure = AnyFailure.empty,
    this.pendingActions = const {},
  });

  bool isActionPending(ActionType action) => pendingActions.contains(action);
  bool isActionNotPending(ActionType action) => !isActionPending(action);

  S get recoveryStateWhenError => this as S;

  @override
  List<Object> get props => [
        success,
        failure,
        isLoading,
        pendingActions,
      ];

  S _afterAction({
    AnySuccess? success,
    AnyFailure? failure,
    ActionType? action,
  }) {
    final updatedActions = action != null
        ? (Set<ActionType>.from(pendingActions)..remove(action))
        : pendingActions;

    return copyWith(
      success: success,
      isLoading: action != null ? isLoading : false,
      failure: failure,
      pendingActions: updatedActions,
    );
  }

  S beforeAction([ActionType? action]) {
    return copyWith(
      success: AnySuccess.empty,
      failure: AnyFailure.empty,
      isLoading: action != null ? isLoading : true,
      pendingActions:
          action != null ? {...pendingActions, action} : pendingActions,
    );
  }

  S beforeActionNoLoading() {
    return copyWith(
      success: AnySuccess.empty,
      failure: AnyFailure.empty,
      isLoading: false,
    );
  }

  S copyWith({
    AnySuccess? success,
    AnyFailure? failure,
    bool? isLoading,
    Set<ActionType>? pendingActions,
  });

  S failureState({
    AnyFailure? failure,
    ActionType? action,
  }) {
    return _afterAction(
      failure: failure,
      action: action,
    );
  }

  S successState({
    AnySuccess? success,
    ActionType? clearAction,
  }) {
    return _afterAction(
      success: success,
      action: clearAction,
    );
  }

  @override
  String toString() {
    return '''
  $debugTag {
    success: $success,
    failure: $failure,
    isLoading: $isLoading,
    pendingActions: $pendingActions,
  }
  ''';
  }
}
