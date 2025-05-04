import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MakeModelPage extends StatefulWidget {
  const MakeModelPage({Key? key}) : super(key: key);

  @override
  State<MakeModelPage> createState() => _MakeModelPageState();
}

class _MakeModelPageState extends State<MakeModelPage> {
  File? _selectedImage;
  final List<String> _categories = ['Shirt', 'Pants', 'Dress', 'Shoes'];
  int _currentTabIndex = 0;
  Map<String, List<String>> _categoryImages = {
    'Shirt': [],
    'Pants': [],
    'Dress': [],
    'Shoes': [],
  };

  @override
  void initState() {
    super.initState();
    _loadCategoryImages();
  }

  Future<void> _loadCategoryImages() async {
    final prefs = await SharedPreferences.getInstance();

    for (String category in _categories) {
      final jsonList = prefs.getStringList('items_$category') ?? [];

      final paths = jsonList.map((e) {
        try {
          final decoded = jsonDecode(e);
          if (decoded is Map && decoded.containsKey('path')) {
            return decoded['path'] as String;
          }
        } catch (_) {}
        return null;
      }).whereType<String>().toList();

      setState(() {
        _categoryImages[category] = paths;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });

      final prefs = await SharedPreferences.getInstance();
      final category = _categories[_currentTabIndex];

      final newItem = jsonEncode({
        'path': picked.path,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      List<String> items = prefs.getStringList('items_$category') ?? [];
      items.add(newItem);
      await prefs.setStringList('items_$category', items);

      await _loadCategoryImages();
    }
  }

  void _saveData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = _categories[_currentTabIndex];
    final images = _categoryImages[selectedCategory]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Model'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _pickImage,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Gambar utama yang baru dipilih
              Container(
                width: double.infinity,
                height: 420,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.black45),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _selectedImage != null
                    ? Image.file(_selectedImage!, fit: BoxFit.cover)
                    : const Center(child: Text('Tap + to add image')),
              ),
              const SizedBox(height: 20),

              // Tombol Save
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Tab kategori
              DefaultTabController(
                length: _categories.length,
                initialIndex: _currentTabIndex,
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: Colors.blue,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.black54,
                      onTap: (index) {
                        setState(() => _currentTabIndex = index);
                      },
                      tabs: _categories.map((c) => Tab(text: c)).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // Semua gambar dalam kategori
              if (images.isNotEmpty)
                SizedBox(
                  height: 160,
                  child: GridView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 1,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final imagePath = images[index];
                      return Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black26),
                        ),
                        child: File(imagePath).existsSync()
                            ? Image.file(File(imagePath), fit: BoxFit.cover)
                            : const Center(child: Icon(Icons.broken_image)),
                      );
                    },
                  ),
                )
              else
                const Text('No images found'),
            ],
          ),
        ),
      ),
    );
  }
}
