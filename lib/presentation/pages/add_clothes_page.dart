import 'package:flutter/material.dart';

class AddClothesPage extends StatefulWidget {
  const AddClothesPage({super.key});

  @override
  _AddClothesPage createState() => _AddClothesPage();
}

class _AddClothesPage extends State<AddClothesPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Clothes'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Add Clothes Page!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}