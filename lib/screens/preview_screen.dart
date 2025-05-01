import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/selected_model.dart';
import '../widgets/top_tab.dart';
import '../widgets/preview_select_screen.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  int _currentIndex = 0;
  late PageController _pageController;
  final List<String> tabs = ['Shirt', 'Pants', 'Dress', 'Shoes'];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = Provider.of<SelectedModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Make Model',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          _buildPreviewArea(selected),

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
                showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: const Text('Success'),
                        content: const Text('Your outfit has been saved!'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
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

          // TOP TAB - tetap pakai klik
          TopTab(currentIndex: _currentIndex, onTabSelected: _onTabSelected),

          const SizedBox(height: 10),

          // PAGE VIEW - bisa swipe geser antar kategori
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children:
                  tabs.map((tab) {
                    return PreviewSelectScreen(category: tab);
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewArea(SelectedModel selected) {
    return DragTarget<String>(
      onAccept: (data) {
        final selectedModel = Provider.of<SelectedModel>(
          context,
          listen: false,
        );
        bool isNone = data.startsWith('none') || data.contains('0.png');
        String? actualImage = isNone ? null : data;

        if (tabs[_currentIndex] == 'Shirt') {
          selectedModel.selectShirt(actualImage);
        } else if (tabs[_currentIndex] == 'Pants') {
          selectedModel.selectPants(actualImage);
        } else if (tabs[_currentIndex] == 'Dress') {
          selectedModel.selectDress(actualImage);
        } else if (tabs[_currentIndex] == 'Shoes') {
          selectedModel.selectShoes(actualImage);
        }
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 348,
          height: 437,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(16),
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
        );
      },
    );
  }
}
