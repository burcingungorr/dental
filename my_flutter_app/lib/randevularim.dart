import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // intl paketini içeri aktar

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

    return snapshot.docs.map((doc) {
      return {
        ...doc.data() as Map<String, dynamic>,
        'id': doc.id, // Belge kimliğini ekliyoruz
      };
    }).toList();
  }

  Future<void> deleteAppointment(String appointmentId) async {
    if (currentUser == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('appointment')
        .doc(appointmentId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Randevularım',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.white, // Geri ok simgesinin rengi
        ),
      ),
      backgroundColor: const Color.fromARGB(
          255, 245, 245, 245), // Koyu beyaz arka plan rengi
      body: currentUser == null
          ? const Center(child: const Text('Oturum açmamış kullanıcı'))
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchAppointments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Bir hata oluştu'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Henüz randevunuz yok'));
                }

                return ListView(
                  children: snapshot.data!.map((data) {
                    String appointmentId = data['id'];
                    String doctor = data['doctor'] ?? 'Bilinmiyor';
                    String date = data['date'] ?? 'Tarih yok';
                    String description = data['description'] ?? 'Açıklama yok';
                    String result = data['result'] ?? 'Sonuç yok';

                    // Tarihi DateFormat ile parse et
                    DateTime appointmentDate = DateFormat("d/M/yyyy HH:mm").parse(date);
                    DateTime currentDate = DateTime.now();

                    // Arka plan ve çerçeve rengini belirle
                    bool isPast = appointmentDate.isBefore(currentDate);
                    Color backgroundColor =
                        const Color.fromARGB(255, 230, 229, 229); // Gri arka plan
                    Color borderColor = isPast ? Colors.red : Colors.green; // Çerçeve
                    IconData iconData =
                        isPast ? Icons.close : Icons.access_time; // Simge

                    return Dismissible(
                      key: Key(appointmentId),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) async {
                        // Firestore'dan sil
                        await deleteAppointment(appointmentId);

                        // Ekranda mesaj göster
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Randevu silindi'),
                            duration: Duration(seconds: 2),
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
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        color: backgroundColor,
                        elevation: 4, // Gölge ekleme
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                              color: borderColor,
                              width: 3.0), // Çerçeve rengi ve genişliği
                        ),
                        child: ListTile(
                          title: Text('Hastalık: $result',
                              style: const TextStyle(color: Colors.black)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [ 
                              Text('Tarih: $date',
                                  style: const TextStyle(color: Colors.black)),
                              Text('Açıklama: $description',
                                  style: const TextStyle(color: Colors.black)),
                              Text('Doktor: $doctor',
                                  style: const TextStyle(color: Colors.black)),
                            ],
                          ),
                          trailing: Icon(iconData,
                              color: borderColor, size: 32), // İkonu sağ tarafa yerleştir
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
