import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/selected_model.dart';
import 'item_card.dart';

class PreviewSelectScreen extends StatelessWidget {
  final String category;

  const PreviewSelectScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    List<String> items = [];

    if (category == 'Shirt') {
      items = [
        'none.png',
        'shirt1.png',
        'shirt2.png',
        'shirt3.png',
        'shirt4.png',
        'shirt5.png',
      ];
    } else if (category == 'Pants') {
      items = [
        'none.png',
        'pants1.png',
        'pants2.png',
        'pants3.png',
        'pants4.png',
        'pants5.png',
      ];
    } else if (category == 'Dress') {
      items = [
        'none.png',
        'dress1.png',
        'dress2.png',
        'dress3.png',
        'dress4.png',
        'dress5.png',
      ];
    } else if (category == 'Shoes') {
      items = [
        'none.png',
        'shoes1.png',
        'shoes2.png',
        'shoes3.png',
        'shoes4.png',
        'shoes5.png',
      ];
    }

    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(12),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: items.map((imgName) {
        bool isNone = imgName.contains('none.png');

        return ItemCard(
          image: 'assets/images/$imgName',
          onTap: () {
            final selected = Provider.of<SelectedModel>(context, listen: false);
            _updateSelected(selected, isNone ? null : imgName);
          },
          draggable: !isNone, 
          dragData: isNone ? null : imgName,
        );
      }).toList(),
    );
  }

  void _updateSelected(SelectedModel selected, String? imgPath) {
  bool isNone = imgPath == null || imgPath.contains('none.png');
  String? selectedImg = isNone ? null : imgPath;

  if (category == 'Shirt') {
    selected.selectShirt(selectedImg);
  } else if (category == 'Pants') {
    selected.selectPants(selectedImg);
  } else if (category == 'Dress') {
    selected.selectDress(selectedImg);
  } else if (category == 'Shoes') {
    selected.selectShoes(selectedImg);
  }
}

}
