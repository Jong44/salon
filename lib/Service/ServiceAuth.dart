import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  Future<String?> registration({
    required String email,
    required String nama,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if(userCredential.user != null) {
        FirebaseDatabase.instance.ref().child("user").child(userCredential.user!.uid).child("profile").set({
          "nama" : nama,
          "email" : email,
          "password" : password,
          "point" : 0,
          "no_hp" : ""
        });
        FirebaseDatabase.instance.ref().child("user").child(userCredential.user!.uid).set("riwayat");
      }
      return "Register Success ";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'Password Terlalu Pendek';
      } else if (e.code == 'email-already-in-use') {
        return 'Account Telah Digunakan';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Login Success ";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'User tidak ditemukan';
      } else if (e.code == 'wrong-password') {
        return 'Maaf Pasword yang anda gunakan salah';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }
}