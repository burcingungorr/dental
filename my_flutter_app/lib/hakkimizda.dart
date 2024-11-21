import 'package:flutter/material.dart';


class HakkimizdaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hakkımızda'),
        backgroundColor: Colors.blue, // App bar rengi
      ),
      backgroundColor: const Color.fromARGB(255, 245, 245, 245), // Koyu beyaz arka plan rengi
      body: const Center(child: Text('Hakkımızda Sayfası')),
    );
  }
}