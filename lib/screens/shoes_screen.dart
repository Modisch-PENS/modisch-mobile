import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/model/selected_model.dart';
import '/widgets/item_card.dart';

class ShoesScreen extends StatelessWidget {
  const ShoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void select(String? img) {
      Provider.of<SelectedModel>(context, listen: false).selectShoes(img);
    }

    return GridView.count(
      crossAxisCount: 2,
      children: [
        ItemCard(
          // image: 'assets/images/none.png',
          image: ' ',
          onTap: () => select(null),
        ),
        ItemCard(image: 'assets/images/shoes1.png', onTap: () => select('shoes1.png')),
        ItemCard(image: 'assets/images/shoes2.png', onTap: () => select('shoes2.png')),
        ItemCard(image: 'assets/images/shoes3.png', onTap: () => select('shoes3.png')),
        ItemCard(image: 'assets/images/shoes4.png', onTap: () => select('shoes4.png')),
        ItemCard(image: 'assets/images/shoes5.png', onTap: () => select('shoes5.png')),
        ItemCard(image: 'assets/images/shoes6.png', onTap: () => select('shoes6.png')),
        ItemCard(image: 'assets/images/shoes7.png', onTap: () => select('shoes7.png')),
        ItemCard(image: 'assets/images/shoes8.png', onTap: () => select('shoes8.png')),
        ItemCard(image: 'assets/images/shoes9.png', onTap: () => select('shoes9.png')),
      ],
    );
  }
}
