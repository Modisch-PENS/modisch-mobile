import 'package:go_router/go_router.dart';
import 'package:modisch/features/main/pages/main_page.dart';
import 'package:modisch/features/onboard/riverpod/onboard_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:modisch/features/onboard/page/onboard.dart';

part 'router_provider.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(RouterRef ref) {
  final hasOnBoarded = ref
      .watch(onboardStatusProvider)
      .maybeWhen(data: (value) => value, orElse: () => false);
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) {
          return hasOnBoarded ? '/main' : '/onboard';
        },
      ),
      GoRoute(
        path: '/onboard',
        name: 'onboard',
        builder: (context, state) => const OnboardPage(),
      ),
      GoRoute(
        path: '/main',
        name: 'main',
        builder: (context, state) => const MainPage(),
      ),
    ],
    debugLogDiagnostics: false,
  );
}
