import 'package:deluca/data/provider/user_provider.dart';
import 'package:deluca/pages/auth_page.dart';
import 'package:deluca/pages/home_page.dart';
import 'package:deluca/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
        primaryColor: Constants.primaryColor,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.mPlus1pTextTheme(),
      ),
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
