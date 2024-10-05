import 'package:firebase_auth/firebase_auth.dart';

class UserAuthenticator{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _success = false;

  Future<bool> signInWithEmailAndPassword(
    String email, String password) async {
      try {
        User? user = (await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).user;
        if (user != null) {
          _success = true;
        } 
      } on FirebaseAuthException {
        _success = false;
      }
      return _success;
    }
    
}