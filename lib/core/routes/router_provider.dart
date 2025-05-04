import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modisch/features/main/pages/main_page.dart';
import 'package:modisch/features/onboard/riverpod/onboard_provider.dart';
import 'package:modisch/features/wardrobe/pages/crop_images_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:modisch/features/onboard/page/onboard.dart';
import 'package:modisch/features/wardrobe/pages/confirm_clothes_page.dart';
import 'package:image_picker/image_picker.dart';

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
      // Camera picker routes
      GoRoute(
        path: '/camera_picker',
        name: 'camera_picker',
        builder:
            (context, state) => const CropImagePage(source: ImageSource.camera),
      ),
      GoRoute(
        path: '/gallery_picker',
        name: 'gallery_picker',
        builder:
            (context, state) =>
                const CropImagePage(source: ImageSource.gallery),
      ),
      // Confirm clothes route with path parameter
      GoRoute(
        path: '/confirm_clothes/:imagePath',
        name: 'confirm_clothes',
        builder: (context, state) {
          final imagePath = state.pathParameters['imagePath'] ?? '';
          return ConfirmClothesPage(
            imagePath: Uri.decodeComponent(imagePath),
            onSave: (clothing) {
              // Navigate back to the main page
              context.goNamed('main');
            },
          );
        },
      ),
    ],
    errorBuilder:
        (context, state) => Scaffold(
          body: Center(child: Text('Route not found: ${state.uri.path}')),
        ),
    debugLogDiagnostics: true,
  );
}
