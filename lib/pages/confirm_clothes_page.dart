import 'dart:io';
import 'package:flutter/material.dart';
import 'package:modisch/constants/colors.dart';

class ConfirmClothesPage extends StatefulWidget {
  final String imagePath;
  final Function(String, String) onCategorySelected;

  const ConfirmClothesPage({
    Key? key,
    required this.imagePath,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  State<ConfirmClothesPage> createState() => _ConfirmClothesPageState();
}

class _ConfirmClothesPageState extends State<ConfirmClothesPage> {
  String _selectedCategory = 'Shirt';
  String _clothesName = '';
  final List<String> _categories = ['Shirt', 'Pants', 'Dress', 'Shoes'];
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final file = File(widget.imagePath);
    final fileExists = file.existsSync();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Confirm Your Clothes',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[100],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: fileExists
                        ? Image.file(file, fit: BoxFit.cover)
                        : const Center(
                            child: Text(
                              "❌ Gagal memuat gambar. File tidak ditemukan.",
                              style: TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter clothes name',
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _clothesName = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: _categories.map((category) {
                      return categoryButton(category, _selectedCategory == category);
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_clothesName.isNotEmpty) {
                          if (fileExists) {
                            widget.onCategorySelected(_selectedCategory, _clothesName);
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Gambar tidak ditemukan. Tidak bisa menyimpan.'),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a name for the clothes'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget categoryButton(String text, bool isSelected) {
    return SizedBox(
      width: 140,
      height: 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? Colors.black87 : AppColors.background,
          side: BorderSide(color: AppColors.disabled),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          setState(() {
            _selectedCategory = text;
          });
        },
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? AppColors.background : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
