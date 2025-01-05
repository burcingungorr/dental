import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'hastaliklarim.dart';
import 'randevularim.dart';
import 'hakkimizda.dart';
import 'goruntulerim.dart';
import 'login.dart';

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
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();

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

  // Çıkış yap fonksiyonu
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // LoginPage sayfasına yönlendirme
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color.fromARGB(169, 187, 222, 251),
                    child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName ?? '',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  // Navigasyon kutuları
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _navigasyonKutusu('Hastalıklarım', Icons.healing, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HastaliklarimPage()),
                            );
                          }),
                          const SizedBox(width: 20),
                          _navigasyonKutusu('Randevularım',
                              Icons.calendar_today, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RandevularimPage()),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _navigasyonKutusu('Görüntülerim', Icons.zoom_in, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GoruntulerimPage()),
                            );
                          }),
                          const SizedBox(width: 20),
                          _navigasyonKutusu(
                              'Hakkımızda', Icons.question_mark, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HakkimizdaPage()),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 30),
                     // Çıkış Yap Text Butonu
                TextButton(
                  onPressed: _signOut,
                  child: const Text(
                    'Çıkış Yap',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 0, 0, 0), // Metin rengi
                    ),
                  ),
                )


                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _navigasyonKutusu(String baslik, IconData ikon, VoidCallback onTap) {
    return Flexible(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color.fromARGB(255, 0, 0, 0),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(ikon, size: 30, color: const Color.fromARGB(255, 0, 0, 0)),
              const SizedBox(height: 5),
              Text(
                baslik,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
