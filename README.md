## What is this?
  * Allows having Flutter dependencies without Flutter SDK.
  * This is useful in some server-side deployments.

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