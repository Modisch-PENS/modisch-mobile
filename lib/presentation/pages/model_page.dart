import 'package:flutter/material.dart';

class ModelPage extends StatefulWidget {
  const ModelPage({super.key});

  @override
  _ModelPage createState() => _ModelPage();
}

class _ModelPage extends State<ModelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Model Page'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Model Page!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}