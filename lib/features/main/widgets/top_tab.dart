import 'package:flutter/material.dart';

class TopTab extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const TopTab({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    List<String> tabs = ['Shirt', 'Pants', 'Dress', 'Shoes'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(tabs.length, (index) {
        return GestureDetector(
          onTap: () => onTabSelected(index),
          child: Text(
            tabs[index],
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: index == currentIndex
                  ? Colors.black
                  : Colors.black.withOpacity(0.4),
            ),
          ),
        );
      }),
    );
  }
}
