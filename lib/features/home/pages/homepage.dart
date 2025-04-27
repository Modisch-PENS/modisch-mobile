import 'package:flutter/material.dart';
import 'package:modisch/features/home/widgets/home_app_bar.dart';
import 'package:modisch/features/home/widgets/home_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: const HomeBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to the Add Clothing page
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
