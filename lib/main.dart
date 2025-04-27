import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Correctly initialize Hive
  await Hive.initFlutter();

  // Open the 'wardrobe' box
  await Hive.openBox('wardrobe');

  // Run the app
  runApp(const ProviderScope(child: ModischApp()));
}
final _appRouter = AppRouter();

class ModischApp extends StatelessWidget {
  const ModischApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Modisch',
      theme: ThemeData(
        useMaterial3: true,
      ),
      routerConfig: _appRouter.router,
    );
  }
}
