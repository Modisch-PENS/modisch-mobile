import 'package:flutter/material.dart';
import 'package:modisch/constants/colors.dart';
import 'package:modisch/constants/typography.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            'Hello user',
            style: AppTypography.pageTitle(context)
          ),
        ),
        actions: [
           Padding(
              padding: const EdgeInsets.only(right: 24),
              child: CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ]
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.disabled,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Himit Outfit',
                        hintStyle: TextStyle(color: AppColors.secondary),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.menu, color: AppColors.secondary),
                        suffixIcon: Icon(Icons.search, color: AppColors.secondary),
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24), 
              Container(
                color: AppColors.disabled,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'DECIDE WHAT\nYOU WANNA\nWEAR TODAY!',
                        style: AppTypography.inputTextPlaceholder(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Image.asset(
                        'assets/clothes/shirt/shirt_jaslab.png',
                        height: MediaQuery.of(context).size.width * 0.4,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Recent Clothes',
                style: AppTypography.buttonLabel(context),
              ),
              SizedBox(height: 16),
              buildShortcutButton(),
              SizedBox(height: 24),
              Text(
                'Recent Clothes',
                style: AppTypography.buttonLabel(context),
              ),
              SizedBox(height: 16),
              buildShortcutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Container buildShortcutButton() {
    return Container(
            height: 125,
            width: 125,
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