import 'package:flutter/material.dart';
import '../../constants/typography.dart';
import '../../constants/colors.dart';
import 'package:modisch/presentation/pages/wardrobe_page.dart';
import 'package:modisch/presentation/pages/model_page.dart';
import 'package:modisch/presentation/widgets/wardrobe_card.dart';

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
          backgroundColor: Theme.of(context).colorScheme.surface,
          toolbarHeight: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Recent Wardrobe'), 
              Tab(text: 'Recent Model')
            ],
          ),
        ),
        body: Column(
          children: [
            const Expanded(
              child: TabBarView(children: [WardrobePage(), ModelPage()]),
            ),
          ],
        ),
      ),
    );
  }
}
