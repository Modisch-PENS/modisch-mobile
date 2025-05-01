import 'dart:io';
import 'package:flutter/material.dart';
import 'package:modisch/constants/colors.dart';

class ConfirmClothesPage extends StatefulWidget {
  final String imagePath;
  final void Function(String category, String name) onSave;

  const ConfirmClothesPage({
    Key? key,
    required this.imagePath,
    required this.onSave,
  }) : super(key: key);

  @override
  _ConfirmClothesPageState createState() => _ConfirmClothesPageState();
}

class _ConfirmClothesPageState extends State<ConfirmClothesPage> {
  String _selectedCategory = 'Shirt';
  String _clothesName = '';
  final List<String> _categories = ['Shirt', 'Pants', 'Dress', 'Shoes'];
  final TextEditingController _nameController = TextEditingController();

  bool _fileExists = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkFileExistence();
  }

  Future<void> _checkFileExistence() async {
    final exists = await File(widget.imagePath).exists();
    if (mounted) {
      setState(() {
        _fileExists = exists;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Confirm Your Clothes',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : !_fileExists
              ? const Center(
                  child: Text(
                    '❌ File tidak ditemukan',
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            File(widget.imagePath),
                            height: 280,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter clothes name',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _clothesName = value.trim();
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: _categories.map((category) {
                            final isSelected = category == _selectedCategory;
                            return ChoiceChip(
                              label: Text(category),
                              selected: isSelected,
                              onSelected: (_) {
                                setState(() {
                                  _selectedCategory = category;
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _clothesName.isNotEmpty
                                ? () {
                                    widget.onSave(
                                      _selectedCategory,
                                      _clothesName,
                                    );
                                    Navigator.pop(context);
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
