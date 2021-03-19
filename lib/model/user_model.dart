import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final userProvider = ChangeNotifierProvider(
  (ref) => UserModel(),
);

class UserModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => FirebaseAuth.instance.currentUser;
  String? get userId {
    if (isAuthenticated) {
      return FirebaseAuth.instance.currentUser?.uid;
    } else {
      throw ('Unable to retrieve login information...');
    }
  }

  bool get isAuthenticated => FirebaseAuth.instance.currentUser != null;

  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
    'email',
  ]);

  Future<firebase.User?> goolgeLogin() async {
    try {
      final googleSignInAccount = await googleSignIn.signIn();
      final googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      //firebase側に登録
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      //userのid取得
      final loginUser = (await _auth.signInWithCredential(credential)).user;

      if (loginUser == null) {
        throw ('');
      }

      final currentUser = _auth.currentUser;
      assert(loginUser.uid == currentUser?.uid);

      notifyListeners();

      return currentUser;
    } on PlatformException catch (err) {
      // https://github.com/flutter/flutter/issues/44431
      if (err.code == 'sign_in_canceled') {
        print('error sign_in_canceld ${err.toString()}');
      } else {
        rethrow;
      }
    }
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
    print('User Sign Out Google');
  }
}
