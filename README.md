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

Badge (will work after your first workflow run):

```
[![Flutter CI](https://github.com/<your-org-or-username>/<repo>/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/<your-org-or-username>/<repo>/actions/workflows/flutter-ci.yml)
```

Replace `<your-org-or-username>` and `<repo>` with your repository values.

If you want code coverage artifacts locally, run:

```bash
flutter test --coverage
```

Make sure you have Flutter SDK installed and on your PATH. Use the `stable` channel for best
compatibility.
