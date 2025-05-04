import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/model/selected_model.dart';
import '/widgets/item_card.dart';

class DressScreen extends StatelessWidget {
  const DressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void select(String? img) {
      final model = Provider.of<SelectedModel>(context, listen: false);
      final alert = model.validateTopSelection(target: 'dress');
      if (alert != null) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Peringatan'),
            content: Text(alert),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              )
            ],
          ),
        );
        return;
      }
      model.selectDress(img);
    }

    return GridView.count(
      crossAxisCount: 2,
      children: [
        ItemCard(
          // image: 'assets/images/none.png',
          image: ' ',
          onTap: () => select(null),
        ),
        ItemCard(image: 'assets/images/dress1.png', onTap: () => select('dress1.png')),
        ItemCard(image: 'assets/images/dress2.png', onTap: () => select('dress2.png')),
        ItemCard(image: 'assets/images/dress3.png', onTap: () => select('dress3.png')),
        ItemCard(image: 'assets/images/dress4.png', onTap: () => select('dress4.png')),
        ItemCard(image: 'assets/images/dress5.png', onTap: () => select('dress5.png')),
        ItemCard(image: 'assets/images/dress6.png', onTap: () => select('dress6.png')),
      ],
    );
  }
}
