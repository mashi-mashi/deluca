import 'package:deluca/data/provider/article_provider.dart';
import 'package:deluca/pages/webview_page.dart';
import 'package:deluca/widget/article_card_widget.dart';
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

                    return makeCard(article, () async {
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return WebViewPage(article: article);
                        }),
                      );
                    });
                  } else {
                    return Text('記事がありません');
                  }
                }),
          ));
        }));
  }
}
