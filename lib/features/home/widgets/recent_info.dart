import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'recent_wardrobe.dart';
import 'recent_model.dart';

/// Main widget that decides whether to show recent clothes or outfits
class RecentInfo extends ConsumerWidget {
  final String type; // 'clothes' or 'model'
  final int itemCount; // Number of items to display

  const RecentInfo({
    super.key,
    required this.type,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Based on type, we'll either get recent clothing or outfit items
    if (type.toLowerCase() == 'clothes') {
      return RecentWardrobeWidget(itemCount: itemCount);
    } else if (type.toLowerCase() == 'model' || type.toLowerCase() == 'outfit') {
      return RecentModelWidget(itemCount: itemCount);
    } else {
      return const SizedBox.shrink();
    }
  }
}