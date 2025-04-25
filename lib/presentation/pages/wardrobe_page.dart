import 'package:flutter/material.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({super.key});

  @override
  _WardrobePage createState() => _WardrobePage();
}

class _WardrobePage extends State<WardrobePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Modisch'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Shirt'),
              Tab(text: 'Pants'),
              Tab(text: 'Shoes'),
              Tab(text: 'Dress'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Shirt')),
            Center(child: Text('Pants')),
            Center(child: Text('Shoes')),
            Center(child: Text('Dress')),
          ],
        ),
      ),
    );
  }
} 