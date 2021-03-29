import 'package:deluca/data/provider/article_provider.dart';
import 'package:deluca/data/provider/provider_provider.dart';
import 'package:deluca/pages/webview_page.dart';
import 'package:deluca/utils/constants.dart';
import 'package:deluca/widget/article_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ArticlePage extends HookWidget {
  ArticlePage({required this.providerId});
  final String providerId;

  @override
  Widget build(BuildContext context) {
    final providerModel = useProvider(providerProvider);
    final provider = providerModel.providers
        .where((provider) => providerId == provider.id)
        .first;

    return Scaffold(
        appBar: AppBar(title: Text(provider.name)),
        backgroundColor: Constants.pageBackGroundColor,
        body: HookBuilder(builder: (context) {
          final futuerArticle = useProvider(articleProvider);
          final snapshot = useFuture(
              useMemoized(() => futuerArticle.load(providerId), [providerId]),
              initialData: null);

          return snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: RefreshIndicator(
                  onRefresh: () async {
                    await futuerArticle.load(providerId);
                  },
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: futuerArticle.articles.length,
                      itemBuilder: (context, index) {
                        if (index < futuerArticle.articles.length) {
                          final article = futuerArticle.articles[index];
                          if (index == futuerArticle.articles.length - 1) {
                            Future(() {
                              futuerArticle.loadNext(article.createdAt);
                            });
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
        }),
        floatingActionButton: HookBuilder(builder: (context) {
          final futuerArticle = useProvider(articleProvider);
          return Container(
              margin: EdgeInsets.only(bottom: 25.0),
              child: SpeedDial(
                icon: Icons.menu_outlined,
                backgroundColor: Colors.black54,
                foregroundColor: Colors.white,
                activeIcon: Icons.remove,
                buttonSize: 56.0,
                visible: true,
                elevation: 8.0,
                shape: CircleBorder(),
                children: [
                  SpeedDialChild(
                    child: Icon(Icons.favorite),
                    backgroundColor: Colors.black54,
                    foregroundColor: Colors.white,
                    label: 'favorite',
                    labelStyle: TextStyle(fontSize: 18.0),
                    onTap: () async {
                      await futuerArticle.load(providerId);
                    },
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.copy_outlined),
                    backgroundColor: Colors.black54,
                    foregroundColor: Colors.white,
                    label: 'Second',
                    labelStyle: TextStyle(fontSize: 18.0),
                    onTap: () async {
                      await futuerArticle.load(providerId);
                    },
                  ),
                ],
              ));
        }));
  }
}
