import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoruntulerimPage extends StatefulWidget {
  @override
  _GoruntulerimPageState createState() => _GoruntulerimPageState();
}

class _GoruntulerimPageState extends State<GoruntulerimPage> {
  List<Map<String, String>> _images = [];

  @override
  void initState() {
    super.initState();
    _loadImagesFromPreferences();
  }

  Future<void> _loadImagesFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final key = 'saved_images_${currentUser.uid}';
        final savedImages = prefs.getStringList(key) ?? [];
        
        // Görselleri ve tarihlerle birlikte listeye ekleyelim
        setState(() {
          _images = savedImages.map((image) {
            return {
              'image': image,
            };
          }).toList(); 
        });
      }
    } catch (e) {
      _showError('Görseller yüklenirken bir hata oluştu: $e');
    }
  }

  Future<void> _deleteImage(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final key = 'saved_images_${currentUser.uid}';

        setState(() {
          _images.removeAt(index);
        });

        await prefs.setStringList(key, _images.map((imageData) => imageData['image']!).toList());
      }
    } catch (e) {
      _showError('Görsel silinirken bir hata oluştu: $e');
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
      appBar: AppBar(
        title: const Text('Görüntülerim'),
        backgroundColor: Colors.blue,
      ),
      body: _images.isNotEmpty
          ? ListView.builder(
              itemCount: _images.length,
              itemBuilder: (context, index) {
                final imageData = _images[index];
                final image = imageData['image']!;
              
                

                return Dismissible(
                  key: Key(image), // Her öğeye benzersiz bir anahtar atanmalı
                  direction: DismissDirection.endToStart, // Sadece sağdan sola kaydırma
                  onDismissed: (direction) {
                    _deleteImage(index); // Görseli sil
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Görsel silindi.')),
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
                    elevation: 5, // Şık bir gölge
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Görsel
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.memory(
                              base64Decode(image),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text('Kaydedilmiş görüntü bulunamadı.'),
            ),
    );
  }
}
