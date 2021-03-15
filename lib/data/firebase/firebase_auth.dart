import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticate {
  static String? get userId {
    if (FirebaseAuthenticate.isAuthenticate()) {
      return FirebaseAuth.instance.currentUser?.uid;
    } else {
      throw ('Unable to retrieve login information...');
    }
  }

  static User? get user => FirebaseAuth.instance.currentUser;
  static bool isAuthenticate() => FirebaseAuth.instance.currentUser != null;
}
