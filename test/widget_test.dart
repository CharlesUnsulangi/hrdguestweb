// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hrdguestweb/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Email submit success shows snackbar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // Enter a valid email
    final emailField = find.byType(TextField).first;
    await tester.enterText(emailField, 'user@example.com');

    // Tap the Kirim button
    await tester.tap(find.text('Kirim'));

    // Begin frame and wait for the async operation inside safeAsync (2s simulated)
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Expect success snackbar
    expect(find.text('Berhasil: Terkirim'), findsOneWidget);
  });

  testWidgets('Invalid email shows validation error', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    final emailField = find.byType(TextField).first;
    await tester.enterText(emailField, 'invalid');

    await tester.tap(find.text('Kirim'));
    await tester.pump();

    expect(find.text('Masukkan email yang valid.'), findsOneWidget);
  });

  testWidgets('ErrorWidget fallback shows ErrorScreen', (
    WidgetTester tester,
  ) async {
    // Save and override ErrorWidget.builder for this test, then restore it.
    final oldErrorWidgetBuilder = ErrorWidget.builder;
    ErrorWidget.builder = (FlutterErrorDetails details) =>
        ErrorScreen(details: details);

    // Temporarily override FlutterError.onError so the test harness doesn't mark the thrown exception as a test failure.
    final oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      // present the error but do not fail the test
      FlutterError.presentError(details);
    };

    try {
      // Pump a widget that throws during build
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              throw Exception('simulated build error');
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // The ErrorScreen shows Indonesian friendly message
      expect(
        find.text('Maaf, terjadi kesalahan pada aplikasi.'),
        findsOneWidget,
      );
    } finally {
      // restore original handlers/builders
      FlutterError.onError = oldOnError;
      ErrorWidget.builder = oldErrorWidgetBuilder;
    }
  });
}
