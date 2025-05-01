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
  double _smallBoxWidth = 150; // Membesarkan ukuran box
  double _smallBoxHeight = 150; // Membesarkan ukuran box
  int _currentTabIndex = 0;

  // Data kategori dan gambar yang disimpan
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

  // Memuat gambar dari SharedPreferences
  Future<void> _loadCategoryImages() async {
    final prefs = await SharedPreferences.getInstance();
    final categories = ['Shirt', 'Pants', 'Dress', 'Shoes'];

    for (String category in categories) {
      final images = prefs.getStringList('images_$category') ?? [];
      setState(() {
        _categoryImages[category] = images;
      });
    }
  }

  // Memilih gambar dan menyimpannya ke SharedPreferences
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });

      // Menyimpan gambar ke SharedPreferences untuk kategori yang dipilih
      final prefs = await SharedPreferences.getInstance();
      final category = _currentTabIndex == 0
          ? 'Shirt'
          : _currentTabIndex == 1
              ? 'Pants'
              : _currentTabIndex == 2
                  ? 'Dress'
                  : 'Shoes';

      List<String> categoryImages = prefs.getStringList('images_$category') ?? [];
      categoryImages.add(picked.path);
      await prefs.setStringList('images_$category', categoryImages);
    }
  }

  // Tombol untuk menyimpan data (opsional)
  void _saveData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Model'),
      ),
      body: SingleChildScrollView( // Menambahkan SingleChildScrollView untuk mengatasi overflow
        child: Column(
          children: [
            // Frame utama untuk menampilkan gambar yang dipilih
            Container(
              width: 348,
              height: 420, // Ukuran tetap
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
              width: 310,
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

            // Tab bar untuk kategori
            DefaultTabController(
              length: 4,
              initialIndex: _currentTabIndex,
              child: Column(
                children: [
                  TabBar(
                    indicatorColor: Colors.blue,
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.black54,
                    onTap: (index) {
                      setState(() {
                        _currentTabIndex = index;
                      });
                    },
                    tabs: const [
                      Tab(text: 'Shirt'),
                      Tab(text: 'Pants'),
                      Tab(text: 'Dress'),
                      Tab(text: 'Shoes'),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Box kecil yang menampilkan gambar pertama dari kategori yang dipilih
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: _smallBoxWidth,
                height: _smallBoxHeight,
                decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black26),
                ),
                child: _categoryImages[_currentTabIndex == 0
                        ? 'Shirt'
                        : _currentTabIndex == 1
                            ? 'Pants'
                            : _currentTabIndex == 2
                                ? 'Dress'
                                : 'Shoes']!
                        .isNotEmpty // Ambil gambar pertama dari kategori yang dipilih
                    ? Image.file(
                        File(_categoryImages[_currentTabIndex == 0
                            ? 'Shirt'
                            : _currentTabIndex == 1
                                ? 'Pants'
                                : _currentTabIndex == 2
                                    ? 'Dress'
                                    : 'Shoes']![0]),
                        fit: BoxFit.cover,
                      )
                    : const Center(child: Text('No Image')), // Jika tidak ada gambar, tampilkan pesan
              ),
            ),

            const SizedBox(height: 20),

            // Tombol untuk memilih gambar
           
          ],
        ),
      ),
    );
  }
}
