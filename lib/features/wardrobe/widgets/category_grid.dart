import 'package:flutter/material.dart';
import 'package:Modisch/core/database/models/wardrobe_database.dart';
import 'clothing_grid_item.dart';

class CategoryGrid extends StatelessWidget {
  final List<ClothingModel> items;
  final double boxWidth;
  final double boxHeight;

  const CategoryGrid({
    super.key,
    required this.items,
    required this.boxWidth,
    required this.boxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final crossCount = (constraints.maxWidth / (boxWidth + 16))
            .floor()
            .clamp(1, 4);

        return items.isEmpty
            ? Center(
              child: Text(
                'No items yet. Add your first item with the + button!',
                textAlign: TextAlign.center,
              ),
            )
            : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: boxWidth / boxHeight,
              ),
              itemCount: items.length,
              itemBuilder: (_, idx) {
                return ClothingGridItem(
                  item: items[idx],
                  width: boxWidth,
                  height: boxHeight,
                );
              },
            );
      },
    );
  }
}
