import 'package:flutter/material.dart';
import 'package:Modisch/core/constants/colors.dart';

class SearchBarComponent extends StatelessWidget {
  const SearchBarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SearchBar(
        leading: Icon(
          Icons.menu,
          // color: AppColors.secondary.withValues(alpha :0.4),
          color: AppColors.searchBarComponents,
        ),
        hintText: 'Himit Outfit',
        hintStyle: WidgetStatePropertyAll(
          TextStyle(color: AppColors.searchBarComponents),
        ),
        trailing: [Icon(Icons.search, color: AppColors.searchBarComponents)],
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
        backgroundColor: WidgetStatePropertyAll(
          AppColors.disabled.withValues(alpha: 0.4),
        ),
        elevation: const WidgetStatePropertyAll(0),
        onTap: () {},
      ),
    );
  }
}
