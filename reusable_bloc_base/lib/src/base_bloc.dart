// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:any_state/any_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_state.dart';
import 'utils/object_extensions.dart';

abstract class BaseBloc<A, E, S extends BaseState<A>> extends Bloc<E, S> {
  BaseBloc(super.initialState);

  @override
  void onError(Object error, StackTrace stackTrace) {
    if (error is AnyFailure) {
      print(
        '$debugTag Error happened: $error, code ${error.code}, stack: $stackTrace',
      );
      emit(
        state
            .failureState<S>(
          failure: error,
        )
            .copyWith(
          pendingActions: {},
        ) as S,
      );
    } else {
      print('$debugTag non AnyFailure error: $error, $stackTrace');
      emit(
        state
            .failureState<S>(
          failure: AnyFailure.system,
        )
            .copyWith(
          pendingActions: {},
        ) as S,
      );
    }
    super.onError(error, stackTrace);
  }
}
