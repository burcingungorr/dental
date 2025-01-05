import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'hastalar.dart';

class DoctorLoginScreen extends StatefulWidget {
  @override
  _DoctorLoginScreenState createState() => _DoctorLoginScreenState();
}

class _DoctorLoginScreenState extends State<DoctorLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // FirebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Giriş fonksiyonu
  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Firebase Authentication ile kullanıcıyı giriş yapma
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Kullanıcı giriş yaptıysa, Firestore'da doktor bilgilerini kontrol et
        DocumentSnapshot doctorDoc = await _firestore
            .collection('doctors')
            .doc(userCredential.user!.uid) // Giriş yapan doktorun UID'si
            .get();

        if (doctorDoc.exists) {
          // Giriş başarılı ve doktor bilgileri Firestore'da mevcut
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Doktor Girişi Başarılı!")),
          );

          // Başarılı girişten sonra DoctorDashboardScreen'e yönlendirme
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DoctorDashboardScreen()),
          );
        } else {
          // Eğer doktor bilgileri Firestore'da yoksa
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Bu doktor kaydınız bulunmuyor.")),
          );
          // Giriş bilgileri hatalı veya doktor kaydı yok
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bu doktor kaydınız bulunmuyor.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Arka plan görseli
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/login.png"), // Arka plan görseli
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Başlık kısmı
            Positioned(
              top: 70,
              left: 45,
              right: 0,
              child: Text(
                'GİRİŞ',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(2.0, 2.0),
                      blurRadius: 5.0,
                      color: const Color(0x00A3FF).withOpacity(1),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 120,
              left: 45,
              right: 0,
              child: Text(
                'YAP',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(2.0, 2.0),
                      blurRadius: 4.0,
                      color: const Color(0x00A3FF).withOpacity(1),
                    ),
                  ],
                ),
              ),
            ),
            // Form kısmı
            Positioned(
              top: 200, // Formu yukarı kaydırdım
              left: 30,
              right: 30,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 150),

                      // E-posta Alanı
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'E-posta',
                          prefixIcon: Icon(Icons.email, color: Colors.black),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'E-posta giriniz';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Şifre Alanı
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Şifre',
                          prefixIcon: Icon(Icons.lock, color: Colors.black),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Şifre giriniz';
                          }
                          if (value.length < 6) {
                            return 'Şifre en az 6 karakter olmalı';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Giriş Yap Butonu
                      Center(
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            side: const BorderSide(color: Colors.black, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('GİRİŞ'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
