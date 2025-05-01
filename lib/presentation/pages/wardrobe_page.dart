// wardrobe_page.dart
import 'package:flutter/material.dart';
import 'package:modisch/presentation/widgets/header.dart';
import 'package:modisch/presentation/widgets/tab_view.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({super.key});

  @override
  State<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column( 
          children: [
            const SizedBox(height: 24), 
            const Header(nameHeader: "Wardrobe"),
            const SizedBox(height: 24), 
            Expanded(
              child: TabView(),
            ),
          ],
        ),
      ),
    );
  }
}
