import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});

  Future<List<Map<String, dynamic>>> _fetchAppointments() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      print("Kullanıcı oturum açmamış.");
      return [];
    }

    String doctorId = currentUser.uid;
    print("Giriş yapan kullanıcının UID'si (Doktor ID'si): $doctorId");

    try {
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();

      List<Map<String, dynamic>> allAppointments = [];

      for (var userDoc in usersSnapshot.docs) {
        // Kullanıcının adını al (örneğin: displayName)
        String? userName = userDoc.get('name') ?? 'Bilinmeyen Kullanıcı';

        QuerySnapshot appointmentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id)
            .collection('appointment')
            .where('doctor', isEqualTo: doctorId)
            .get();

        for (var doc in appointmentSnapshot.docs) {
          var appointmentData = doc.data() as Map<String, dynamic>;
          appointmentData['userName'] = userName; // Kullanıcı adını ekle
          allAppointments.add(appointmentData);
        }
      }

      if (allAppointments.isEmpty) {
        print("Hiç randevu bulunamadı.");
        return [];
      }

      print("Bulunan randevu sayısı: ${allAppointments.length}");

      // Tarihe göre sıralama (en eski tarih aşağıda, en yeni yukarıda olacak şekilde)
      allAppointments.sort((a, b) {
        DateTime dateA = DateFormat('MM/dd/yyyy HH:mm').parse(a['date']);
        DateTime dateB = DateFormat('MM/dd/yyyy HH:mm').parse(b['date']);
        return dateA.compareTo(dateB);
      });

      return allAppointments;
    } catch (e) {
      print("Randevular alınırken hata oluştu: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Randevularım'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Hiç randevunuz bulunmamaktadır.'));
          }

          final appointments = snapshot.data!;
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final appointmentDate = DateFormat("d/M/yyyy HH:mm").parse(appointment['date']);
              final isPast = appointmentDate.isBefore(DateTime.now());
              final userName = appointment['userName']; // Kullanıcı adı

              return Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: isPast ? Colors.red : Colors.green,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: ListTile(
                  leading: Icon(Icons.person, color: Colors.blue),
                  title: Text('Hasta: $userName'), // Kullanıcı adını göster
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sonuç: ${appointment['result']}'),
                      Text('Açıklama: ${appointment['description']}'),
                    ],
                  ),
                  trailing: Text('Tarih: ${DateFormat('dd/MM/yyyy HH:mm').format(appointmentDate)}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
