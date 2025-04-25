import 'package:flutter/material.dart';

class MakeModelPage extends StatefulWidget {
  const MakeModelPage({super.key});

  @override
  _MakeModelPage createState() => _MakeModelPage();
}

class _MakeModelPage extends State<MakeModelPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Model'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Make Model Page!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}