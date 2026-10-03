import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_screen.dart';
import 'services/ad_service.dart';
import 'services/app_repository.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AdService.instance.initialize();
    });
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
    if (state == AppLifecycleState.resumed) {
      widget.repository.importSharedFavoriteSites();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.repository,
      builder: (context, _) => MaterialApp(
        title: 'ねことまた旅',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(widget.repository.colorTheme),
        home: HomeScreen(repository: widget.repository),
      ),
    );
  }
}
