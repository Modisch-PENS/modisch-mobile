import 'package:flutter/material.dart';
import 'package:modisch/core/constants/colors.dart';
import 'package:modisch/core/constants/typography.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const SizedBox(),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.account_circle, color: AppColors.secondary),
          ),
        ],
        title: Text(
          'Hi, User!',
          style: AppTypography.pageTitle,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Hinted search text',
                prefixIcon: const Icon(Icons.menu),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DECIDE WHAT\nYOU WANNA\nWEAR TODAY!',
                        style: AppTypography.pageTitle.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.tertiary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('TRY NOW!'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://i.imgur.com/fQqC3KE.png',
                      fit: BoxFit.cover,
                      height: 150,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, size: 8, color: Colors.grey),
                SizedBox(width: 4),
                Icon(Icons.circle_outlined, size: 8, color: Colors.grey),
                SizedBox(width: 4),
                Icon(Icons.circle_outlined, size: 8, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 24),
            Text('Recent Models', style: AppTypography.pageTitle.copyWith(fontSize: 16)),
            const SizedBox(height: 8),
            _buildAddCard(),
            const SizedBox(height: 16),
            Text('Recent Clothes', style: AppTypography.pageTitle.copyWith(fontSize: 16)),
            const SizedBox(height: 8),
            _buildAddCard(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.view_module_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.checkroom_outlined), label: ''),
        ],
      ),
    );
  }

  Widget _buildAddCard() {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: const Center(
        child: Icon(Icons.add, size: 32, color: Colors.black),
      ),
    );
  }
}
