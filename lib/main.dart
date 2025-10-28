import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hrdguestweb/screens/application_form.dart';
import 'package:hrdguestweb/screens/contact_form.dart';
import 'package:hrdguestweb/screens/landing_screen.dart';
import 'package:hrdguestweb/screens/pelamar_list_screen.dart';
import 'package:hrdguestweb/utils/safe_run.dart';
import 'package:hrdguestweb/utils/validators.dart';

void main() {
  // Ensure binding initialized before setting handlers
  WidgetsFlutterBinding.ensureInitialized();

  // Catch synchronous Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    // Present the error in debug console
    FlutterError.presentError(details);
    // Forward to zone to allow runZonedGuarded to catch it as well
    Zone.current.handleUncaughtError(
      details.exception,
      details.stack ?? StackTrace.empty,
    );
  };

  // Catch errors from the engine/platform level
  ui.PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    // Log for diagnostics
    debugPrint('PlatformDispatcher.onError: $error\n$stack');
    // Return true to indicate the error is handled and prevent default (which may crash)
    return true;
  };

  // Provide a user-friendly error widget for build-time errors
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return ErrorScreen(details: details);
  };

  // Catch async and other uncaught errors
  runZonedGuarded(
    () {
      runApp(RestartWidget(child: const MyApp()));
    },
    (Object error, StackTrace stack) {
      // Log uncaught errors
      debugPrint('Uncaught zone error: $error\n$stack');
      // Optionally: send to remote logging here
    },
  );
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, required this.child});

  final Widget child;

  /// Call RestartWidget.restartApp(context) to restart the app programmatically
  static void restartApp(BuildContext context) {
    final RestartWidgetState? state = context
        .findAncestorStateOfType<RestartWidgetState>();
    state?.restartApp();
  }

  @override
  RestartWidgetState createState() => RestartWidgetState();
}

class RestartWidgetState extends State<RestartWidget> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _key, child: widget.child);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LandingScreen(),
      routes: {
        '/apply': (context) => const ApplicationFormScreen(role: 'staff'),
        '/admin/pelamar': (context) => const PelamarListScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final TextEditingController _emailController = TextEditingController();
  bool _loading = false;
  String? _errorText;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> _submitEmail() async {
    final email = _emailController.text;
    setState(() {
      _errorText = null;
    });

    if (!looksLikeEmail(email)) {
      setState(() {
        _errorText = 'Masukkan email yang valid.';
      });
      return;
    }

    setState(() {
      _loading = true;
    });

    // Simulate an async network call safely with timeout and error handling
    final result = await safeAsync<String?>(() async {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      // For demo purposes, return a success message
      return 'Terkirim';
    }, timeout: const Duration(seconds: 5));

    if (!mounted) {
      // Widget disposed while waiting for async call; nothing to do.
      return;
    }

    setState(() {
      _loading = false;
    });

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengirim. Coba lagi.')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Berhasil: $result')));
      _emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You have pushed the button this many times:'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'contoh@domain.com',
                  errorText: _errorText,
                ),
              ),
              const SizedBox(height: 12),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitEmail,
                      child: const Text('Kirim'),
                    ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  try {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('App is working')),
                    );
                  } catch (e, st) {
                    debugPrint('Button handler error: $e\n$st');
                  }
                },
                child: const Text('Test safe action'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ContactFormScreen()));
                },
                child: const Text('Buka Contact Form'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                      const ApplicationFormScreen(
                          role: 'driver')));
                },
                child: const Text('Melamar sebagai Driver'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                      const ApplicationFormScreen(
                          role: 'staff')));
                },
                child: const Text('Melamar sebagai Staff'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.details});

  final FlutterErrorDetails details;

  @override
  Widget build(BuildContext context) {
    // Don't show large stacks in release; keep friendly message
    final bool isDebug = kDebugMode;
    return Scaffold(
      appBar: AppBar(title: const Text('Something went wrong')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 12),
            const Text(
              'Maaf, terjadi kesalahan pada aplikasi.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Aplikasi tidak akan crash. Anda dapat mencoba memulai ulang aplikasi.',
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  // Show stack only in debug mode to avoid leaking internals
                  isDebug ? details.toString() : '${details.exception}',
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Restart the whole app
                      RestartWidget.restartApp(context);
                    },
                    child: const Text('Mulai ulang aplikasi'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Try to navigate back to a safe route or just pop if possible
                      Navigator.of(context).maybePop();
                    },
                    child: const Text('Kembali'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
