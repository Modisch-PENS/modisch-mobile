import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/model/selected_model.dart';
import '/screens/shirt_screen.dart';
import '/screens/pants_screen.dart';
import '/screens/shoes_screen.dart';
import '/screens/dress_screen.dart';
import '/widgets/top_tab.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  int _currentIndex = 0;

  final List<Widget> screens = const [
    ShirtScreen(),
    PantsScreen(),
    DressScreen(),
    ShoesScreen(),
  ];

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Do you want to discard?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Back to home
            },
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = Provider.of<SelectedModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _confirmExit,
        ),
        title: const Text(
          'Make Model',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600, // M3 headline medium bold
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // Preview Card
          Container(
            width: 348,
            height: 437,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (selected.shirt != null)
                  Image.asset('assets/images/${selected.shirt!}', height: 100),
                if (selected.dress != null)
                  Image.asset('assets/images/${selected.dress!}', height: 120),
                if (selected.pants != null)
                  Image.asset('assets/images/${selected.pants!}', height: 100),
                if (selected.shoes != null)
                  Image.asset('assets/images/${selected.shoes!}', height: 80),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Save Button
          SizedBox(
            width: 268,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF21ABDE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Model saved successfully!')),
                );
              },
              child: const Text(
                "Save",
                style: TextStyle(
                  color: Color(0xFFFCFCFC),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Top Tab Navigation
          TopTab(
            currentIndex: _currentIndex,
            onTabSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),

          const SizedBox(height: 10),

          // Screen Content
          Expanded(
            child: screens[_currentIndex],
          ),
        ],
      ),
    );
  }
}
