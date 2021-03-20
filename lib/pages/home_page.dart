import 'package:deluca/data/provider/bottom_bar_provider.dart';
import 'package:deluca/pages/article_page.dart';
import 'package:deluca/pages/category_page.dart';
import 'package:deluca/pages/pick_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookWidget {

  final List<Widget> _pageList = [
    PickPage(),
    ArticlePage(providerId: '7W95xCWlIwJkRRa9La1y'),
    ArticlePage(providerId: 'hn5ef9fNYNIPV1bXBe2F'),
    CategorySelection(),
  ];


  @override
  Widget build(BuildContext context) {
    final navModel = useProvider(bottomNavigationBarProvider);
    return Scaffold(
      backgroundColor: Color.fromRGBO(40, 40, 40, 1),
      body: _pageList[navModel.currentIndex],
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
            icon: Icon(Icons.home_outlined),
            label: 'Home2',
            backgroundColor: Colors.transparent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            label: 'Category',
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
