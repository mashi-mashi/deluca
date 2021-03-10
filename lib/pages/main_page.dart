import 'package:deluca/data/firebase/firebase_auth.dart';
import 'package:deluca/pages/chat_page.dart';
import 'package:deluca/pages/provider_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Choice {
  const Choice({this.title, this.icon, this.widget});

  final String title;
  final IconData icon;
  final Widget widget;
}

class MainPage extends StatelessWidget {
  MainPage(this.user);

  // ユーザー情報
  final User user;

  final List<Choice> choices = <Choice>[
    Choice(
        title: 'providers', icon: Icons.directions_car, widget: ProviderPage()),
    Choice(
        title: 'picks',
        icon: Icons.login_outlined,
        widget: ChatPage(FirebaseAuthenticate.user)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
          length: choices.length,
          child: Scaffold(
            appBar: AppBar(
              title: Text('tab'),
              bottom: TabBar(
                  tabs: choices.map((choice) {
                return Tab(text: choice.title, icon: Icon(choice.icon));
              }).toList()),
            ),
            body: TabBarView(
              children: choices.map((choice) {
                return choice.widget;
              }).toList(),
            ),
          ),
        )
    );
  }
}
