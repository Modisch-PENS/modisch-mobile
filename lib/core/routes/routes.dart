import 'dart:io';

import 'package:go_router/go_router.dart';
import 'package:modisch/features/home/pages/homepage.dart';
import 'package:modisch/features/wardrobe/pages/wardrobe_page.dart';
import 'package:modisch/features/wardrobe/pages/add_clothing_page.dart';
import 'package:modisch/features/model/pages/model_page.dart';
import 'package:modisch/features/model/pages/create_model_page.dart';
import 'layout.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/models',
                builder: (context, state) => const ModelsPage(), // replace with ModelPage()
                routes: [
                  GoRoute(
                    path: 'create',
                    builder: (context, state) => const CreateModelPage(), // replace with CreateModelPage()
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/wardrobe',
                builder: (context, state) => const WardrobePage(),
                routes: [
                  GoRoute(
                    path: 'add',
                    builder: (context, state) {
                      final imageFile = state.extra as File;
                      return AddClothingPage(imageFile: imageFile);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Example of additional non-bottom-navbar route
      /*GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),*/
    ],
  );
}
