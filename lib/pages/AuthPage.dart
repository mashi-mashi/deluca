import 'package:deluca/main.dart';
import 'package:deluca/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State {
  User user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool logined = false;

  Future login(User loginUser) async {
    setState(() {
      logined = true;
      user = loginUser;
    });

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return ChatPage(user);
      }),
    );
  }

  void logout() {
    setState(() {
      logined = false;
    });
  }

  Future signInWithGoogle() async {
    try {
      final loginUser = await UserModel().goolgeLogin();

      await login(loginUser);
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException');
      print('${e.code}');
    } on Exception catch (e) {
      print('Other Exception');
      print('${e.toString()}');
    }
  }

  Future<void> signOutGoogle() async {
    try {
      await UserModel().signOutGoogle();
      logout();
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException');
      print('${e.code}');
    } on Exception catch (e) {
      print('Other Exception');
      print('${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget logoutText = Text('ログアウト中');
    Widget loginText = Text(user?.email?.toString() ?? 'メールアドレスが取得できません');

    Widget loginButton = ElevatedButton(
      child: Text('Sign in with Google'),
      onPressed: signInWithGoogle,
    );
    Widget logoutButton =
        ElevatedButton(child: Text('Sign out'), onPressed: signOutGoogle);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ログイン'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logined ? loginText : logoutText,
            logined ? logoutButton : loginButton,
          ],
        ),
      ),
    );
  }
}
