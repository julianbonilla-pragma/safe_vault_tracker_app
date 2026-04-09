import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_vault_tracker_app/safe_vault_tracker.dart';

import 'core/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CreateAssetNotifier>(
          create: (_) => sl<CreateAssetNotifier>(),
        ),
        ChangeNotifierProvider<GetAssetListNotifier>(
          create: (_) => sl<GetAssetListNotifier>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Safe Vault Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: Routes.router,
      ),
    );
  }
}
