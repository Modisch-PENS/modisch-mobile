import 'package:flutter/material.dart';

class Destination {
  final String label;
  final IconData icon;
  final String initialLocation;

  const Destination({
    required this.label,
    required this.icon,
    required this.initialLocation,
  });
}

const List<Destination> destinations = [
  Destination(
    label: 'Home',
    icon: Icons.home,
    initialLocation: '/',
  ),
  Destination(
    label: 'Model',
    icon: Icons.view_module,
    initialLocation: '/models',
  ),
  Destination(
    label: 'Wardrobe',
    icon: Icons.checkroom,
    initialLocation: '/wardrobe',
  ),
];
