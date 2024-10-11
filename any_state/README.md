# Any State

Simple state class declaration that supports localizations

## Features

- Simple state object that inherently supports localizations
- Function `translate` will deliver the message in the current app language
- Display what went wrong in the UI with ease (or success message)

## Getting started

- Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  any_state: ^0.0.1
```

## Usage

Create your own state class by extending `AnyState` and implement the `toString` method to return the desired message.

```dart
    class NetworkFailure extends AnyFailure {
      NetworkFailure.badResponse() : super('network_failure_bad_response');

      @override
      String toString(AppLocalizations l10n) {
        if(this is NetworkFailure.badResponse) {
          return l10n.networkFailureBadResponse; // <--- Your translation key
        }
        return super.toString(l10n);
      }
    }
```

## Additional information

Feel free to try it out and let me know what you think. I'm open to suggestions and improvements.
Contact me at [my email](mailto:ndnam198@gmail.com)
