import 'package:deluca/data/firebase/firebase_auth.dart';
import 'package:deluca/pages/article_page.dart';
import 'package:deluca/pages/auth_page.dart';
import 'package:deluca/pages/chat_page.dart';
import 'package:deluca/pages/list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Choice {
  const Choice({required this.title, required this.icon, required this.widget});

  final String title;
  final IconData icon;
  final Widget widget;
}

class MainPage extends StatelessWidget {
  MainPage(this.user);

  // ユーザー情報
  final User? user;

  final List<Choice> choices = <Choice>[
    Choice(
        title: 'UI', icon: Icons.web_asset_outlined, widget: ListPage()),
    Choice(
        title: 'articles', icon: Icons.article_outlined, widget: ArticlePage()),
    Choice(
        title: 'picks',
        icon: Icons.bookmark_outline,
        widget: ChatPage(FirebaseAuthenticate.user!)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
      length: choices.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('tab'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                // 内部で保持しているログイン情報等が初期化される
                await FirebaseAuth.instance.signOut();
                // ログイン画面に遷移＋画面を破棄
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return AuthPage(title: '',);
                  }),
                );
              },
            ),
          ],
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
    ));
  }
}
