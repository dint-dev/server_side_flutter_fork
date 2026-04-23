## What is this?
  * Enables you to use "package:flutter" without Flutter SDK.
  * This is useful in server-side code that uses only Dart SDK.

## Usage
In your `pubspec.yaml`:
```yaml
dependencies:
  # ...

dependency_overrides:
  # Override Flutter
  flutter:
    git:
      url: https://github.com/dint-dev/server_side_flutter_fork
      path: packages/flutter
      branch: main # OR specify a commit hash
```