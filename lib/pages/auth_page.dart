import 'package:deluca/data/provider/user_provider.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ログイン'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ログインしてください'),
            ElevatedButton(
              child: Text('Sign in with Google'),
              onPressed: () async {
                final loginUser = await UserModel().goolgeLogin();
                if (loginUser != null) {
                  await Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) {
                      return HomePage();
                    }),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
