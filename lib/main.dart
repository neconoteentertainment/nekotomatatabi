import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/app_repository.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = AppRepository(StorageService());
  await repository.initialize();
  runApp(NekotoMataTabiApp(repository: repository));
}

class NekotoMataTabiApp extends StatelessWidget {
  const NekotoMataTabiApp({super.key, required this.repository});
  final AppRepository repository;

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFFCE765C), brightness: Brightness.light);
    return MaterialApp(
      title: 'ねことまた旅',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: scheme,
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
      ),
      home: HomeScreen(repository: repository),
    );
  }
}
