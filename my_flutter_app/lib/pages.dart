import 'package:flutter/material.dart';
import 'dental.dart';
import 'user.dart';
import 'doctors.dart';

class Pages extends StatefulWidget {
  @override
  _PagesState createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  int _seciliSayfa = 1;
  final List<Widget> _sayfalar = [DentalPage(), UserPage(), DoctorsPage()];

  void _sayfaDegistir(int index) {
    setState(() {
      _seciliSayfa = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan resmi
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/background.png', 
              fit: BoxFit.cover,
            ),
          ),
          // Sayfa içeriği
          _sayfalar[_seciliSayfa],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _seciliSayfa,
        onTap: _sayfaDegistir,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white, 
        unselectedItemColor: Colors.white70, 
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_emoticon ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: '',
          ),
        ],
      ),
    );
  }
}
