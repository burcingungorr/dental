import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/services/auth.dart';
import 'pages.dart'; // UserPage sayfasını import ediyoruz
import 'sign.dart';
import 'doctorlogin.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Color signupTextColor = Colors.black;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? errorMesage;

  final _formKey = GlobalKey<FormState>();

  // Kullanıcı giriş fonksiyonu
Future<void> signIn() async {
  if (_formKey.currentState?.validate() ?? false) {
    // Kullanıcı giriş bilgilerini alıyoruz
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      // Firebase giriş işlemi
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Eğer giriş başarılıysa, kullanıcıyı anasayfaya yönlendiriyoruz
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Pages()), // UserPage'e yönlendiriyoruz
      );
    } on FirebaseAuthException catch (e) {
      // Hata durumunda kullanıcıya bildirim gösteriyoruz
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Bu hesap bulunamadı")),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Hatalı e-posta veya şifre")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hatalı e-posta veya şifre")),
        );
      }
    }
  } else {
    // Form geçersizse kullanıcıya uyarı
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lütfen tüm alanları doğru şekilde doldurun")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/login.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
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
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 350),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'E-POSTA',
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.email, color: Colors.black),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'E-posta giriniz';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Geçerli bir e-posta giriniz';
                          }
                          return null;
                        },
                      ),
                      errorMesage != null
                          ? Text(
                              errorMesage!,
                              style: TextStyle(color: Colors.red),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'ŞİFRE',
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.lock, color: Colors.black),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
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
                      errorMesage != null
                          ? Text(
                              errorMesage!,
                              style: TextStyle(color: Colors.red),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          signIn(); // Kullanıcıyı giriş yapmaya yönlendiriyoruz
                        },
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
                      const SizedBox(height: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Hesabın yok mu?",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupScreen(),
                                ),
                              );
                            },
                            onTapDown: (_) {
                              setState(() {
                                signupTextColor = Colors.white;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                signupTextColor = Colors.black;
                              });
                            },
                            child: Text(
                              "KAYIT OL",
                              style: TextStyle(
                                color: signupTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 165),
                      ElevatedButton(
                      onPressed: () {
                        // Doktor girişi için DoctorLoginScreen sayfasına yönlendirme
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorLoginScreen(), // Doktor giriş sayfasına yönlendiriyoruz
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('DOKTOR GİRİŞİ'),
                    ),
                        ],
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
