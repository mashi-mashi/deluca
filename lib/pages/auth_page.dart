import 'package:deluca/data/firebase/firebase_auth.dart';
import 'package:deluca/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'home_page.dart';

class AuthPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var user = useState(FirebaseAuthenticate.user);

    var logined = useState(false);

    useEffect(() {
      final storedUser = FirebaseAuthenticate.user;
      print('effect ${storedUser.toString()}');
      user.value = storedUser;
      if (user.value != null) {
        logined.value = true;
        Future.microtask(() async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        });
      }
      return () => {};
    }, const []);

    Widget logoutText = Text('ログインしてください');
    Widget loginText = Text(user.value?.email?.toString() ?? 'メールアドレスが取得できません');

    Widget loginButton = ElevatedButton(
      child: Text('Sign in with Google'),
      onPressed: () async {
        final loginUser = await UserModel().goolgeLogin();
        if (loginUser != null) {
          logined.value = true;
          user.value = loginUser;
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) {
              return HomePage();
            }),
          );
        }
      },
    );
    Widget logoutButton = ElevatedButton(
        child: Text('Sign out'),
        onPressed: () async {
          await UserModel().signOutGoogle();
          logined.value = false;
        });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ログイン'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logined.value ? loginText : logoutText,
            logined.value ? logoutButton : loginButton,
          ],
        ),
      ),
    );
  }
}
