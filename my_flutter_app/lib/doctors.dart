import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
class DoctorsPage extends StatefulWidget {
  @override
  _DoctorsPageState createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  String? _selectedTeshis;
  String? _selectedDoktor;
  final TextEditingController _aciklamaController = TextEditingController();
  final TextEditingController _tarihController = TextEditingController();
  final TextEditingController _saatController = TextEditingController();

  // Firestore ve Authentication referansları
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), 
      firstDate: DateTime(2015), 
      lastDate: DateTime(2050), 
    );
    if (picked != null) {
      setState(() {
        _tarihController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _saatController.text = picked.format(context);
      });
    }
  }

  // Randevu verilerini kullanıcıya göre Firestore'a kaydetmek için fonksiyon
  Future<void> _saveAppointment() async {
    // Kullanıcının uid'sini al
    final User? user = _auth.currentUser;
    final String? uid = user?.uid;

    if (uid == null) {
      // Kullanıcı oturum açmamışsa uyarı ver
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen oturum açın.')),
      );
      return;
    }

    if (_selectedTeshis != null && _selectedDoktor != null) {
      // Firestore'a veriyi kullanıcıya göre kaydet
      await _firestore.collection('users').doc(uid).collection('appointment').add({
        'date': "${_tarihController.text} ${_saatController.text}", // Tarih ve saat bilgisi
        'description': _aciklamaController.text, // Açıklama bilgisi
        'doctor': _selectedDoktor, // Doktor bilgisi
        'result': _selectedTeshis, // Teşhis sonucu
      });

      // Kaydedildikten sonra kullanıcıya bildirim göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Randevu başarıyla kaydedildi.')),
      );
    } else {
      // Gerekli alanlar doldurulmamışsa uyarı ver
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen gerekli alanları doldurun.')),
      );
    }
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
              'assets/background.png', // Arka plan resminin yolu
              fit: BoxFit.cover,
            ),
          ),
          // Sayfa içeriği
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'RANDEVU OLUŞTUR',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Teşhis Sonucu',
                      labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(),
                    ),
                    items: ['A', 'B', 'C'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTeshis = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Bu alan gerekli' : null,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Doktor',
                      labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(),
                    ),
                    items: ['BURÇİN GÜNGÖR', 'EMRE ÖNRE', 'LEVENT ASLAN','ZEYNEP AKDENİZ','REYHAN YANIKOĞLU','BURAK ÜNYE'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDoktor = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Bu alan gerekli' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _tarihController,
                    decoration: InputDecoration(
                      labelText: 'Tarih',
                      labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context), // Takvim açılır
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _saatController,
                    decoration: InputDecoration(
                      labelText: 'Saat',
                      labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.access_time, color: Colors.grey),
                    ),
                    readOnly: true,
                    onTap: () => _selectTime(context),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _aciklamaController,
                    decoration: InputDecoration(
                      labelText: 'Açıklama',
                      labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _saveAppointment(); // KAYDET tuşuna basıldığında Firestore'a veri kaydedilir
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white, 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), 
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15), 
                      ),
                      child: Text('KAYDET'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
