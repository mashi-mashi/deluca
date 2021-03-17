import 'package:deluca/model/user_model.dart';
import 'package:deluca/pages/home_page.dart';
import 'package:deluca/pages/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State {
  User? user;

  bool logined = false;

  Future login(User loginUser) async {
    setState(() {
      logined = true;
      user = loginUser;
    });

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return HomePage();
      }),
    );
  }

  void logout() {
    setState(() {
      logined = false;
    });
  }

  Future signInWithGoogle() async {
    final loginUser = await UserModel().goolgeLogin();
    if (loginUser != null) {
      await login(loginUser);
    }
  }

  Future<void> signOutGoogle() async {
    await UserModel().signOutGoogle();
    logout();
  }

  @override
  Widget build(BuildContext context) {
    Widget logoutText = Text('ログインしてください');
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
