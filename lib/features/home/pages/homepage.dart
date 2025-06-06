import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Modisch/core/constants/spacing.dart';
import 'package:Modisch/features/home/widgets/carousel_slides.dart';
import 'package:Modisch/features/home/widgets/homepage_header.dart';
import 'package:Modisch/features/home/widgets/recent_info.dart';
import 'package:Modisch/features/home/widgets/search_bar.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              const HomepageHeader(),
              verticalSpace(24),
              // const SearchBarComponent(),
              // verticalSpace(24),
              const CarouselContainer(),
              verticalSpace(24),
              const RecentInfo(type: 'model',itemCount: 5),
              verticalSpace(24),
              const RecentInfo(type: 'clothes', itemCount: 5),
            ],
          ),
        ),
      ),
    );
  }
}