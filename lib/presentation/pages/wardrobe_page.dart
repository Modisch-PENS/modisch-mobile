import 'package:flutter/material.dart';
import 'package:modisch/models/wardrobe_item.dart';
import 'dart:math';
import '../../services/wardrobe_service.dart';
import '../widgets/wardrobe_card.dart';
import '../../constants/typography.dart';
import '../../constants/colors.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({super.key});

  @override
  _WardrobePageState createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  late Future<List<WardrobeItem>> _wardrobeItems;

  @override
  void initState() {
    super.initState();
    _wardrobeItems = WardrobeService.loadWardrobeItems();
  }

  Widget _buildWardrobeGrid(List<WardrobeItem> items) {
    final crossAxisCount = (MediaQuery.of(context).size.width / 180)
        .floor()
        .clamp(2, 4);
    final itemCount = min(
      items.length,
      crossAxisCount * 2,
    ); // Exactly 2 rows worth of items

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return WardrobeCard(item: items[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Wardrobe', style: AppTypography.pageTitle(context)),
          backgroundColor: AppColors.background,
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Shirt'),
              Tab(text: 'Pants'),
              Tab(text: 'Shoes'),
              Tab(text: 'Dress'),
            ],
            labelColor: AppColors.secondary,
            unselectedLabelColor: AppColors.disabled,
          ),
        ),
        body: FutureBuilder<List<WardrobeItem>>(
          future: _wardrobeItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error loading wardrobe: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No items found'));
            }

            final items = snapshot.data!;
            return TabBarView(
              children: [
                SingleChildScrollView(
                  child: _buildWardrobeGrid(
                    items.where((item) => item.type == 'shirt').toList(),
                  ),
                ),
                SingleChildScrollView(
                  child: _buildWardrobeGrid(
                    items.where((item) => item.type == 'pants').toList(),
                  ),
                ),
                SingleChildScrollView(
                  child: _buildWardrobeGrid(
                    items.where((item) => item.type == 'shoes').toList(),
                  ),
                ),
                SingleChildScrollView(
                  child: _buildWardrobeGrid(
                    items.where((item) => item.type == 'dress').toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
