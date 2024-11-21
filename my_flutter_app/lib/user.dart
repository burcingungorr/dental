import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'hastaliklarim.dart';
import 'randevularim.dart';
import 'hakkimizda.dart';
import 'tedavilerim.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String? userName = ''; // Başlangıçta kullanıcı adı boş olacak

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  // Firebase'den kullanıcı adı al
  Future<void> _getUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      // Kullanıcı oturum açmış mı kontrol edelim
      if (user == null) {
        print("Oturum açmış kullanıcı bulunamadı.");
        return;
      }

      // Firestore'dan ilgili belgeyi (uid ile) alıyoruz
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();

      // Eğer belge mevcutsa name alanını döndürüyoruz
      if (doc.exists) {
        setState(() {
          userName = doc['name'] as String?;
        });
      } else {
        print("Kullanıcı bilgileri bulunamadı.");
      }
    } catch (e) {
      print("Hata: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.person, size: 40, color: Colors.blue),
            ),
            const SizedBox(height: 10),
            Text(
              userName ?? '', // Firebase'den alınan kullanıcı adı burada görünecek
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Diğer içerikler
            Padding(
              padding: const EdgeInsets.only(left: 45,right: 10,top:50),
              child: Column( 
                children: [
                 Row(
              children: [
                _navigasyonKutusu('Hastalıklarım', Icons.healing, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HastaliklarimPage()),
                  );
                }),
                const SizedBox(width: 20),
                _navigasyonKutusu('Randevularım', Icons.calendar_today, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RandevularimPage()),
                  );
                }),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _navigasyonKutusu('bla bla', Icons.zoom_in, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TedavilerimPage()),
                  );
                }),
                const SizedBox(width: 20),
                _navigasyonKutusu('Hakkımızda', Icons.question_mark, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HakkimizdaPage()),
                 );
                      }),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _navigasyonKutusu(String baslik, IconData ikon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height:150,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(ikon, size: 24, color: Colors.grey.shade700),
            const SizedBox(height: 5),
            Text(baslik, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
