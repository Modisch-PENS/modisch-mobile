import 'package:flutter/material.dart';
import 'package:modisch/constants/colors.dart';
import 'package:provider/provider.dart';
import '/model/selected_model.dart';
import '/widgets/top_tab.dart';
import '/widgets/preview_select_screen.dart';
import '/screens/model_screen.dart';

class PreviewScreen extends StatefulWidget {
  //final ModelData? modelData; // Tambahkan parameter untuk menerima data model
  final bool reset;

  // const PreviewScreen({super.key, this.modelData, this.reset = false});
  const PreviewScreen({super.key, this.reset = false});

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (ctx) => AlertDialog(
                    title: const Text('Discard Changes'),
                    content: const Text(
                      'Do you want to discard unsaved changes?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.pop(context);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
            );
          },
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
                backgroundColor: AppColors.tertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                minimumSize: const Size(268, 48),
              ),
              onPressed: () {
                final controller = TextEditingController();
                showDialog(
                  context: context,
                  builder:
                      (ctx) => AlertDialog(
                        title: const Text('Save Outfit'),
                        content: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: "Enter outfit name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              final name = controller.text.trim();
                              if (name.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter outfit name'),
                                  ),
                                );
                                return;
                              }
                              Provider.of<SelectedModel>(
                                context,
                                listen: false,
                              ).saveOutfit(name);
                              Navigator.pop(ctx);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ModelScreen(),
                                ),
                              );
                            },
                            child: const Text('Save'),
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
          // TOP TAB
          TopTab(currentIndex: _currentIndex, onTabSelected: _onTabSelected),
          const SizedBox(height: 10),
          // PAGE VIEW - ubah Expanded menjadi Container dengan tinggi tetap
          Flexible(
            child: Container(
              height:
                  MediaQuery.of(context).size.height *
                  0.4, // 40% dari tinggi layar
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
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewArea(SelectedModel selected) {
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
            Image.asset(
              'assets/images/${selected.shirt!}',
              height: 100,
              errorBuilder: (context, error, stackTrace) {
                return Text('Gambar tidak ditemukan: ${selected.shirt}');
              },
            ),
          if (selected.dress != null)
            Image.asset(
              'assets/images/${selected.dress!}',
              height: 100,
              errorBuilder: (context, error, stackTrace) {
                return Text('Gambar tidak ditemukan: ${selected.dress}');
              },
            ),
          if (selected.pants != null)
            Image.asset(
              'assets/images/${selected.pants!}',
              height: 100,
              errorBuilder: (context, error, stackTrace) {
                return Text('Gambar tidak ditemukan: ${selected.pants}');
              },
            ),
          if (selected.shoes != null)
            Image.asset(
              'assets/images/${selected.shoes!}',
              height: 100,
              errorBuilder: (context, error, stackTrace) {
                return Text('Gambar tidak ditemukan: ${selected.shoes}');
              },
            ),
          if (selected.shirt == null &&
              selected.dress == null &&
              selected.pants == null &&
              selected.shoes == null)
            const Text('Choose your outfit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                )),
        ],
      ),
    );
  }
}
