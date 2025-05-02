import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:modisch/core/constants/colors.dart';
import 'package:modisch/core/constants/typography.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
];

class CarouselContainer extends StatelessWidget {
  const CarouselContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 2.0,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
        autoPlay: true,
      ),
      items: _buildImageSliders(context),
    );
  }
}

List<Widget> _buildImageSliders(BuildContext context) {
  return imgList.map((item) {
    final index = imgList.indexOf(item);

    return Container(
      margin: const EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: [
            Image.network(item, fit: BoxFit.cover, width: 1000.0),

            // NOTE: if there any overlay for the slideshow, edit this widget
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: _buildGradientOverlay(context, index),
            ),
          ],
        ),
      ),
    );
  }).toList();
}

Widget _buildGradientOverlay(BuildContext context, int index) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ),
    ),
    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    child: Text(
      'No. $index image',
      style: AppTypography.pageTitle(
        context,
      ).copyWith(color: AppColors.tertiary),
    ),
  );
}

// final List<Widget> imageSliders =
//     imgList
//         .map(
//           (item) => Container(
//             margin: EdgeInsets.all(5.0),
//             child: ClipRRect(
//               borderRadius: BorderRadius.all(Radius.circular(5.0)),
//               child: Stack(
//                 children: <Widget>[
//                   Image.network(item, fit: BoxFit.cover, width: 1000.0),
//                   Positioned(
//                     bottom: 0.0,
//                     left: 0.0,
//                     right: 0.0,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Color.fromARGB(200, 0, 0, 0),
//                             Color.fromARGB(0, 0, 0, 0),
//                           ],
//                           begin: Alignment.bottomCenter,
//                           end: Alignment.topCenter,
//                         ),
//                       ),
//                       padding: EdgeInsets.symmetric(
//                         vertical: 10.0,
//                         horizontal: 20.0,
//                       ),
//                       child: Text(
//                         'No. ${imgList.indexOf(item)} image',
//                         style: AppTypography.buttonLabel(),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         )
//         .toList();
