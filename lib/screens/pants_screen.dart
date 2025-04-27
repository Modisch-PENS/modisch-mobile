import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/model/selected_model.dart';
import '/widgets/item_card.dart';

class PantsScreen extends StatelessWidget {
  const PantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void select(String? img) {
      Provider.of<SelectedModel>(context, listen: false).selectPants(img);
    }

    return GridView.count(
      crossAxisCount: 2,
      children: [
        // Item None
        ItemCard(
          image: 'assets/images/pants0.png',
          onTap: () => select(null),
        ),
        ItemCard(image: 'assets/images/pants1.png', onTap: () => select('pants1.png')),
        ItemCard(image: 'assets/images/pants2.png', onTap: () => select('pants2.png')),
        ItemCard(image: 'assets/images/pants3.png', onTap: () => select('pants3.png')),
        ItemCard(image: 'assets/images/pants4.png', onTap: () => select('pants4.png')),
        ItemCard(image: 'assets/images/pants5.png', onTap: () => select('pants5.png')),
        ItemCard(image: 'assets/images/pants6.png', onTap: () => select('pants6.png')),
        ItemCard(image: 'assets/images/pants7.png', onTap: () => select('pants7.png')),
        ItemCard(image: 'assets/images/pants8.png', onTap: () => select('pants8.png')),
        ItemCard(image: 'assets/images/pants9.png', onTap: () => select('pants9.png')),
      ],
    );
  }
}
