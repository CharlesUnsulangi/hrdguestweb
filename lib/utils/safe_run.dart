import 'dart:async';

import 'package:flutter/foundation.dart';

/// Runs [futureBuilder] with a timeout and catches errors.
/// Returns the result if successful, or null on error/timeout.
Future<T?> safeAsync<T>(
  Future<T> Function() futureBuilder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  try {
    final f = futureBuilder();
    if (timeout > Duration.zero) {
      return await f.timeout(timeout);
    } else {
      return await f;
    }
  } on TimeoutException catch (te) {
    // timeout
    // Log the timeout for diagnostics
    // (replace with your logging solution / send to Crashlytics if configured)
    debugPrint('safeAsync: timeout - $te');
    return null;
  } catch (e, st) {
    // general error
    // Log the error and stacktrace for diagnostics
    debugPrint('safeAsync: error - $e\n$st');
    return null;
  }
}
