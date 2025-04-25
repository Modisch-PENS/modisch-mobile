import 'package:flutter/material.dart';
import '../../constants/typography.dart';
import '../../constants/colors.dart';
import 'package:modisch/presentation/pages/wardrobe_page.dart';
import 'package:modisch/presentation/pages/model_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Modisch'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Recent Wardrobe'),
              Tab(text: 'Recent Model'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            WardrobePage(),
            ModelPage(),
          ],
        ),
      ),
    );
  }
}