import 'package:flutter/material.dart';

class HastaliklarimPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hastalıklarım'),
        backgroundColor: Colors.blue, // App bar rengi koyu gri
      ),
      backgroundColor: const Color.fromARGB(255, 245, 245, 245), // Koyu beyaz arka plan rengi
      body: const Center(child: Text('Hastalıklarım Sayfası')),
    );
  }
}
