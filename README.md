# hrdguestweb

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Continuous Integration (GitHub Actions)

This repository includes a GitHub Actions workflow at `.github/workflows/flutter-ci.yml` that runs
on every push and pull request to `main`/`master`.

The workflow does:

- `flutter pub get`
- `flutter analyze`
- `flutter test` (with coverage)
- `flutter build web --release` (to verify the project builds)

To run the same checks locally (Windows), there is a helper script `ci_local.bat` in the project
root. Run it from the project folder:

```bat
cd C:\ProjectSoftwareCWU\flutter\hrdguestweb
ci_local.bat
```

Badge (will work once you push and Actions run):

[![Flutter CI](https://github.com/CharlesUnsulangi/hrdguestweb/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/CharlesUnsulangi/hrdguestweb/actions/workflows/flutter-ci.yml)

If you prefer the original badge URL format you can also use:

```
[![Flutter CI](https://github.com/CharlesUnsulangi/hrdguestweb/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/CharlesUnsulangi/hrdguestweb/actions/workflows/flutter-ci.yml)
```

After you push changes to GitHub, open:

https://github.com/CharlesUnsulangi/hrdguestweb/actions

to view the workflow runs and download artifacts (the web build is uploaded as an artifact by the
workflow).

If you want code coverage artifacts locally, run:

```bash
flutter test --coverage
```

Make sure you have Flutter SDK installed and on your PATH. Use the `stable` channel for best
compatibility.
