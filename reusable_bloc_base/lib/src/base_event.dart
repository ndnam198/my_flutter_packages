import 'package:equatable/equatable.dart';

class BaseEvent extends Equatable {
  const BaseEvent();

  @override
  List<Object?> get props => [];
}

/// A event to initialize the bloc. will execute only once when the bloc is created. Subsequent calls will be ignored.
class InitBlocEvent extends BaseEvent {}

/// A event to update/refresh the state's main data. This event can be called multiple times.
class RefreshDataEvent extends BaseEvent {
  final bool shouldInvalidateCache;

  const RefreshDataEvent({required this.shouldInvalidateCache});

  @override
  List<Object?> get props => [shouldInvalidateCache];
}

/// A event to dispose the bloc. This event will be called when the bloc is disposed.
class DisposeResourceEvent extends BaseEvent {}
