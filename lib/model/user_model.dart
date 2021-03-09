import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final userProvider = ChangeNotifierProvider(
  (ref) => UserModel(),
);

class UserModel extends ChangeNotifier {
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
    'email',
  ]);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  firebase.User _user;

  firebase.User get user => _user;

  bool get isAuthenticated => _user != null;

  Future<firebase.User> goolgeLogin() async {
    final googleSignInAccount = await googleSignIn.signIn();
    final googleSignInAuthentication = await googleSignInAccount.authentication;

    //firebase側に登録
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    //userのid取得
    final loginUser = (await _auth.signInWithCredential(credential)).user;

    assert(!loginUser.isAnonymous);
    assert(await loginUser.getIdToken() != null);

    final currentUser = _auth.currentUser;
    assert(loginUser.uid == currentUser.uid);

    _user = currentUser;
    print('set-user: ${_user.toString()}');
    notifyListeners();

    return currentUser;
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
    print('User Sign Out Google');
  }
}
