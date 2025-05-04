import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modisch/core/constants/colors.dart';
import 'package:modisch/core/constants/typography.dart';
import 'package:modisch/features/wardrobe/riverpod/wardrobe_provider.dart';

class WardrobePage extends ConsumerStatefulWidget {
  const WardrobePage({Key? key}) : super(key: key);

  @override
  ConsumerState<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends ConsumerState<WardrobePage>
    with AutomaticKeepAliveClientMixin {
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
          loading:
              () => const Center(
                child: CircularProgressIndicator(color: AppColors.tertiary),
              ),
          error:
              (error, stackTrace) => Center(
                child: Text(
                  'Error loading wardrobe: ${error.toString()}',
                  style: AppTypography.cardLabel(context),
                  textAlign: TextAlign.center,
                ),
              ),
          data:
              (allItems) => TabBarView(
                children:
                    _categories.map((category) {
                      // Use the filtered clothing provider for this category
                      return Consumer(
                        builder: (context, ref, _) {
                          final items = ref.watch(
                            clothingByCategoryProvider(category),
                          );

                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child:
                                items.isEmpty
                                    ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            _getCategoryIcon(category),
                                            size: 64,
                                            color: AppColors.disabled
                                                .withOpacity(0.5),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'No ${category.toLowerCase()} items yet',
                                            style: AppTypography.recentInfoLabel(context),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Tap + to add your first ${category.toLowerCase()}',
                                            style: AppTypography.inputTextPlaceholder(context),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    )
                                    : LayoutBuilder(
                                      builder: (ctx, constraints) {
                                        final crossCount = (constraints
                                                    .maxWidth /
                                                (boxWidth + 16))
                                            .floor()
                                            .clamp(1, 4);

                                        return GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: crossCount,
                                                crossAxisSpacing: 16,
                                                mainAxisSpacing: 16,
                                                childAspectRatio:
                                                    boxWidth / boxHeight,
                                              ),
                                          itemCount: items.length,
                                          itemBuilder: (_, idx) {
                                            final item = items[idx];
                                            return Dismissible(
                                              key: Key(item.id),
                                              direction:
                                                  DismissDirection.endToStart,
                                              background: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                padding: const EdgeInsets.only(
                                                  right: 20,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: const Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              confirmDismiss: (
                                                direction,
                                              ) async {
                                                return await showDialog(
                                                  context: context,
                                                  builder: (
                                                    BuildContext context,
                                                  ) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        "Confirm Delete",
                                                      ),
                                                      content: Text(
                                                        "Are you sure you want to delete '${item.name}'?",
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed:
                                                              () =>
                                                                  Navigator.of(
                                                                    context,
                                                                  ).pop(false),
                                                          child: const Text(
                                                            "Cancel",
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed:
                                                              () =>
                                                                  Navigator.of(
                                                                    context,
                                                                  ).pop(true),
                                                          child: const Text(
                                                            "Delete",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              onDismissed: (_) {
                                                ref
                                                    .read(
                                                      wardrobeNotifierProvider
                                                          .notifier,
                                                    )
                                                    .deleteClothingItem(
                                                      item.id,
                                                    );
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      '${item.name} deleted',
                                                    ),
                                                    action: SnackBarAction(
                                                      label: 'Undo',
                                                      onPressed: () {
                                                        ref
                                                            .read(
                                                              wardrobeNotifierProvider
                                                                  .notifier,
                                                            )
                                                            .addClothingItem(
                                                              id: item.id,
                                                              category:
                                                                  item.category,
                                                              imagePath:
                                                                  item.imagePath,
                                                              name: item.name,
                                                            );
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: AppColors.disabled,
                                                      blurRadius: 5,
                                                      offset: const Offset(
                                                        0,
                                                        3,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius.vertical(
                                                              top:
                                                                  Radius.circular(
                                                                    16,
                                                                  ),
                                                            ),
                                                        child: Image.file(
                                                          File(item.imagePath),
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) {
                                                            return Container(
                                                              color: AppColors
                                                                  .disabled
                                                                  .withOpacity(
                                                                    0.2,
                                                                  ),
                                                              child: const Center(
                                                                child: Icon(
                                                                  Icons
                                                                      .broken_image,
                                                                  color:
                                                                      AppColors
                                                                          .disabled,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 8,
                                                            horizontal: 8,
                                                          ),
                                                      child: Text(
                                                        item.name,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            AppTypography
                                                                .cardLabel(context),
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
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

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Shirt':
        return Icons.checkroom;
      case 'Pants':
        return Icons.border_color;
      case 'Dress':
        return Icons.accessibility_new;
      case 'Shoes':
        return Icons.hiking;
      default:
        return Icons.checkroom;
    }
  }
}
