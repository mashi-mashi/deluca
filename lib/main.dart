import 'package:deluca/model/user_model.dart';
import 'package:deluca/pages/auth_page.dart';
import 'package:deluca/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/auth_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'google auth sample',
      theme: ThemeData(
          primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: _LoginCheck(),
    );
  }
}

class _LoginCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _loggedIn = context.read(userProvider).isAuthenticated;
    return _loggedIn ? HomePage() : AuthPage();
  }
}
