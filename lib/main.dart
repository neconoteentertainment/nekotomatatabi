import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_screen.dart';
import 'services/app_repository.dart';
import 'services/storage_service.dart';
import 'widgets/app_scaffold.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
  final repository = AppRepository(StorageService());
  await repository.initialize();
  runApp(NekotoMataTabiApp(repository: repository));
}

class NekotoMataTabiApp extends StatefulWidget {
  const NekotoMataTabiApp({super.key, required this.repository});
  final AppRepository repository;

  @override
  State<NekotoMataTabiApp> createState() => _NekotoMataTabiAppState();
}

class _NekotoMataTabiAppState extends State<NekotoMataTabiApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.repository.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    widget.repository.setAppActive(state == AppLifecycleState.resumed);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppScaffold.gold,
      brightness: Brightness.dark,
    );
    return MaterialApp(
      title: 'ねことまた旅',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: scheme,
        scaffoldBackgroundColor: AppScaffold.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppScaffold.background,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          color: AppScaffold.panel,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: AppScaffold.gold.withValues(alpha: .38)),
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: AppScaffold.panel,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppScaffold.gold.withValues(alpha: .45)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppScaffold.gold.withValues(alpha: .45)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppScaffold.gold, width: 1.5),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppScaffold.gold,
            foregroundColor: const Color(0xFF241C17),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: AppScaffold.gold),
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(repository: widget.repository),
    );
  }
}
