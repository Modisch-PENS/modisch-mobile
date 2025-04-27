import 'package:flutter/material.dart';
import 'package:modisch/core/database/clothing_model.dart';
import 'wardrobe_service.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({super.key});

  @override
  State<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  final WardrobeService _wardrobeService = WardrobeService();
  late List<ClothingModel> _clothingItems = []; // Initialize with empty list

  @override
  void initState() {
    super.initState();
    _loadClothingItems();
  }

  Future<void> _loadClothingItems() async {
    final items = _wardrobeService.getAllClothing();
    setState(() {
      _clothingItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Wardrobe')),
      body: _clothingItems.isEmpty
          ? const Center(child: Text('No items in wardrobe'))
          : ListView.builder(
        itemCount: _clothingItems.length,
        itemBuilder: (context, index) {
          final clothing = _clothingItems[index];
          return ListTile(
            title: Text(clothing.category),
            subtitle: Text(clothing.imagePath),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await _wardrobeService.deleteClothing(clothing);
                _loadClothingItems(); // Reload the wardrobe
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to the Add Clothing page
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}