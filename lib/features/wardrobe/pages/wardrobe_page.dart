import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modisch/core/constants/colors.dart';
import 'package:modisch/core/constants/typography.dart';
import 'package:modisch/features/wardrobe/models/wardrobe_item.dart';
import 'package:modisch/features/wardrobe/riverpod/dummy_assets_provider.dart';
import 'package:modisch/features/wardrobe/riverpod/wardrobe_provider.dart';
import 'package:modisch/features/wardrobe/widgets/dummy_clothing_card.dart';
import 'package:modisch/features/wardrobe/widgets/user_clothing_card.dart';

class WardrobePage extends ConsumerStatefulWidget {
  const WardrobePage({super.key});

  @override
  ConsumerState<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends ConsumerState<WardrobePage> with AutomaticKeepAliveClientMixin {
  final double boxWidth = 160;
  final double boxHeight = 184;
  final List<String> _categories = ['Shirt', 'Pants', 'Dress', 'Shoes'];
  int _currentTabIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    // Watch the provider for clothing items
    final clothingState = ref.watch(wardrobeNotifierProvider);
    
    return DefaultTabController(
      length: _categories.length,
      initialIndex: _currentTabIndex,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.primary,
          elevation: 1,
          title: Text('Wardrobe', style: AppTypography.pageTitle(context)),
          bottom: TabBar(
            indicatorColor: AppColors.tertiary,
            labelColor: AppColors.secondary,
            unselectedLabelColor: AppColors.disabled,
            labelStyle: AppTypography.buttonLabel(context),
            unselectedLabelStyle: AppTypography.buttonLabel(context),
            onTap: (i) => setState(() => _currentTabIndex = i),
            tabs: _categories.map((c) => Tab(text: c)).toList(),
          ),
        ),
        body: clothingState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.searchBarComponents),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              'Error loading wardrobe: ${error.toString()}',
              style: AppTypography.errorText(context),
              textAlign: TextAlign.center,
            ),
          ),
          data: (allItems) => TabBarView(
            children: _categories.map((category) {
              // Use the filtered clothing provider for this category
              return Consumer(
                builder: (context, ref, _) {
                  final userItems = ref.watch(clothingByCategoryProvider(category));
                  final dummyAssets = ref.watch(dummyAssetsByCategoryProvider(category));
                  
                  // Create a combined list of user items followed by dummy items
                  final List<WardrobeItem> combinedItems = [
                    // Add user items first
                    ...userItems.map((item) => WardrobeItem.fromUserItem(item)),
                    // Add dummy items
                    ...dummyAssets.map((asset) => WardrobeItem.fromDummyAsset(asset)),
                  ];
                  
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: LayoutBuilder(
                      builder: (ctx, constraints) {
                        final crossCount = (constraints.maxWidth / (boxWidth + 16))
                            .floor()
                            .clamp(1, 4);
                                
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossCount,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: boxWidth / boxHeight,
                          ),
                          itemCount: combinedItems.length,
                          itemBuilder: (_, idx) {
                            final item = combinedItems[idx];
                            
                            // Build different widgets based on whether it's a user item or dummy item
                            if (item.isUserItem) {
                              return UserClothingCard(clothing: item.clothingModel!);
                            } else {
                              return DummyClothingCard(assetPath: item.dummyAssetPath!);
                            }
                          },
                        );
                      },
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}