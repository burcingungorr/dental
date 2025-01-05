import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorsPage extends StatefulWidget {
  @override
  _DoctorsPageState createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  String? _selectedTeshis;
  String? _selectedDoktorId;
  String? _selectedDoktorName;
  final TextEditingController _aciklamaController = TextEditingController();
  final TextEditingController _tarihController = TextEditingController();
  final TextEditingController _saatController = TextEditingController();

  // Firestore ve Authentication referansları
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Doktor listesi
  List<Map<String, String>> _doctorsList = [];

  // Doktorları Firestore'dan çekmek
  Future<void> _getDoctors() async {
  try {
    final querySnapshot = await _firestore.collection('doctors').get();
    final doctors = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>; 
      return {
        'id': doc.id,
        'name': data['adsoyad'] as String? ?? '', 
      };
    }).toList();

    setState(() {
      _doctorsList = doctors;
    });
  } catch (e) {
    print("Error fetching doctors: $e");
  }
}


  @override
  void initState() {
    super.initState();
    _getDoctors(); // Doktorları al
  }

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
    final User? user = _auth.currentUser;
    final String? uid = user?.uid;

    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen oturum açın.')),
      );
      return;
    }

    if (_selectedTeshis != null && _selectedDoktorId != null) {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('appointment')
          .where('doctor', isEqualTo: _selectedDoktorId)
          .where('date', isEqualTo: "${_tarihController.text} ${_saatController.text}")
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bu tarih ve saatte randevu dolu.')),
        );
      } else {
        await _firestore.collection('users').doc(uid).collection('appointment').add({
          'date': "${_tarihController.text} ${_saatController.text}",
          'description': _aciklamaController.text,
          'doctor': _selectedDoktorId, // Doktor ID'si kaydediliyor
          'result': _selectedTeshis,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Randevu başarıyla kaydedildi.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen gerekli alanları doldurun.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 150),
                    const Text(
                      'RANDEVU OLUŞTUR',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Teşhis Sonucu',
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.medical_services, color: Colors.blue),
                      ),
                      items: [
                        'Tooth Discoloration(Renk Değişimi)',
                        'Mouth Ulcer(Ağız Yarası)',
                        'Hypodontia(Hipoodonti)',
                        'Gingivitis(Dişeti İltihabı)',
                        'Data Caries(Diş Çürüğü)'
                      ].map((String value) {
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
                    ),
                    const SizedBox(height: 20),
                    // Doktor Dropdown
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Doktor',
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.person, color: Colors.blue),
                      ),
                      items: _doctorsList.map((doctor) {
                        return DropdownMenuItem<String>(
                          value: doctor['id'],
                          child: Text(doctor['name']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDoktorId = value;
                          _selectedDoktorName = _doctorsList.firstWhere((doctor) => doctor['id'] == value)['name'];
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _tarihController,
                      decoration: InputDecoration(
                        labelText: 'Tarih',
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.calendar_today, color: Colors.blue),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _saatController,
                      decoration: InputDecoration(
                        labelText: 'Saat',
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.access_time, color: Colors.blue),
                      ),
                      readOnly: true,
                      onTap: () => _selectTime(context),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _aciklamaController,
                      decoration: InputDecoration(
                        labelText: 'Açıklama',
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.comment, color: Colors.blue),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
  onPressed: _saveAppointment,
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue, // Arka plan rengi mavi
    foregroundColor: Colors.white, // Yazı rengi beyaz
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15), // Köşeleri yuvarlat
    ),
    elevation: 5, // Gölge yüksekliği
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // İç dolgu
  ),
  child: const Text(
    'Randevuyu Kaydet',
    style: TextStyle(
      fontSize: 16, // Yazı boyutu
      fontWeight: FontWeight.bold, // Yazı kalınlığı
    ),
  ),
),

                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}