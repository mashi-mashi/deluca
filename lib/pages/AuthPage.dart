import 'package:deluca/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthPage extends StatefulWidget {
  AuthPage({
    Key key,
    this.title,
  }) : super(
          key: key,
        );

  final String title;

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State {
  FirebaseUser user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool logined = false;

  Future login(FirebaseUser loginUser) async {
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
    //サインイン画面が表示
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    //firebase側に登録
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    //userのid取得
    final FirebaseUser loginUser =
        (await _auth.signInWithCredential(credential)).user;

    assert(!loginUser.isAnonymous);
    assert(await loginUser.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(loginUser.uid == currentUser.uid);

    await login(loginUser);
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();
    logout();
    print("User Sign Out Google");
  }

  @override
  Widget build(BuildContext context) {
    Widget logoutText = Text("ログアウト中");
    Widget loginText = Text(user?.email?.toString() ?? 'メールアドレスが取得できません');

    Widget loginButton = ElevatedButton(
      child: Text("Sign in with Google"),
      onPressed: signInWithGoogle,
    );
    Widget logoutButton =
        ElevatedButton(child: Text("Sign out"), onPressed: signOutGoogle);

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
