import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message ?? e.toString());
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message ?? e.toString());
    }
  }

  User? getFirebaseUser() {
    return _auth.currentUser;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  Future<User> signUp(String email, String password) async {
    try {
      final credentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credentials.user!;
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message ?? e.toString());
    }
  }
}
