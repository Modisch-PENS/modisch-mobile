import 'package:flutter/material.dart';
import 'package:modisch/constants/colors.dart';
import 'package:modisch/presentation/widgets/clothing_grid.dart';
import 'package:modisch/services/hive_services.dart';

class TabView extends StatefulWidget {
  const TabView({super.key});

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  final List<String> _category = [
    "Shirt",
    "Pants",
    "Dress",
    "Shoes"
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _category.length, 
      child: Column(
        children: [
          TabBar(
            labelColor: AppColors.tertiary,
            unselectedLabelColor: AppColors.disabled,
            indicatorColor: AppColors.tertiary,
            tabs: _category.map((category) => Tab(text: category)).toList(),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: TabBarView(
              children: _category.map(
                (category) => ClothingGrid(
                  items: HiveServices.getByCategory(category),
                ),
              ).toList(),
            ),
          )
        ],
      )
    );
  }
}