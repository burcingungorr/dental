import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// 🚀 Kullanıcı kaydı ve Firestore'a kaydetme
  Future<void> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Kullanıcı başarıyla oluşturulursa, Firestore'a kaydedilir
      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'password': password,
          'createdAt': FieldValue.serverTimestamp(), // Kayıt tarihi
          'role': 'user', // Varsayılan rol
        });
      }
    } catch (e) {
      print("Error creating user: $e");
    }
  }

  /// 🚀 Kullanıcı giriş işlemi
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print(" Error signing in: $e");
    }
  }

  /// 🚀 Kullanıcı çıkış işlemi
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print(" Error signing out: $e");
    }
  }

  /// 🔄 Firestore'dan veri okuma
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final uid = currentUser?.uid;
      if (uid == null) {
        throw Exception(" Kullanıcı oturum açmamış.");
      }

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  ///  Firestore'a veri yazma
  Future<void> saveData({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collection).add(data);
      print(" Veri başarıyla Firestore'a kaydedildi.");
    } catch (e) {
      print(" Error saving data to Firestore: $e");
    }
  }

  /// 🔄 Firestore'dan veri silme
  Future<void> deleteData({
    required String collection,
    required String documentId,
  }) async {
    try {
      await _firestore.collection(collection).doc(documentId).delete();
      print(" Veri başarıyla silindi.");
    } catch (e) {
      print(" Error deleting data: $e");
    }
  }
}