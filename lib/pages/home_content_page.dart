import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modisch/constants/colors.dart';
import 'package:modisch/constants/typography.dart';

class HomeContentPage extends StatefulWidget {
  const HomeContentPage({Key? key}) : super(key: key);

  @override
  _HomeContentPageState createState() => _HomeContentPageState();
}

class _HomeContentPageState extends State<HomeContentPage> with RouteAware {
  List<String> _recentImages = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRecentImages();
  }

  // Load images from SharedPreferences asynchronously
  Future<void> _loadRecentImages() async {
    final prefs = await SharedPreferences.getInstance();
    final categories = ['Shirt', 'Pants', 'Dress', 'Shoes'];
    List<String> allImagePaths = [];

    for (String category in categories) {
      final jsonItems = prefs.getStringList('items_$category') ?? [];
      for (final jsonItem in jsonItems) {
        try {
          final itemMap = jsonDecode(jsonItem);
          if (itemMap is Map && itemMap.containsKey('path')) {
            allImagePaths.add(itemMap['path']);
          }
        } catch (e) {
          print("Error decoding JSON for $category: $e");
          continue; // Skip invalid JSON entries
        }
      }
    }

    // Sort by filename assuming it's timestamp.jpg (e.g., 1682550193581.jpg)
    allImagePaths.sort((a, b) {
      int aTime = int.tryParse(a.split('/').last.split('.').first) ?? 0;
      int bTime = int.tryParse(b.split('/').last.split('.').first) ?? 0;
      return bTime.compareTo(aTime);
    });

    // Filter out non-existent files asynchronously
    List<String> validImagePaths = [];
    for (var path in allImagePaths) {
      final file = File(path);
      if (await file.exists()) {
        validImagePaths.add(path);
      }
    }

    // Update UI with valid image paths
    setState(() {
      _recentImages = validImagePaths.take(5).toList();
    });
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _loadRecentImages(); // Reload images when returning to this page
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose TextEditingController to prevent memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Hi, User!', style: AppTypography.pageTitle.copyWith(fontSize: 30)),
                  const Icon(Icons.account_circle, size: 50),
                ],
              ),
              const SizedBox(height: 20),

              // Search Bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for clothes...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),

              // Banner
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'DECIDE WHAT YOU WANNA WEAR TODAY!',
                          style: AppTypography.pageTitle.copyWith(fontSize: 16),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset(
                        'assets/images/aldino.jpg',
                        width: 150,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Recent Clothes
              Text('Recent Clothes', style: AppTypography.pageTitle),
              const SizedBox(height: 10),

              SizedBox(
                height: 145,
                child: _recentImages.isNotEmpty
                    ? ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _recentImages.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final file = File(_recentImages[index]);
                          return Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: file.existsSync()
                                  ? Image.file(
                                      file,
                                      fit: BoxFit.cover,
                                    )
                                  : const Center(child: Icon(Icons.broken_image)),
                            ),
                          );
                        },
                      )
                    : const Center(child: Text('No images found')),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
