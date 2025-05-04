import 'package:modisch/core/constants/typography.dart';
import 'package:modisch/core/constants/colors.dart';
import 'package:modisch/core/constants/spacing.dart';
import 'package:flutter/material.dart';

class RecentInfo extends StatelessWidget {
  final String title;
  final List<String> imageAssets;

  const RecentInfo({super.key, required this.title, required this.imageAssets});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Recent $title',
              style: AppTypography.recentInfoLabel(context),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        verticalSpace(16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              horizontalSpace(24),
              ...imageAssets.asMap().entries.map((entry) {
                final isLast = entry.key == imageAssets.length - 1;
                return Padding(
                  padding: EdgeInsets.only(right: isLast ? 0 : 16),
                  child: _ListItem(
                    imagePath: imageAssets[entry.key],
                    itemName: _getItemName(imageAssets[entry.key]),
                  ),
                );
              }),
              horizontalSpace(24),
            ],
          ),
        ),
        // HorizontalScrollView.builder(
        //   itemWidth: 125, // Width matching the image width
        //   crossAxisSpacing: 16, // Spacing between items in the same row.
        //   alignment:
        //       CrossAxisAlignment.center, // Alignment of items within the row
        //   itemCount: imageAssets.length, // Total number of items in the list.
        //   itemBuilder: (BuildContext context, int index) {
        //     return _ListItem(
        //       imagePath: imageAssets[index],
        //       itemName: _getItemName(imageAssets[index]),
        //     );
        //   },
        // ),
        // Kosongan ///
        // Row(
        //   children: [
        //     Container(
        //       decoration: BoxDecoration(
        //         color: AppColors.background,
        //         borderRadius: BorderRadius.circular(20),
        //         border: Border.all(color: AppColors.disabled, width: 1),
        //       ),
        //       child: SizedBox(
        //         height: 125,
        //         width: 125,
        //         child: Padding(
        //           padding: EdgeInsets.all(16),
        //           child: Center(
        //             child: Text(
        //               'No $title added yet',
        //               style: TextStyle(color: AppColors.disabled),
        //               textAlign: TextAlign.center,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  // Helper method to extract item name from file path
  String _getItemName(String path) {
    // Extract filename from path and remove extension
    String fileName = path.split('/').last;
    // Remove extension
    String nameWithoutExtension = fileName.split('.').first;
    // Replace underscores with spaces and capitalize each word
    List<String> words = nameWithoutExtension.split('_');
    if (words.length >= 2) {
      // Skip the first word if it's "shirt" to get only the color/style
      String colorOrStyle = words.sublist(1).join(' ');
      return '${words[0]} ${colorOrStyle}'.trim();
    }
    return nameWithoutExtension.replaceAll('_', ' ');
  }
}

class _ListItem extends StatelessWidget {
  final String imagePath;
  final String itemName;

  const _ListItem({super.key, required this.imagePath, required this.itemName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.disabled, width: 1),
          ),
          child: SizedBox(
            height: 125,
            width: 125,

            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 2),
        SizedBox(
          width:
              125, // Match the image width instead of using ratio calculation
          child: Text(
            itemName,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: AppTypography.cardLabel(context),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
