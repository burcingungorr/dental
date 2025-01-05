import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DentalPage extends StatefulWidget {
  @override
  _DentalPageState createState() => _DentalPageState();
}

class _DentalPageState extends State<DentalPage> {
  File? _selectedImage;
  final String apiUrl = 'http://192.168.213.245:5000/predict';
  String _diagnosis = '';
  String _diseaseInfo = '';
  String _recommendedDoctor = '';
  double _confidence = 0.0;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _selectImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _diagnoseImage() async {
    if (_selectedImage == null) {
      _showError('Lütfen bir görüntü seçin.');
      return;
    }

    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final data = json.decode(responseData.body);

        setState(() {
          _diagnosis = data['predicted_class'];
          _confidence = (data['confidence'] as double?) ?? 0.0;
          _updateDiagnosisInfo(_diagnosis);
        });

        // Teşhis sonucunu kaydet
        await _saveImageToPreferences(_selectedImage!);
        await _saveDiagnosisToFirestore();
      } else {
        _showError('Sunucu hatası: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Teşhis sırasında bir hata oluştu: $e');
    }
  }

  void _updateDiagnosisInfo(String diagnosis) {
    switch (diagnosis) {
      case 'Data caries':
        _recommendedDoctor = 'Dr. Burçin Güngör';
        _diseaseInfo = 'Diş çürüğü, mine tabakasının zarar görmesiyle oluşur.';
        break;
      case 'Gingivitis':
        _recommendedDoctor = 'Dr. Emre Önre';
        _diseaseInfo = 'Diş eti iltihabı, diş etlerinde şişme ve kanama yapar.';
        break;
      case 'Tooth Discoloration':
        _recommendedDoctor = 'Dr. Reyhan Yanıkoğlu';
        _diseaseInfo = 'Diş renk değişimi genetik veya çevresel faktörlerle oluşabilir.';
        break;
      case 'hypodontia':
        _recommendedDoctor = 'Dr. Zeynep Akdeniz';
        _diseaseInfo = 'Hypodontia, doğuştan diş eksikliği durumudur.';
        break;
      case 'Mouth Ulcer':
        _recommendedDoctor = 'Dr. Levent Aslan';
        _diseaseInfo = 'Ağız yaraları, ağız içinde ağrılı lezyonlar oluşturur.';
        break;
      default:
        _recommendedDoctor = 'Bilinmiyor';
        _diseaseInfo = 'Teşhis bulunamadı.';
    }
  }

 Future<void> _saveImageToPreferences(File image) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);
      final currentUser = _auth.currentUser;

      if (currentUser != null) {
        final key = 'saved_images_${currentUser.uid}';
        final existingData = prefs.getStringList(key) ?? [];
        existingData.add(base64Image);
        await prefs.setStringList(key, existingData);
      }
    } catch (e) {
      _showError('Görsel kaydedilirken bir hata oluştu: $e');
    }
  }



  Future<void> _saveDiagnosisToFirestore() async {
  try {
    final currentUser = _auth.currentUser; // Geçerli kullanıcıyı al
    if (currentUser == null) {
      _showError('Kullanıcı oturumu açık değil.');
      return;
    }

    // Kullanıcı ID'sine göre `dental_results` alt koleksiyonuna ekle
    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('dental_results')
        .add({
      'diagnosis': _diagnosis ?? 'Bilinmiyor',
      'confidence': _confidence ?? 0.0,
      'recommended_doctor': _recommendedDoctor ?? 'Bilinmiyor',
      'disease_info': _diseaseInfo ?? 'Bilgi mevcut değil',
      'date': FieldValue.serverTimestamp(), // Sunucu zamanı
    });

    print('Teşhis Firestore\'a kaydedildi.');
  } catch (e) {
    _showError('Teşhis kaydedilirken bir hata oluştu: $e');
  }
}


  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hata'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 200),
                      const Text(
                        'AĞIZ/DİŞ GÖRÜNTÜNÜ YÜKLE',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildImagePickerButton(Icons.camera_alt, ImageSource.camera),
                          const SizedBox(width: 40),
                          _buildImagePickerButton(Icons.photo, ImageSource.gallery),
                        ],
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: _diagnoseImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Teşhis Et"),
                      ),
                      const SizedBox(height: 20),
                      _selectedImage != null
                          ? Image.file(
                              _selectedImage!,
                              height: 200,
                            )
                          : const SizedBox(height: 200),
                      const SizedBox(height: 20),
                      if (_diagnosis.isNotEmpty) _buildDiagnosisResult(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerButton(IconData icon, ImageSource source) {
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.grey[200],
      child: IconButton(
        iconSize: 50,
        icon: Icon(icon, color: Colors.blue),
        onPressed: () => _selectImage(source),
      ),
    );
  }

  Widget _buildDiagnosisResult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TEŞHİS SONUCU: $_diagnosis',
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 10),
        Text(
          '%${(_confidence * 100).toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
        const SizedBox(height: 10),
        Text(
          'DOKTOR ÖNERİSİ: $_recommendedDoctor',
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
        const SizedBox(height: 10),
        Text(
          'HASTALIK BİLGİSİ: $_diseaseInfo',
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    );
  } 
}

