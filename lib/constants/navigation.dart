import 'package:flutter/material.dart';
import 'package:modisch/constants/colors.dart';

class NavigationItem {
  final String label;
  final IconData icon;
  const NavigationItem({required this.icon, required this.label});
}

class AppNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<NavigationItem> _items = [
    NavigationItem(icon: Icons.home, label: 'Home'),
    NavigationItem(icon: Icons.dashboard_outlined, label: 'Wardrobe'),
    NavigationItem(icon: Icons.checkroom, label: 'Models'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = index == currentIndex;

              return InkWell(
                onTap: () => onTap(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      color:
                          isSelected ? AppColors.secondary : AppColors.disabled,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            isSelected
                                ? AppColors.secondary
                                : AppColors.disabled,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
