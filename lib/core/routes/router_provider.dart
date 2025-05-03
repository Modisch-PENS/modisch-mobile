import 'package:go_router/go_router.dart';
import 'package:modisch/features/main/pages/main_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router_provider.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(RouterRef ref) => GoRouter(
  routes: [
    GoRoute(
      path: '/main',
      name: 'main',
      builder: (context, state) => const MainPage(),
    ),
  ],
  initialLocation: '/main',
  debugLogDiagnostics: false,
);
