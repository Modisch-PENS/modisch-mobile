import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/model/selected_model.dart';
import '/widgets/item_card.dart';

class ShirtScreen extends StatelessWidget {
  const ShirtScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selected = Provider.of<SelectedModel>(context);

    void select(String? img) {
      final alert = selected.validateTopSelection(target: 'shirt');
      if (alert != null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Peringatan'),
            content: Text(alert),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
        return;
      }

      Provider.of<SelectedModel>(context, listen: false).selectShirt(img);
    }

    return GridView.count(
      crossAxisCount: 2,
      children: [
        // None
        ItemCard(
          // image: 'assets/images/none.png',
          image: ' ',
          onTap: () => select(null),
        ),
        ItemCard(image: 'assets/images/shirt1.png', onTap: () => select('shirt1.png')),
        ItemCard(image: 'assets/images/shirt2.png', onTap: () => select('shirt2.png')),
        ItemCard(image: 'assets/images/shirt3.png', onTap: () => select('shirt3.png')),
        ItemCard(image: 'assets/images/shirt4.png', onTap: () => select('shirt4.png')),
        ItemCard(image: 'assets/images/shirt5.png', onTap: () => select('shirt5.png')),
        ItemCard(image: 'assets/images/shirt6.png', onTap: () => select('shirt6.png')),
        ItemCard(image: 'assets/images/shirt7.png', onTap: () => select('shirt7.png')),
      ],
    );
  }
}
