import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HastaliklarimPage extends StatelessWidget {
  const HastaliklarimPage({Key? key}) : super(key: key);

  /// Firestore'dan hastalık verilerini çekme
  Stream<List<Map<String, dynamic>>> getUserDiseases() {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('dental_results')
        .orderBy('date', descending: true) // `date` alanına göre sıralama
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'id': doc.id, // Belge kimliği
                'diagnosis': data['diagnosis'] ?? 'Bilinmiyor',
                'confidence': data['confidence'] != null 
                    ? '${(data['confidence'] as num).toStringAsFixed(2)}' 
                    : 'Bilinmiyor',
                'recommendedDoctor': data['recommended_doctor'] ?? 'Bilinmiyor',
                'diseaseInfo': data['disease_info'] ?? 'Bilgi mevcut değil',
                'date': (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
              };
            }).toList());
  }

  /// Firestore'dan hastalık kaydını silme
  Future<void> deleteDisease(String diseaseId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('dental_results')
        .doc(diseaseId)
        .delete();
  }

  /// Tarihi okunabilir formata çevirme
  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: const Text(
          'Hastalıklarım',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(
          color: Colors.white, // Geri ok simgesinin rengi
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: StreamBuilder<List<Map<String, dynamic>>>( 
        stream: getUserDiseases(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Henüz bir hastalık kaydınız yok.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final diseases = snapshot.data!;
          return ListView.builder(
            itemCount: diseases.length,
            itemBuilder: (context, index) {
              final disease = diseases[index];
              final diseaseId = disease['id'];
              final diagnosis = disease['diagnosis'];
              final confidence = disease['confidence'];
              final date = disease['date'] as DateTime;

              return Dismissible(
                key: Key(diseaseId), // Benzersiz anahtar
                direction: DismissDirection.endToStart, // Sadece sağdan sola kaydırma
                onDismissed: (direction) async {
                  await deleteDisease(diseaseId); // Firestore'dan sil

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$diagnosis kaydı silindi'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 8, // Daha belirgin bir gölge
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Yuvarlatılmış köşeler
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    leading: const Icon(Icons.medical_services, color: Colors.blue, size: 20),
                    title: Text(
                      diagnosis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$confidence',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Tarih: ${formatDate(date)}',
                          style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
