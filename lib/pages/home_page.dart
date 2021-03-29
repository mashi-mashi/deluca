import 'package:deluca/data/provider/bottom_bar_provider.dart';
import 'package:deluca/data/provider/user_provider.dart';
import 'package:deluca/data/provider/user_subscription_provider.dart';
import 'package:deluca/pages/article_page.dart';
import 'package:deluca/pages/auth_page.dart';
import 'package:deluca/pages/provider_page.dart';
import 'package:deluca/pages/pick_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userModel = useProvider(userProvider);
    final userSubscriptionModel = useProvider(userSubscriptionProvider);
    final snapshot = useFuture(
        useMemoized(() => userSubscriptionModel.load(), []),
        initialData: null);
    final navModel = useProvider(bottomNavigationBarProvider);

    return Scaffold(
      backgroundColor: Color.fromRGBO(40, 40, 40, 1),
      body: HookBuilder(builder: (context) {
        return snapshot.connectionState == ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : [
                PickPage(),
                ArticlePage(
                    providerId: navModel.currentProviderId ??
                        userSubscriptionModel.subscriptions[0].id),
                ProviderSelection(),
                //UserProfilePage()
              ][navModel.currentIndex];
      }),
      drawer: Drawer(
        child: HookBuilder(builder: (context) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    Container(
                        // TODO: flexにしたい
                        height: MediaQuery.of(context).size.height * 0.85,
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount:
                                userSubscriptionModel.subscriptions.length,
                            itemBuilder: (context, index) {
                              if (index <
                                  userSubscriptionModel.subscriptions.length) {
                                final subscription =
                                    userSubscriptionModel.subscriptions[index];

                                return ListTile(
                                  title: Text(subscription.name),
                                  onTap: () {
                                    navModel.currentProviderId =
                                        subscription.id;
                                    // drawer閉じる
                                    Navigator.pop(context);
                                  },
                                );
                              } else {
                                return Text('登録しているサイトがありません');
                              }
                            })),
                    ListTile(
                      title: Text('Logout'),
                      onTap: () {
                        //navModel.currentProviderId = subscription.id;
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text('ログアウトします'),
                              actions: <Widget>[
                                // ボタン領域
                                OutlinedButton(
                                  child: Text('いいえ'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                OutlinedButton(
                                  child: Text('はい'),
                                  onPressed: () async {
                                    await userModel.signOutGoogle();
                                    await Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) {
                                        return AuthPage();
                                      }),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    )
                  ],
                );
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: navModel.currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          navModel.currentIndex = index;
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
            label: 'Favorite',
            backgroundColor: Colors.transparent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            backgroundColor: Colors.transparent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps_outlined),
            label: 'Category',
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
