import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'destination.dart';

class AppScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffold({Key? key, required this.navigationShell}) : super(key: key);

  void _onTap(int index) {
    navigationShell.goBranch(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
        items: destinations.map((d) => BottomNavigationBarItem(
          icon: Icon(d.icon),
          label: d.label,
        )).toList(),
      ),
    );
  }
}
