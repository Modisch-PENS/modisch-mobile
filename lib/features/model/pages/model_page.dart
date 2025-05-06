import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:Modisch/core/constants/colors.dart';
import 'package:Modisch/core/constants/typography.dart';
import 'package:Modisch/features/model/providers/outfit_provider.dart';
import 'package:Modisch/features/model/widgets/outfit_card.dart';

class ModelPage extends ConsumerWidget {
  const ModelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outfitsState = ref.watch(outfitNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 1,
        title: Text('Outfits', style: AppTypography.pageTitle(context)),
        centerTitle: true,
      ),
      body: outfitsState.when(
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: AppColors.tertiary),
            ),
        error:
            (error, stackTrace) => Center(
              child: Text(
                'Error loading outfits: ${error.toString()}',
                style: AppTypography.errorText(context),
                textAlign: TextAlign.center,
              ),
            ),
        data:
            (outfits) =>
                outfits.isEmpty
                    ? _buildEmptyState(context)
                    : Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75, // Portrait cards
                            ),
                        itemCount: outfits.length,
                        itemBuilder: (context, index) {
                          final outfit = outfits[index];
                          return OutfitCard(
                            outfit: outfit,
                            onEdit: () {
                              // Navigate to editor with outfit ID
                              context.push('/outfit_editor/${outfit.id}');
                            },
                          );
                        },
                      ),
                    ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.checkroom, size: 64, color: AppColors.disabled),
          const SizedBox(height: 16),
          Text(
            'No outfits yet',
            style: AppTypography.pageTitle(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first outfit by tapping the + button',
            style: TextStyle(color: AppColors.disabled),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tertiary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onPressed: () {
              context.push('/outfit_editor');
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Create Outfit',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
