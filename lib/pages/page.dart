import 'package:deluca/data/provider/article_provider.dart';
import 'package:deluca/model/article_model.dart';
import 'package:deluca/pages/webview_page.dart';
import 'package:deluca/utils/timestamp_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ArticlePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        body: HookBuilder(builder: (context) {
          final futuerArticle = useProvider(articleProvider);
          final articles = futuerArticle.articles;

          ListTile makeListTile(Article article) => ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                title: Text(
                  article.title,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                          child: LinearProgressIndicator(
                              backgroundColor:
                                  Color.fromRGBO(209, 224, 224, 0.2),
                              value: 1,
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.green))),
                    ),
                    Expanded(
                      flex: 9,
                      child: Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                              formatDatetime(article.createdAt,
                                  format: 'yyyy/MM/dd H:m'),
                              style: TextStyle(color: Colors.white))),
                    ),
                  ],
                ),
                trailing: Icon(Icons.keyboard_arrow_right,
                    color: Colors.white, size: 30.0),
                onTap: () async {
                  await Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) {
                      return WebViewPage(article: article);
                    }),
                  );
                },
              );

          Card makeCard(Article article) {
            return Card(
              elevation: 8.0,
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                child: makeListTile(article),
              ),
            );
          }

          return SafeArea(
              child: RefreshIndicator(
            onRefresh: () async {
              await futuerArticle.load();
            },
            child: ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  if (index < articles.length) {
                    final article = articles[index];
                    if (index == articles.length - 1) {
                      Future(futuerArticle.load);
                    }

                    return makeCard(article);
                  } else {
                    return Text('記事がありません');
                  }
                }),
          ));
        }));
  }
}
