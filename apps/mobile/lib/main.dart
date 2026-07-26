import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:logging/logging.dart';
import 'src/frb_generated.dart/frb_generated.dart';
import 'src/theme/light_theme.dart';
import 'src/theme/dark_theme.dart';
import 'src/app/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("=== DILANG MAIN APP STARTED ===");

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('[${record.level.name}] ${record.time}: ${record.message}');
  });

  bool rustInitSuccess = false;
  String? rustInitError;

  try {
    debugPrint("=== INITIALIZING FLUTTER RUST BRIDGE (RustLib.init()) ===");
    await _initRustLibrary();
    rustInitSuccess = true;
    debugPrint("=== FLUTTER RUST BRIDGE INITIALIZED SUCCESSFULLY ===");
  } catch (e, stack) {
    rustInitError = e.toString();
    debugPrint("=== RUSTLIB INIT FAILED: $e ===\n$stack");
  }

  runApp(
    ProviderScope(
      child: DiLangApp(
        rustInitSuccess: rustInitSuccess,
        rustInitError: rustInitError,
      ),
    ),
  );
}

Future<void> _initRustLibrary() async {
  final String libName = Platform.isWindows
      ? 'dilang_ffi.dll'
      : Platform.isMacOS
          ? 'libdilang_ffi.dylib'
          : 'libdilang_ffi.so';

  final List<String> candidatePaths = [
    // 1. Bundle directory / RPATH relative to executable
    '${Directory.current.path}/lib/$libName',
    '${Directory.current.path}/build/linux/x64/debug/bundle/lib/$libName',
    '${Directory.current.path}/build/linux/x64/release/bundle/lib/$libName',
    // 2. Relative from apps/mobile directory to workspace target directory
    '../../target/debug/$libName',
    '../../target/release/$libName',
    // 3. Absolute path resolution
    '${Directory.current.path}/../../target/debug/$libName',
    '${Directory.current.path}/../../target/release/$libName',
    '${Directory.current.path}/target/debug/$libName',
    '${Directory.current.path}/target/release/$libName',
    libName,
  ];

  ExternalLibrary? externalLibrary;

  for (final path in candidatePaths) {
    try {
      final file = File(path);
      if (file.existsSync()) {
        externalLibrary = ExternalLibrary.open(file.absolute.path);
        debugPrint("=== RUST FFI: Loaded dynamic library from file path: ${file.absolute.path} ===");
        break;
      } else if (path == libName) {
        // Fallback bare system name attempt
        try {
          externalLibrary = ExternalLibrary.open(path);
          debugPrint("=== RUST FFI: Loaded dynamic library via system name: $path ===");
          break;
        } catch (_) {}
      }
    } catch (e) {
      debugPrint("RUST FFI candidate path failed ($path): $e");
    }
  }

  if (externalLibrary != null) {
    await RustLib.init(externalLibrary: externalLibrary);
  } else {
    debugPrint("=== RUST FFI: Attempting default loader config ===");
    await RustLib.init();
  }
}

class DiLangApp extends StatelessWidget {
  final bool rustInitSuccess;
  final String? rustInitError;

  const DiLangApp({
    super.key,
    required this.rustInitSuccess,
    this.rustInitError,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("=== BUILDING DILANG APP WITH MATERIALAPP.ROUTER ===");

    if (!rustInitSuccess) {
      return MaterialApp(
        title: 'DiLang - Initialization Error',
        debugShowCheckedModeBanner: false,
        theme: getDarkThemeData(),
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 64, color: Colors.redAccent),
                  const SizedBox(height: 24),
                  const Text(
                    'Unable to initialize Rust runtime.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    rustInitError ?? 'Unknown FFI initialization error.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return MaterialApp.router(
      title: 'DiLang',
      debugShowCheckedModeBanner: false,
      theme: getLightThemeData(),
      darkTheme: getDarkThemeData(),
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
    );
  }
}
