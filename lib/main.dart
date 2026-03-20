import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/api/supabase_provider.dart';

import 'core/sync/sync_engine.dart';
import 'core/theme/glass_theme.dart';
import 'core/database/isar_provider.dart';
import 'core/router/app_router.dart';
import 'shared/widgets/error_boundary.dart';


import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Desktop window initialization
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 800),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: 'Siam Kassam',
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // Initialize Core Services
  await initSupabase();
  final isar = await initIsar();

  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize Sync Engine
    ref.read(syncEngineProvider);

    final router = ref.watch(appRouterStateProvider);

    return GlobalErrorBoundary(
      child: MaterialApp.router(
        title: 'Siam Kassam',
        debugShowCheckedModeBanner: false,
        theme: GlassTheme.light,
        routerConfig: router,
      ),
    );
  }
}
