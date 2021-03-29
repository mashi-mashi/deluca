import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final sideNavigationBarProvider =
    ChangeNotifierProvider<SideNavigationBarModel>(
  (ref) => SideNavigationBarModel(),
);

class SideNavigationBarModel extends ChangeNotifier {
  int _currentIndex = 1;
  int get currentIndex => _currentIndex;
  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
