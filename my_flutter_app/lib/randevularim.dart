import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RandevularimPage extends StatelessWidget {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<List<Map<String, dynamic>>> fetchAppointments() async {
    if (currentUser == null) {
      return [];
    }

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('appointment')
        .get();

    // Verileri map'e çeviriyoruz
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Randevularım'),
        backgroundColor: Colors.blue, // App bar rengi
      ),
      backgroundColor: const Color.fromARGB(255, 245, 245, 245), // Koyu beyaz arka plan rengi
      body: currentUser == null
          ? Center(child: Text('Oturum açmamış kullanıcı'))
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchAppointments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Bir hata oluştu'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Henüz randevunuz yok'));
                }

                return ListView(
                  children: snapshot.data!.map((data) {
                    // Randevu detaylarını alıyoruz
                    String doctor = data['doctor'] ?? 'Bilinmiyor';
                    String date = data['date'] ?? 'Tarih yok';
                    String description = data['description'] ?? 'Açıklama yok';
                    String result = data['result'] ?? 'Sonuç yok';

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text('Doktor: $doctor'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tarih: $date'),
                            Text('Açıklama: $description'),
                            Text('Sonuç: $result'),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
    );
  }
}
