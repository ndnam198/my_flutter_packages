# reusable_bloc_base

Light-weight extension library for flutter_bloc

## Features

Cover most of the common work flow in a flutter bloc, avoid boilerplate code.

## Getting started

Install the package

```zsh
    flutter pub add reusable_bloc_base
```

## Usage

```dart
    // Your state class
    final class HelloWorldState extends BaseState<HelloWorldLoading> {
      const HelloWorldState({
        super.failure,
        super.isLoading,
        super.pendingActions,
        super.success,
      });

      @override
      List<Object> get props => [
            ...super.props,
          ];

      factory HelloWorldState.initial() {
        return const HelloWorldState();
      }

      @override
      HelloWorldState copyWith({
        AnySuccess? success,
        AnyFailure? failure,
        bool? isLoading,
        Set<HelloWorldLoading>? pendingActions,
      }) {
        return HelloWorldState(
          failure: failure ?? this.failure,
          isLoading: isLoading ?? this.isLoading,
          pendingActions: pendingActions ?? this.pendingActions,
          success: success ?? this.success,
        );
      }

      @override
      String toString() {
        return '''
          HelloWorldState {
            failure: $failure,
            isLoading: $isLoading,
            pendingActions: $pendingActions,
            success: $success,
          }
          ''';
      }
    }
```

```dart
    // Your bloc class
    class HelloWorldBloc extends BaseBloc<HelloWorldLoading,
    HelloWorldEvent, HelloWorldState> {
        HelloWorldBloc() { 
            ...//Your intialization code
        }

        FutureOr<void> _onHelloWorldEvent(
          HelloWorldEvent event,
          Emitter<HelloWorldState> emit,
        ) async {
            emit(state.beforeLoading()); // <--- you can just call this to set isLoading to true
            try {
                // Your business logic here ... (synchronous or asynchronous)
                emit(state.successState<HelloWorldState>()); // <--- state.successState will set isLoading to false and success to the given value
            } catch (e, stack) {
                addError(e, stack); // <--- simply call this to set failure state, the details of error will reflect in the state.failure (as long as you are using any_state package)
            }
        }
    } 

```

## Additional information

Feel free to try it out and let me know what you think. I'm open to suggestions and improvements.
Contact me at [my email](mailto:ndnam198@gmail.com)
